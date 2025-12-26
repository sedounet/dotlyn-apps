import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/database/app_database.dart';
import '../../providers/accounts_provider.dart';
import '../../widgets/forms/account_form_sheet.dart';
import 'account_transactions_screen.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  Future<void> _showAccountForm(BuildContext context, WidgetRef ref, {Account? account}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AccountFormSheet(account: account),
    );
  }

  void _navigateToTransactions(BuildContext context, Account account) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AccountTransactionsScreen(account: account)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);
    final activeAccount = ref.watch(activeAccountProvider);
    final currencyFormatter = NumberFormat.simpleCurrency(locale: 'fr_FR');

    return Scaffold(
      appBar: AppBar(title: const Text('Mes Comptes')),
      body: accountsAsync.when(
        data: (accounts) {
          if (accounts.isEmpty) {
            return const Center(child: Text('Aucun compte. Créez-en un.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final account = accounts[index];
              return ListTile(
                title: Text(account.name),
                subtitle: Text(
                  '${account.type.capitalize()} • Solde initial : ${currencyFormatter.format(account.initialBalance)}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _showAccountForm(context, ref, account: account),
                  tooltip: 'Éditer',
                ),
                onTap: () => _navigateToTransactions(context, account),
              );
            },
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemCount: accounts.length,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAccountForm(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}

extension on String {
  String capitalize() => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
