import 'package:flutter/material.dart';

/// Dropdown personnalisé avec type générique
class DropdownFormFieldCustom<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String label;
  final String? hintText;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool required;

  const DropdownFormFieldCustom({
    super.key,
    required this.value,
    required this.items,
    required this.label,
    this.hintText,
    this.onChanged,
    this.validator,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      validator: validator ??
          (value) {
            if (required && value == null) {
              return 'Ce champ est requis';
            }
            return null;
          },
    );
  }
}
