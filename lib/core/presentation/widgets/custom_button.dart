import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.buttonInsetPadding = EdgeInsets.zero,
    required this.onPressed,
    this.buttonTitle,
    this.titleTextStyle,
    this.width = double.infinity,
    this.height = 0.0,
    this.buttonColor,
    this.splashButtonColor,
    this.borderRadius = 4.0,
    this.child,
  });

  final EdgeInsets buttonInsetPadding;
  final VoidCallback? onPressed;
  final String? buttonTitle;
  final TextStyle? titleTextStyle;
  final double width;
  final double? height;
  final Color? buttonColor;
  final Color? splashButtonColor;
  final double borderRadius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: buttonInsetPadding,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(width, height!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          backgroundColor: buttonColor ?? AppStyle.kColorGreen,
          foregroundColor: splashButtonColor ?? AppStyle.kColorGrey,
          padding: EdgeInsets.symmetric(vertical: 16.h),
        ),
        child: (buttonTitle != null)
            ? Text(
                buttonTitle!,
                style: titleTextStyle ??
                    AppStyle.kStyleRegular.copyWith(
                      fontSize: 17.sp,
                      color: AppStyle.kColorWhite,
                    ),
              )
            : child,
      ),
    );
  }
}
