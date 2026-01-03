import 'package:flutter/material.dart';

/// Widget pour afficher une ligne de statistique (label + valeur)
class StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final TextStyle? valueStyle;

  const StatRow(
      {super.key,
      required this.label,
      required this.value,
      this.icon,
      this.valueStyle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          ),
          Text(value,
              style:
                  valueStyle ?? const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
