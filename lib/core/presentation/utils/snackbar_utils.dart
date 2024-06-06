import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:flutter/material.dart';

class SnackbarUtils {
  SnackbarUtils._();

  /// Singleton to ensure only one class instance is created
  static final SnackbarUtils _instance = SnackbarUtils._();
  factory SnackbarUtils() => _instance;

  static removeCurrentSnackbar({
    GlobalKey<ScaffoldState>? scaffoldKey,
    required BuildContext context,
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  static showSnackbar({
    GlobalKey<ScaffoldState>? scaffoldKey,
    required BuildContext context,
    required String title,
  }) {
    SnackBar content = SnackBar(
      content: Text(
        title,
        style: AppStyle.kStyleRegular.copyWith(
          color: AppStyle.kColorWhite,
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(content);
  }
}
