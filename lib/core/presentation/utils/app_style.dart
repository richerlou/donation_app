import 'package:donation_management/generated/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyle {
  static const Color kPrimaryColor = kColorGreen;
  static const Color kPrimaryAccentColor = Color(0xFFF7901C);
  static const Color kColorBlack = Color(0xFF191919);
  static const Color kColorBlack2 = Color(0xFF00002F);

  static const Color kColorGrey2 = Color(0xFF666666);
  static const Color kColorGrey3 = Color(0xFF3E3E3E);
  static const Color kColorGrey4 = Color(0xFFEBEBEE);
  static const Color kColorGrey5 = Color(0xFF979797);

  static const Color kColorWhite = Colors.white;
  static const Color kColorGrey = Colors.grey;
  static const Color kColorRed = Colors.red;
  static const Color kColorAmber = Colors.amber;
  static const Color kColorGreen = Colors.green;
  static const Color kColorLightGreen = Colors.lightGreen;
  static const Color kColorBlue = Colors.blue;
  static const Color kColorTransparent = Colors.transparent;

  static TextStyle kStyleHeader = TextStyle(
    fontSize: 20.sp,
    fontFamily: FontFamily.dMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    color: kPrimaryColor,
  );

  static TextStyle kStyleRegular = TextStyle(
    fontSize: 15.sp,
    fontFamily: FontFamily.dMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    color: kColorBlack,
  );

  static TextStyle kStyleMedium = TextStyle(
    fontSize: 15.sp,
    fontFamily: FontFamily.dMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    color: kColorBlack,
  );

  static TextStyle kStyleBold = TextStyle(
    fontSize: 15.sp,
    fontFamily: FontFamily.dMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w700,
    color: kColorBlack,
  );

  static TextStyle kStyleExtraBold = TextStyle(
    fontSize: 15.sp,
    fontFamily: FontFamily.dMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w800,
    color: kColorBlack,
  );

  static TextStyle kStyleError = TextStyle(
    fontSize: 13.sp,
    fontFamily: FontFamily.dMSans,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    color: kColorRed,
  );

  static IconThemeData kIconThemeData = IconThemeData(
    size: 28.sp,
    color: kColorBlack,
  );
}
