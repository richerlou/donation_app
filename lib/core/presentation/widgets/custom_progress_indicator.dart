import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({
    super.key,
    this.heightMultiplier = 1,
    this.size = 30.0,
  });

  final double heightMultiplier;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      color: AppStyle.kColorGreen,
      size: size,
    );
  }
}
