import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:donation_management/core/presentation/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomAvatar extends StatelessWidget {
  const CustomAvatar({
    super.key,
    this.name,
    this.heroTag,
    this.mediaAsset,
    this.networkAsset,
    this.size = 100.0,
    this.fontSize = 50.0,
    this.borderWidth = 5.0,
    this.isEditable = false,
    this.showEditIcon = true,
    this.isFromMedia = false,
    this.avatarOnPressed,
    this.placeholderIcon,
  });

  final String? name;
  final XFile? mediaAsset;
  final String? networkAsset;

  final String? heroTag;

  final double size;
  final double fontSize;
  final double borderWidth;

  final bool isEditable;
  final bool showEditIcon;
  final bool isFromMedia;
  final VoidCallback? avatarOnPressed;

  final IconData? placeholderIcon;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag!,
      child: GestureDetector(
        onTap: (isEditable) ? avatarOnPressed : null,
        child: Stack(
          children: [
            Material(
              elevation: 8.0,
              borderRadius: BorderRadius.circular(100.0),
              child: (isFromMedia)
                  ? _buildMediaContainer()
                  : _buildAvatarContainer(),
            ),
            (isEditable && showEditIcon)
                ? Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppStyle.kColorWhite,
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.circular(100.0),
                        color: AppStyle.kColorGreen,
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: AppStyle.kColorWhite,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaContainer() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppStyle.kColorGreen,
        border: Border.all(color: AppStyle.kColorWhite, width: borderWidth),
        borderRadius: BorderRadius.circular(100.0),
        image: (isFromMedia)
            ? DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(File(mediaAsset!.path)),
              )
            : null,
      ),
    );
  }

  Widget _buildAvatarContainer() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppStyle.kColorGreen,
        border: Border.all(color: AppStyle.kColorWhite, width: borderWidth),
        borderRadius: BorderRadius.circular(100.0),
        image: (networkAsset != null)
            ? DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(networkAsset!),
              )
            : null,
      ),
      child: (networkAsset == null)
          ? Center(
              child: (name != null)
                  ? Text(
                      (name![0]).toUpperCase(),
                      style: AppStyle.kStyleExtraBold.copyWith(
                        color: AppStyle.kColorWhite,
                        fontSize: fontSize,
                      ),
                    )
                  : Icon(
                      placeholderIcon,
                      color: AppStyle.kColorWhite,
                      size: 50.0,
                    ),
            )
          : const SizedBox.shrink(),
    );
  }
}
