import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/generated/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSettingsTile extends StatelessWidget {
  const CustomSettingsTile({
    super.key,
    this.title,
    this.titleColor = AppStyle.kColorBlack,
    this.suffixIconData,
    this.suffixIconColor = AppStyle.kColorGrey,
    this.showDivider = true,
    this.settingsOnTapped,
  });

  final String? title;
  final Color titleColor;
  final IconData? suffixIconData;
  final Color suffixIconColor;
  final bool showDivider;
  final VoidCallback? settingsOnTapped;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: settingsOnTapped,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title!,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: FontFamily.dMSans,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    color: titleColor,
                  ),
                ),
                Icon(suffixIconData, color: suffixIconColor),
              ],
            ),
          ),
        ),
        showDivider
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                child: const Divider(
                  indent: 12.0,
                  endIndent: 12.0,
                  color: Color(0xFFE5E5E5),
                  thickness: 1.0,
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
