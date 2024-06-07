import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomProfileText extends StatelessWidget {
  const CustomProfileText({
    Key? key,
    required this.label,
    this.data,
    this.dataTextColor,
    this.onTap,
  }) : super(key: key);

  final String label;
  final String? data;
  final Color? dataTextColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppStyle.kStyleMedium,
          ),
          const SizedBox(height: 8.0),
          (onTap != null)
              ? RichText(
                  text: TextSpan(
                    text: data ?? 'None',
                    recognizer: TapGestureRecognizer()..onTap = onTap,
                    style: AppStyle.kStyleRegular.copyWith(
                      fontSize: 14.0,
                      color: dataTextColor ?? AppStyle.kColorBlue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              : Text(
                  data ?? 'None',
                  style: AppStyle.kStyleRegular.copyWith(
                    fontSize: 14.0,
                    color: dataTextColor ?? AppStyle.kColorGrey3,
                  ),
                )
        ],
      ),
    );
  }
}
