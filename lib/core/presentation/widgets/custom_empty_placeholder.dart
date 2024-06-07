import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/core/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class CustomEmptyPlaceholder extends StatelessWidget {
  const CustomEmptyPlaceholder({
    Key? key,
    this.iconData,
    required this.title,
    this.buttonTitle,
    this.buttonOnPressed,
    this.buttonWidth,
  }) : super(key: key);

  final IconData? iconData;
  final String title;
  final String? buttonTitle;
  final VoidCallback? buttonOnPressed;
  final double? buttonWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        (iconData != null)
            ? Icon(
                iconData,
                size: 80.0,
                color: AppStyle.kColorGrey5,
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 10.0),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppStyle.kStyleRegular.copyWith(
            color: AppStyle.kColorGrey5,
          ),
        ),
        const SizedBox(height: 15.0),
        (buttonTitle != null)
            ? CustomButton(
                width: buttonWidth!,
                buttonTitle: buttonTitle!,
                titleTextStyle: AppStyle.kStyleRegular.copyWith(
                  fontSize: 17.0,
                  color: AppStyle.kColorWhite,
                ),
                onPressed: buttonOnPressed!,
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
