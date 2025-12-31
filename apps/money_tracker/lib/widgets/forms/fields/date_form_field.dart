import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Champ de saisie pour date avec picker
class DateFormField extends StatelessWidget {
  final DateTime selectedDate;
  final String label;
  final void Function(DateTime) onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const DateFormField({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.label = 'Date',
    this.firstDate,
    this.lastDate,
  });

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd/MM/yyyy');
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(dateFormatter.format(selectedDate)),
      ),
    );
  }
}
