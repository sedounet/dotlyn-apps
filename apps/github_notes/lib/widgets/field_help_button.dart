import 'package:flutter/material.dart';

/// Reusable IconButton for field help — opens bottom sheet with message on tap.
class FieldHelpButton extends StatelessWidget {
  final String message;

  const FieldHelpButton({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info_outline),
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (ctx) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text(message),
          ),
        );
      },
    );
  }
}
