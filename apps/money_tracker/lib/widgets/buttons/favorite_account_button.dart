import 'package:flutter/material.dart';
import '../../data/database/app_database.dart';

/// Bouton de compte favori sur la page d'accueil
class FavoriteAccountButton extends StatelessWidget {
  final int index;
  final Account? account;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const FavoriteAccountButton({
    super.key,
    required this.index,
    required this.account,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasAccount = account != null;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          border: Border.all(
            color: hasAccount
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          color: hasAccount
              ? theme.colorScheme.primary.withValues(alpha: 0.05)
              : theme.colorScheme.surfaceContainerHighest,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: 24,
              color: hasAccount
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 4),
            if (hasAccount)
              Flexible(
                child: Text(
                  account!.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              )
            else
              Text(
                'Vide',
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Rangée de 3 boutons de comptes favoris
class FavoriteAccountsRow extends StatelessWidget {
  final List<Account?> accounts;
  final void Function(int index, Account? account) onTap;
  final void Function(int index)? onLongPress;

  const FavoriteAccountsRow({
    super.key,
    required this.accounts,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: List.generate(3, (index) {
          final account = index < accounts.length ? accounts[index] : null;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: FavoriteAccountButton(
                index: index,
                account: account,
                onTap: () => onTap(index, account),
                onLongPress:
                    onLongPress != null ? () => onLongPress!(index) : null,
              ),
            ),
          );
        }),
      ),
    );
  }
}
