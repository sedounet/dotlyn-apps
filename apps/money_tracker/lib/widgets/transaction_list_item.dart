import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionListItem extends StatelessWidget {
  final String note;
  final DateTime date;
  final double amount;
  final double balanceAfter;
  final VoidCallback onTap;

  const TransactionListItem({
    super.key,
    required this.note,
    required this.date,
    required this.amount,
    required this.balanceAfter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
    final isPositive = amount > 0;

    return ListTile(
      onTap: onTap,
      leading: Icon(
        isPositive ? Icons.arrow_downward : Icons.arrow_upward,
        color: isPositive ? Colors.green : Colors.red,
      ),
      title: Text(note.isNotEmpty ? note : 'Sans note'),
      subtitle: Text(
        '${DateFormat('EEE dd MMM HH:mm', 'fr_FR').format(date)}\nSolde après : ${currencyFormatter.format(balanceAfter)}',
      ),
      trailing: Text(
        currencyFormatter.format(amount.abs()),
        style: TextStyle(
          color: isPositive ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
