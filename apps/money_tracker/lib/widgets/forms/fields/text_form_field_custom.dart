import 'package:flutter/material.dart';

/// Champ de texte personnalisé avec validation commune
class TextFormFieldCustom extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final bool required;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const TextFormFieldCustom({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.required = true,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: minLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
      validator:
          validator ??
          (value) {
            if (required && (value == null || value.trim().isEmpty)) {
              return 'Ce champ est requis';
            }
            return null;
          },
    );
  }
}
