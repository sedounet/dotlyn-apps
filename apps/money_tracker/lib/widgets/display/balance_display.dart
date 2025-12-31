import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Widget pour afficher un solde formaté avec label
class BalanceDisplay extends StatelessWidget {
  final String label;
  final double? balance;
  final bool isVisible;
  final bool highlightNegative;
  final double fontSize;

  const BalanceDisplay({
    super.key,
    required this.label,
    required this.balance,
    this.isVisible = true,
    this.highlightNegative = false,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormatter = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: '€',
    );

    final isNegative = (balance ?? 0) < 0;
    final valueColor = highlightNegative && isNegative
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isVisible ? currencyFormatter.format(balance ?? 0) : '***',
          style: TextStyle(
            color: valueColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// Ligne avec soldes disponible et actuel
class BalanceRow extends StatelessWidget {
  final double? availableBalance;
  final double? currentBalance;
  final bool isVisible;
  final VoidCallback? onToggleVisibility;

  const BalanceRow({
    super.key,
    required this.availableBalance,
    required this.currentBalance,
    this.isVisible = true,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: BalanceDisplay(
              label: 'Disponible',
              balance: availableBalance,
              isVisible: isVisible,
              highlightNegative: true,
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: BalanceDisplay(
              label: 'Actuel',
              balance: currentBalance,
              isVisible: isVisible,
            ),
          ),
          if (onToggleVisibility != null)
            IconButton(
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: onToggleVisibility,
              tooltip: 'Afficher/Masquer',
            ),
        ],
      ),
    );
  }
}
