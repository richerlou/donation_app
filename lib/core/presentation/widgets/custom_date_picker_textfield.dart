import 'package:donation_management/core/presentation/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:intl/intl.dart';

class CustomDatePickerTextField extends StatelessWidget {
  const CustomDatePickerTextField({
    super.key,
    required this.formControlName,
    this.label,
    this.firstDate,
    this.lastDate,
    required this.validationMessages,
    this.filled = false,
  });

  final String formControlName;
  final String? label;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Map<String, String Function(Object)> validationMessages;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return ReactiveDatePicker<DateTime>(
      formControlName: formControlName,
      firstDate: firstDate ?? DateTime(1985),
      lastDate: lastDate ?? DateTime(3000),
      builder: (_, picker, ___) {
        return CustomTextField(
          formControlName,
          label: label ?? '',
          readOnly: true,
          filled: filled,
          valueAccessor: DateTimeValueAccessor(
            dateTimeFormat: DateFormat('MMMM dd, yyyy'),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.date_range_outlined),
            onPressed: () {
              picker.showPicker();
            },
          ),
          validationMessages: validationMessages,
        );
      },
    );
  }
}
