import 'package:flutter/material.dart';

typedef LabelBuilder = String Function(BuildContext context);

class CardMenuAction {
  final LabelBuilder labelBuilder;
  final VoidCallback onSelected;
  final IconData? icon;

  const CardMenuAction({
    required this.labelBuilder,
    required this.onSelected,
    this.icon,
  });
}

/// A small reusable popup menu used on cards to keep menu UI consistent.
class CardMenu extends StatelessWidget {
  final List<CardMenuAction> actions;
  final IconData icon;
  final String? tooltip;

  const CardMenu({
    super.key,
    required this.actions,
    this.icon = Icons.more_vert,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: tooltip ?? '',
      icon: Icon(icon),
      onSelected: (index) => actions[index].onSelected(),
      itemBuilder: (ctx) => List<PopupMenuEntry<int>>.generate(
        actions.length,
        (i) {
          final a = actions[i];
          return PopupMenuItem<int>(
            value: i,
            child: Row(
              children: [
                if (a.icon != null) ...[
                  Icon(a.icon, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(a.labelBuilder(ctx)),
              ],
            ),
          );
        },
      ),
    );
  }
}
