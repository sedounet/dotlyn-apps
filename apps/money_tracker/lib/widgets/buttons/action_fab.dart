import 'package:flutter/material.dart';
import 'package:dotlyn_ui/dotlyn_ui.dart';

/// Bouton d'action rapide (FAB mini) pour +/- et virements
class ActionFab extends StatelessWidget {
  final IconData icon;
  final String heroTag;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final double size;
  final double iconSize;

  const ActionFab({
    super.key,
    required this.icon,
    required this.heroTag,
    required this.onPressed,
    this.backgroundColor,
    this.size = 40,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: size,
      height: size,
      child: FloatingActionButton(
        heroTag: heroTag,
        onPressed: onPressed,
        backgroundColor: backgroundColor ?? theme.colorScheme.primary,
        child: Icon(icon, size: iconSize),
      ),
    );
  }
}

/// Groupe de boutons d'action (+/- et virement)
class ActionButtonsRow extends StatelessWidget {
  final VoidCallback onIncome;
  final VoidCallback onExpense;
  final VoidCallback onTransfer;

  const ActionButtonsRow({
    super.key,
    required this.onIncome,
    required this.onExpense,
    required this.onTransfer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ActionFab(
            heroTag: 'remove',
            icon: Icons.remove,
            onPressed: onExpense,
          ),
          const SizedBox(width: 12),
          ActionFab(
            heroTag: 'transfer',
            icon: Icons.swap_horiz,
            onPressed: onTransfer,
          ),
          const SizedBox(width: 12),
          ActionFab(heroTag: 'add', icon: Icons.add, onPressed: onIncome),
        ],
      ),
    );
  }
}
