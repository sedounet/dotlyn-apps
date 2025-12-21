import 'package:flutter/material.dart';

class StepButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const StepButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(minimumSize: const Size(220, 56)),
      child: Text(label, style: const TextStyle(fontSize: 20)),
    );
  }
}
