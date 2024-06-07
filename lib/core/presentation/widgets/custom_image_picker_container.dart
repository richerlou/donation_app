import 'dart:io';

import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:donation_management/core/presentation/widgets/custom_network_image.dart';
import 'package:donation_management/generated/assets.gen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePickerContainer extends StatelessWidget {
  const CustomImagePickerContainer({
    Key? key,
    this.fromMedia = false,
    this.hasMediaError = false,
    this.mediaAsset,
    this.networkAsset,
    this.subtext,
    this.onPressed,
    this.errorText,
  }) : super(key: key);

  final bool fromMedia;
  final bool hasMediaError;

  final XFile? mediaAsset;
  final String? networkAsset;

  final String? subtext;
  final String? errorText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: double.infinity,
            child: DottedBorder(
              color: AppStyle.kPrimaryColor,
              radius: const Radius.circular(5.0),
              borderType: BorderType.RRect,
              strokeWidth: 2.0,
              dashPattern: const [5, 3],
              child: Center(
                  child: (fromMedia)
                      ? Image.file(File(mediaAsset!.path))
                      : _buildNetworkImage()),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        (hasMediaError)
            ? Text(
                errorText ?? '',
                style: AppStyle.kStyleRegular.copyWith(
                  fontSize: 13.sp,
                  color: AppStyle.kColorRed,
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildNetworkImage() {
    if (networkAsset != null) {
      return CustomNetworkImage(imageUrl: networkAsset!);
    } else {
      return Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.images.imgUpload.image(height: 150.h),
            SizedBox(height: 21.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  subtext ?? 'Upload here',
                  style: AppStyle.kStyleMedium.copyWith(
                    fontSize: 16.sp,
                    color: AppStyle.kPrimaryColor,
                  ),
                ),
                SizedBox(width: 8.w),
                const Icon(Icons.image, color: AppStyle.kPrimaryColor),
              ],
            )
          ],
        ),
      );
    }
  }
}
