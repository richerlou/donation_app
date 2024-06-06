import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:flutter/material.dart';

class CustomFloatingButton extends StatelessWidget {
  const CustomFloatingButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconSize = 28.0,
    this.buttonColor,
  });

  final IconData icon;
  final double iconSize;
  final Color? buttonColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor ?? AppStyle.kColorBlack.withOpacity(0.65),
          borderRadius: BorderRadius.circular(100.0),
        ),
        padding: const EdgeInsets.all(15.0),
        child: Icon(
          icon,
          color: Colors.white,
          size: iconSize,
        ),
      ),
    );
  }
}
