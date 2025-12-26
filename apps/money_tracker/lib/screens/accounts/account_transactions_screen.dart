import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/database/app_database.dart';
import '../../providers/accounts_provider.dart';
import '../../providers/transactions_provider.dart';
import '../../widgets/forms/transaction_form_sheet.dart';
import '../../widgets/transaction_list_item.dart';

class AccountTransactionsScreen extends ConsumerWidget {
  final Account account;

  const AccountTransactionsScreen({super.key, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider(account.id));
    final currentBalance = ref.watch(accountBalanceProvider(account.id));
    final availableBalance = ref.watch(accountAvailableBalanceProvider(account.id));
    final currencyFormatter = NumberFormat.currency(locale: 'fr_FR', symbol: '€');

    return Scaffold(
      appBar: AppBar(title: Text(account.name)),
      body: Column(
        children: [
          // Soldes du compte
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Disponible',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currencyFormatter.format(availableBalance ?? 0),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Actuel', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(
                            currencyFormatter.format(currentBalance ?? 0),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Liste des transactions
          Expanded(
            child: transactionsAsync.when(
              data: (transactions) {
                if (transactions.isEmpty) {
                  return const Center(
                    child: Text('Aucune opération', style: TextStyle(color: Colors.grey)),
                  );
                }

                // Calculate balance after each transaction
                double runningBalance = currentBalance ?? 0;

                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    final balanceAfter = runningBalance;
                    runningBalance -= transaction.amount;

                    return TransactionListItem(
                      transaction: transaction,
                      balanceAfter: balanceAfter,
                      onEdit: () => _editTransaction(context, transaction),
                      onDelete: () => _deleteTransaction(context, ref, transaction),
                      onValidate: () => _validateTransaction(ref, transaction),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Erreur: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTransaction(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTransaction(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => TransactionFormSheet(accountId: account.id),
    );
  }

  void _editTransaction(BuildContext context, Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => TransactionFormSheet(transaction: transaction),
    );
  }

  Future<void> _deleteTransaction(
    BuildContext context,
    WidgetRef ref,
    Transaction transaction,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Voulez-vous vraiment supprimer cette opération ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final repo = ref.read(transactionsRepositoryProvider);
      await repo.deleteTransaction(transaction.id);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Opération supprimée')));
      }
    }
  }

  Future<void> _validateTransaction(WidgetRef ref, Transaction transaction) async {
    final repo = ref.read(transactionsRepositoryProvider);
    final newStatus = transaction.status == 'pending' ? 'validated' : 'pending';
    await repo.updateTransaction(
      id: transaction.id,
      accountId: transaction.accountId,
      categoryId: transaction.categoryId,
      beneficiaryId: transaction.beneficiaryId,
      accountToId: transaction.accountToId,
      amount: transaction.amount,
      date: transaction.date,
      note: transaction.note,
      status: newStatus,
    );
  }
}
