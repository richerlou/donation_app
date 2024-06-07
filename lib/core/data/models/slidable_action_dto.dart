import 'package:flutter/material.dart';

class SlidableActionDto {
  final String? label;
  final IconData? icon;

  final Color? backgroundColor;
  final Color? foregroundColor;

  final Function(BuildContext)? onPressed;

  SlidableActionDto({
    this.label,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.onPressed,
  });
}
