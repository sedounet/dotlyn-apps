import 'package:flutter/material.dart';

class ActionButtonsBar extends StatelessWidget {
  final VoidCallback onAdd;
  final VoidCallback onTransfer;
  final VoidCallback onRemove;

  const ActionButtonsBar({
    Key? key,
    required this.onAdd,
    required this.onTransfer,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: 'remove',
            onPressed: onRemove,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'transfer',
            onPressed: onTransfer,
            child: const Icon(Icons.swap_horiz),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(heroTag: 'add', onPressed: onAdd, child: const Icon(Icons.add)),
        ],
      ),
    );
  }
}
