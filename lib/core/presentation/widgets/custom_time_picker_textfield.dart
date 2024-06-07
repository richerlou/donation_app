import 'package:donation_management/core/presentation/utils/custom_time_value_accessor.dart';
import 'package:donation_management/core/presentation/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomTimePickerTextField extends StatelessWidget {
  const CustomTimePickerTextField({
    super.key,
    required this.formControlName,
    this.label,
    this.validationMessages,
    this.filled = false,
  });

  final String formControlName;
  final String? label;
  final Map<String, String Function(Object)>? validationMessages;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
      child: ReactiveTimePicker(
        formControlName: formControlName,
        builder: (_, picker, ___) {
          return CustomTextField(
            formControlName,
            label: label ?? '',
            readOnly: true,
            filled: filled,
            valueAccessor: CustomTimeOfDayValueAccessor(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.access_time_rounded),
              onPressed: () {
                picker.showPicker();
              },
            ),
            validationMessages: validationMessages,
          );
        },
      ),
    );
  }
}
