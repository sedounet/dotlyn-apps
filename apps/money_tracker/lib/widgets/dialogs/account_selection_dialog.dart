import 'package:flutter/material.dart';
import '../../data/database/app_database.dart';

/// Dialog de sélection d'un compte
class AccountSelectionDialog extends StatelessWidget {
  final String title;
  final List<Account> accounts;
  final int? excludeAccountId;

  const AccountSelectionDialog({
    super.key,
    required this.title,
    required this.accounts,
    this.excludeAccountId,
  });

  /// Affiche le dialog et retourne le compte sélectionné
  static Future<Account?> show({
    required BuildContext context,
    required String title,
    required List<Account> accounts,
    int? excludeAccountId,
  }) {
    return showDialog<Account>(
      context: context,
      builder: (context) => AccountSelectionDialog(
        title: title,
        accounts: accounts,
        excludeAccountId: excludeAccountId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredAccounts = excludeAccountId != null
        ? accounts.where((a) => a.id != excludeAccountId).toList()
        : accounts;

    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: filteredAccounts.length,
          itemBuilder: (context, index) {
            final account = filteredAccounts[index];
            return ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: Text(account.name),
              subtitle: Text(account.type),
              onTap: () => Navigator.of(context).pop(account),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
      ],
    );
  }
}
