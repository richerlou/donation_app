import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
    this.formControlName, {
    super.key,
    this.formInsetPadding,
    this.label,
    this.validationMessages,
    this.obscureText = false,
    this.suffixIcon,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.filled = false,
    this.prefix,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.enableLabel = true,
    this.textfieldBorderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.textfieldBorderColor,
    this.prefixWidget,
    this.disable = false,
    this.fillColor,
    this.prefixIcon,
    this.errorMaxLines = 2,
    this.readOnly = false,
    this.valueAccessor,
    this.subtleText,
  });

  final String? formControlName;
  final EdgeInsets? formInsetPadding;
  final String? label;
  final Map<String, String Function(Object)>? validationMessages;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final bool filled;
  final Widget? prefix;
  final int maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool enableLabel;
  final BorderRadius textfieldBorderRadius;
  final Color? textfieldBorderColor;
  final Widget? prefixWidget;
  final bool disable;
  final Color? fillColor;
  final Widget? prefixIcon;
  final int errorMaxLines;
  final bool readOnly;
  final dynamic valueAccessor;
  final String? subtleText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: formInsetPadding ?? const EdgeInsets.only(bottom: 24.0),
      child: ReactiveTextField<dynamic>(
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        formControlName: formControlName,
        obscureText: obscureText,
        style: AppStyle.kStyleRegular,
        maxLines: maxLines,
        maxLength: maxLength,
        readOnly: readOnly,
        valueAccessor: valueAccessor,
        decoration: InputDecoration(
          filled: filled,
          fillColor: filled
              ? fillColor ?? AppStyle.kColorGrey.withOpacity(0.50)
              : null,
          hintText: !enableLabel ? label ?? '' : null,
          hintStyle: AppStyle.kStyleMedium.copyWith(
            color: AppStyle.kColorGrey2,
          ),
          labelText: enableLabel ? label ?? '' : null,
          labelStyle: AppStyle.kStyleMedium.copyWith(
            color: AppStyle.kColorGrey2,
          ),
          errorStyle: AppStyle.kStyleError,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: textfieldBorderColor ?? AppStyle.kColorGrey,
            ),
            borderRadius: textfieldBorderRadius,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: textfieldBorderColor ?? AppStyle.kColorBlue,
            ),
            borderRadius: textfieldBorderRadius,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: textfieldBorderColor ?? AppStyle.kColorBlue,
            ),
            borderRadius: textfieldBorderRadius,
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color:
                  textfieldBorderColor ?? AppStyle.kColorGrey.withOpacity(0.50),
            ),
            borderRadius: textfieldBorderRadius,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          prefix: prefixWidget,
          errorMaxLines: errorMaxLines,
          counterText: subtleText ?? '',
          counterStyle: AppStyle.kStyleRegular.copyWith(
            color: AppStyle.kColorGrey2,
            fontSize: 14.sp,
          ),
        ),
        validationMessages: validationMessages,
        inputFormatters: inputFormatters,
      ),
    );
  }
}
