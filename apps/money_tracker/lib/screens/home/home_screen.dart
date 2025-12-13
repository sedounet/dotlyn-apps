import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import '../../providers/database_provider.dart';
import '../../widgets/forms/add_transaction_sheet.dart';
import '../accounts/accounts_screen.dart';
import '../settings/settings_screen.dart';
import '../beneficiaries/beneficiaries_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(databaseProvider);
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
      body: Column(
        children: [
          // Account Info
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Compte Courant', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  'Solde Réel: ${currencyFormatter.format(1000)}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Solde Disponible: ${currencyFormatter.format(900)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          // Transactions List
          Expanded(
            child: FutureBuilder(
              future: database.select(database.transactions).join([
                drift.leftOuterJoin(
                  database.categories,
                  database.categories.id.equalsExp(database.transactions.categoryId),
                ),
                drift.leftOuterJoin(
                  database.beneficiaries,
                  database.beneficiaries.id.equalsExp(database.transactions.beneficiaryId),
                ),
              ]).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                }
                final transactions = snapshot.data ?? [];
                if (transactions.isEmpty) {
                  return const Center(child: Text('Aucune transaction'));
                }
                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final row = transactions[index];
                    final transaction = row.readTable(database.transactions);
                    final category = row.readTableOrNull(database.categories);
                    final beneficiary = row.readTableOrNull(database.beneficiaries);

                    return ListTile(
                      leading: Icon(
                        transaction.amount > 0 ? Icons.arrow_downward : Icons.arrow_upward,
                        color: transaction.amount > 0 ? Colors.green : Colors.red,
                      ),
                      title: Text(category?.name ?? 'Sans catégorie'),
                      subtitle: Text(beneficiary?.name ?? 'Sans bénéficiaire'),
                      trailing: Text(
                        currencyFormatter.format(transaction.amount.abs()),
                        style: TextStyle(
                          color: transaction.amount > 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                );
              },
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
                  child: const AddTransactionSheet(),
                ),
              );
            },
            child: const Icon(Icons.remove),
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
                  child: const AddTransactionSheet(),
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
            ListTile(title: const Text('À propos'), onTap: () => Navigator.pop(context)),
            ListTile(title: Text('À propos')),
          ],
        ),
      ),
    );
  }
}
