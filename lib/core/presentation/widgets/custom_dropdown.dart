import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomDropdown<T> extends StatelessWidget {
  const CustomDropdown(
    this.formControlName, {
    super.key,
    required this.items,
    this.formInsetPadding,
    this.label,
    required this.validationMessages,
    this.obscureText = false,
    this.suffixIcon,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.filled = false,
  });

  final String? formControlName;
  final List<DropdownMenuItem<T>> items;
  final EdgeInsets? formInsetPadding;
  final String? label;
  final Map<String, String Function(Object)> validationMessages;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final void Function(FormControl<T>)? onChanged;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: formInsetPadding ?? EdgeInsets.only(bottom: 24.h),
      child: ReactiveDropdownField<T>(
        formControlName: formControlName,
        style: AppStyle.kStyleRegular,
        items: items,
        decoration: InputDecoration(
          filled: filled,
          fillColor: filled ? Colors.grey.withOpacity(0.50) : null,
          labelText: label ?? '',
          labelStyle: AppStyle.kStyleMedium.copyWith(
            color: AppStyle.kColorGrey2,
          ),
          errorStyle: AppStyle.kStyleError,
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AppStyle.kPrimaryColor,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AppStyle.kPrimaryColor,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppStyle.kColorGrey.withOpacity(0.50),
            ),
          ),
          suffixIcon: suffixIcon,
        ),
        validationMessages: validationMessages,
        onChanged: onChanged,
      ),
    );
  }
}
