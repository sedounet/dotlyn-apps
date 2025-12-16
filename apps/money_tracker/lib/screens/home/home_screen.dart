import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
// drift & AppDatabase not needed directly here
import '../../providers/accounts_provider.dart';
import '../../providers/database_provider.dart';
import '../../providers/transactions_provider.dart';
import '../../widgets/forms/transaction_form_sheet.dart';
import '../accounts/accounts_screen.dart';
import '../settings/settings_screen.dart';
import '../beneficiaries/beneficiaries_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);
    final activeAccount = ref.watch(activeAccountProvider);
    final currencyFormatter = NumberFormat.currency(locale: 'fr_FR', symbol: '€');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.visibility_off),
            onPressed: () {}, // TODO: Add functionality
          ),
        ],
      ),
      body: accountsAsync.when(
        data: (_) => Column(
          children: [
            // Account Info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activeAccount?.name ?? 'Aucun compte',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Solde Réel: ${currencyFormatter.format(activeAccount?.initialBalance ?? 0)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Solde Disponible: ${currencyFormatter.format(activeAccount?.initialBalance ?? 0)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AccountsScreen()),
                          );
                        },
                        icon: const Icon(Icons.account_balance_wallet),
                        label: const Text('Changer de compte'),
                      ),
                      const SizedBox(width: 12),
                      if (activeAccount == null) const Text('Créez un compte pour commencer.'),
                    ],
                  ),
                ],
              ),
            ),
            // Transactions List
            Expanded(
              child: activeAccount == null
                  ? const Center(child: Text('Créez un compte pour voir les transactions.'))
                  : ref
                        .watch(transactionsProvider(activeAccount.id))
                        .when(
                          data: (transactions) {
                            if (transactions.isEmpty) {
                              return const Center(child: Text('Aucune transaction'));
                            }

                            final currentBalance = ref.watch(
                              accountBalanceProvider(activeAccount.id),
                            );
                            final availableBalance = ref.watch(
                              accountAvailableBalanceProvider(activeAccount.id),
                            );

                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Solde Actuel: ${currencyFormatter.format(currentBalance)}',
                                      ),
                                      Text(
                                        'Solde Disponible: ${currencyFormatter.format(availableBalance)}',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: transactions.length,
                                    itemBuilder: (context, index) {
                                      final transaction = transactions[index];
                                      return Dismissible(
                                        key: ValueKey(transaction.id),
                                        direction: DismissDirection.endToStart,
                                        onDismissed: (_) async {
                                          await ref
                                              .read(transactionsRepositoryProvider)
                                              .deleteTransaction(transaction.id);
                                        },
                                        background: Container(
                                          color: Colors.red,
                                          alignment: Alignment.centerRight,
                                          padding: const EdgeInsets.only(right: 16),
                                          child: const Icon(Icons.delete, color: Colors.white),
                                        ),
                                        child: ListTile(
                                          leading: Icon(
                                            transaction.accountToId != null
                                                ? Icons
                                                      .swap_horiz // Transfer icon
                                                : (transaction.amount > 0
                                                      ? Icons.arrow_downward
                                                      : Icons.arrow_upward),
                                            color: transaction.accountToId != null
                                                ? Colors.blue
                                                : (transaction.amount > 0
                                                      ? Colors.green
                                                      : Colors.red),
                                          ),
                                          title: Text(
                                            transaction.accountToId != null
                                                ? 'Virement ${transaction.note != null && transaction.note!.isNotEmpty ? '- ${transaction.note}' : ''}'
                                                : (transaction.note ?? 'Pas de note'),
                                          ),
                                          subtitle: Text(transaction.date.toLocal().toString()),
                                          trailing: Text(
                                            currencyFormatter.format(transaction.amount.abs()),
                                            style: TextStyle(
                                              color: transaction.accountToId != null
                                                  ? Colors.blue
                                                  : (transaction.amount > 0
                                                        ? Colors.green
                                                        : Colors.red),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onTap: () => showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (_) =>
                                                TransactionFormSheet(transaction: transaction),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, s) => Center(child: Text('Erreur: $e')),
                        ),
            ),
            // Placeholder for Ad Banner
            Container(
              height: 50,
              color: Colors.grey[300],
              child: const Center(child: Text('Ad Banner Placeholder')),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'remove',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: const TransactionFormSheet(defaultType: 'expense'),
                ),
              );
            },
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'transfer',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: const TransactionFormSheet(defaultType: 'transfer'),
                ),
              );
            },
            child: const Icon(Icons.swap_horiz),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: const TransactionFormSheet(defaultType: 'income'),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: const Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(title: const Text('Accueil'), onTap: () => Navigator.pop(context)),
            ListTile(
              title: const Text('Mes Comptes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountsScreen()));
              },
            ),
            ListTile(title: const Text('Catégories'), onTap: () => Navigator.pop(context)),
            ListTile(
              title: const Text('Bénéficiaires'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BeneficiariesScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Paramètres'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
              },
            ),
            if (kDebugMode)
              ListTile(
                title: const Text('Reset DB (dev)'),
                subtitle: const Text('Supprime et reseed la DB pour tests'),
                onTap: () async {
                  Navigator.pop(context);
                  final confirmed =
                      await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Réinitialiser la base de données'),
                          content: const Text(
                            'Confirmer la suppression de toutes les données et reseed ?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Annuler'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      ) ??
                      false;
                  if (!confirmed) return;

                  final db = ref.read(databaseProvider);
                  final messenger = ScaffoldMessenger.of(context);
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Réinitialisation en cours...')),
                  );
                  await db.resetToDefaultData(includeFakeData: true);
                  messenger.showSnackBar(const SnackBar(content: Text('Base réinitialisée')));
                },
              ),
            ListTile(title: const Text('À propos'), onTap: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}
