import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.bottom,
    this.centerTitle = false,
  });

  final String title;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      iconTheme: AppStyle.kIconThemeData.copyWith(
        color: AppStyle.kColorWhite,
      ),
      title: Text(
        title,
        style: AppStyle.kStyleBold.copyWith(
          fontSize: 22.0,
          color: Colors.white,
        ),
      ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
