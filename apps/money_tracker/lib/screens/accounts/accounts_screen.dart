import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../providers/accounts_provider.dart';
import '../../utils/currency_utils.dart';
import '../../utils/string_extensions.dart';
import '../../widgets/widgets.dart';
import 'account_transactions_screen.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  Future<void> _showAccountForm(BuildContext context, WidgetRef ref,
      {Account? account}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => AccountFormSheet(account: account),
    );
  }

  void _navigateToTransactions(BuildContext context, Account account) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => AccountTransactionsScreen(account: account)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes Comptes')),
      body: accountsAsync.when(
        data: (accounts) {
          if (accounts.isEmpty) {
            return const EmptyListWidget(
              icon: Icons.account_balance_wallet_outlined,
              message: 'Aucun compte',
              subMessage: 'Créez-en un avec le bouton +',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final account = accounts[index];
              return ListTile(
                title: Text(account.name),
                subtitle: Text(
                  '${account.type.capitalize()} • Solde initial : ${CurrencyUtils.format(account.initialBalance)}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () =>
                      _showAccountForm(context, ref, account: account),
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
      floatingActionButton: ActionFab(
        icon: Icons.add,
        heroTag: 'add_account',
        onPressed: () => _showAccountForm(context, ref),
      ),
    );
  }
}
