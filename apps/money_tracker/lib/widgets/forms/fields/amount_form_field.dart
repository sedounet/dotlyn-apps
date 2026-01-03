import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Champ de saisie pour montants avec validation
class AmountFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final bool required;
  final bool allowNegative;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const AmountFormField({
    super.key,
    required this.controller,
    this.label = 'Montant',
    this.hintText,
    this.required = true,
    this.allowNegative = false,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          allowNegative
              ? RegExp(r'^\-?[0-9]*[,.]?[0-9]*$')
              : RegExp(r'^[0-9]*[,.]?[0-9]*$'),
        ),
      ],
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        suffixText: '€',
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
      validator: validator ??
          (value) {
            if (required && (value == null || value.trim().isEmpty)) {
              return 'Ce champ est requis';
            }
            if (value != null && value.isNotEmpty) {
              final normalized = value.replaceAll(',', '.');
              final parsed = double.tryParse(normalized);
              if (parsed == null) {
                return 'Montant invalide';
              }
              if (!allowNegative && parsed < 0) {
                return 'Le montant ne peut pas être négatif';
              }
            }
            return null;
          },
    );
  }
}
