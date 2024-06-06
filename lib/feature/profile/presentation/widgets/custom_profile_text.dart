import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:flutter/material.dart';

class CustomProfileText extends StatelessWidget {
  const CustomProfileText({
    super.key,
    required this.label,
    this.data,
    this.dataTextColor,
  });

  final String label;
  final String? data;
  final Color? dataTextColor;

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
          Text(
            data ?? 'None',
            style: AppStyle.kStyleRegular.copyWith(
              fontSize: 14.0,
              color: dataTextColor ?? AppStyle.kColorGrey3,
            ),
          ),
        ],
      ),
    );
  }
}
