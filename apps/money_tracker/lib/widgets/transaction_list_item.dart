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
    final currencyFormatter = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
    final isPositive = transaction.amount > 0;
    final isPending = transaction.status == 'pending';

    return ListTile(
      onTap: () => _showActionMenu(context),
      leading: Stack(
        children: [
          Icon(
            isPositive ? Icons.arrow_downward : Icons.arrow_upward,
            color: isPositive ? Colors.green : Colors.red,
          ),
          if (isPending)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
      title: Text(
        transaction.note?.isNotEmpty == true ? transaction.note! : 'Sans note',
        style: TextStyle(
          color: isPending ? Colors.grey : null,
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
          color: isPositive ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showActionMenu(BuildContext context) {
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
                style: Theme.of(context).textTheme.titleLarge,
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
              if (onValidate != null && transaction.status == 'pending')
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    onValidate!();
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Valider'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              const SizedBox(height: 8),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ],
          ),
        ),
      ),
    );
  }
}
