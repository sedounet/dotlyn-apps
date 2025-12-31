import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/database/app_database.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final double balanceAfter;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onValidate;

  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.balanceAfter,
    this.onEdit,
    this.onDelete,
    this.onValidate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormatter = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: '€',
    );
    final isPositive = transaction.amount > 0;
    final isPending = transaction.status == 'pending';

    return ListTile(
      onTap: () => _showActionMenu(context),
      leading: Stack(
        children: [
          Icon(
            isPositive ? Icons.arrow_downward : Icons.arrow_upward,
            color: isPositive
                ? theme.colorScheme.tertiary
                : theme.colorScheme.error,
          ),
          if (isPending)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
      title: Text(
        transaction.note?.isNotEmpty == true ? transaction.note! : 'Sans note',
        style: TextStyle(
          color: isPending
              ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
              : null,
          fontStyle: isPending ? FontStyle.italic : null,
        ),
      ),
      subtitle: Text(
        '${DateFormat('EEE dd MMM HH:mm', 'fr_FR').format(transaction.date)}\n'
        'Solde après : ${currencyFormatter.format(balanceAfter)}',
      ),
      trailing: Text(
        currencyFormatter.format(transaction.amount.abs()),
        style: TextStyle(
          color: isPositive
              ? theme.colorScheme.tertiary
              : theme.colorScheme.error,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showActionMenu(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Actions',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (onEdit != null)
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    onEdit!();
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Éditer'),
                ),
              const SizedBox(height: 8),
              if (onValidate != null)
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    onValidate!();
                  },
                  icon: Icon(
                    transaction.status == 'pending'
                        ? Icons.check_circle
                        : Icons.cancel,
                  ),
                  label: Text(
                    transaction.status == 'pending' ? 'Valider' : 'Dévalider',
                  ),
                  style: transaction.status == 'pending'
                      ? ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.tertiary,
                          foregroundColor: theme.colorScheme.onTertiary,
                        )
                      : null,
                ),
              const SizedBox(height: 8),
              if (onDelete != null)
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    onDelete!();
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Supprimer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                  ),
                ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
