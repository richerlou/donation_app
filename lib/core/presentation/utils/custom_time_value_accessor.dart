import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomTimeOfDayValueAccessor
    extends ControlValueAccessor<TimeOfDay, String> {
  final DateFormat timeOfDayFormat;

  CustomTimeOfDayValueAccessor({DateFormat? timeOfDayFormat})
      : timeOfDayFormat = timeOfDayFormat ?? DateFormat.jm();

  @override
  String modelToViewValue(TimeOfDay? modelValue) {
    final DateTime now = DateTime.now();
    String data = '';

    if (modelValue != null) {
      DateTime newDate = DateTime(
        now.year,
        now.month,
        now.day,
        modelValue.hour,
        modelValue.minute,
      );

      data = timeOfDayFormat.format(newDate);
    }

    return data;
  }

  @override
  TimeOfDay? viewToModelValue(String? viewValue) {
    if (viewValue == null) {
      return null;
    }

    final parts = viewValue.split(':');
    if (parts.length != 2) {
      return null;
    }

    return TimeOfDay(
      hour: int.parse(parts[0].trim()),
      minute: int.parse(parts[1].trim()),
    );
  }
}
