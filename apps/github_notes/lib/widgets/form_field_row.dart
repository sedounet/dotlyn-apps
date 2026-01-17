import 'package:flutter/material.dart';
import 'package:github_notes/widgets/field_help_button.dart';

/// Reusable form field builder to reduce boilerplate in forms with multiple TextFormField entries.
///
/// Features:
/// - Consistent spacing (SizedBox.height: 12) between fields
/// - Built-in help button (optional via helpText)
/// - Validation with custom message
/// - Supports multiline input (minLines/maxLines)
class FormFieldRow extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? helpText;
  final String? Function(String?)? validator;
  final int maxLines;
  final int minLines;
  final TextInputType keyboardType;

  const FormFieldRow({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.helpText,
    this.validator,
    this.maxLines = 1,
    this.minLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            suffixIcon: helpText != null ? FieldHelpButton(message: helpText!) : null,
          ),
          maxLines: maxLines,
          minLines: minLines,
          keyboardType: keyboardType,
          validator: validator,
        ),
        if (maxLines > 1 || minLines > 1) const SizedBox(height: 12),
      ],
    );
  }
}
