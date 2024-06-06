import 'package:cached_network_image/cached_network_image.dart';
import 'package:donation_management/core/presentation/widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.boxFit = BoxFit.cover,
    this.onPressed,
    this.imageBorderRadius = BorderRadius.zero,
  });

  final String imageUrl;
  final BoxFit boxFit;
  final VoidCallback? onPressed;
  final BorderRadius imageBorderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: imageBorderRadius,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: boxFit,
          placeholder: (context, url) => const Padding(
            padding: EdgeInsets.all(45.0),
            child: Center(child: CustomProgressIndicator()),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
