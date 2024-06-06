// ignore_for_file: depend_on_referenced_packages

import 'package:donation_management/core/presentation/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:intl/intl.dart';

class CustomDatePickerTextField extends StatelessWidget {
  const CustomDatePickerTextField({
    super.key,
    required this.formControlName,
    this.label,
    this.validationMessages,
  });

  final String formControlName;
  final String? label;
  final Map<String, String Function(Object)>? validationMessages;

  @override
  Widget build(BuildContext context) {
    return ReactiveDatePicker<DateTime>(
      formControlName: formControlName,
      firstDate: DateTime(1985),
      lastDate: DateTime(3000),
      builder: (_, picker, ___) {
        return CustomTextField(
          formControlName,
          label: label ?? '',
          readOnly: true,
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
