import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({
    super.key,
    this.backgroundColor,
    required this.label,
  });

  final Color? backgroundColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: backgroundColor,
      label: Text(label),
      labelStyle: AppStyle.kStyleMedium.copyWith(
        color: AppStyle.kColorWhite,
      ),
    );
  }
}
