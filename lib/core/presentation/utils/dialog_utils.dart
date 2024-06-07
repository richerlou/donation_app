import 'package:donation_management/generated/fonts.gen.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  DialogUtils._();

  /// Singleton to ensure only one class instance is created
  static final DialogUtils _instance = DialogUtils._();
  factory DialogUtils() => _instance;

  static showConfirmationDialog(
    BuildContext context, {
    String? title,
    String? content,
    String? primaryButtonTitle,
    VoidCallback? onPrimaryButtonPressed,
    String? secondaryButtonTitle,
    VoidCallback? onSecondaryButtonPressed,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text(title ?? ''),
          titleTextStyle: const TextStyle(
            fontSize: 22.0,
            fontFamily: FontFamily.dMSans,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3E3E3E),
          ),
          content: Text(content ?? ''),
          contentTextStyle: const TextStyle(
            fontSize: 16.0,
            fontFamily: FontFamily.dMSans,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal,
            color: Color(0xFF3E3E3E),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                secondaryButtonTitle ?? 'No',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontFamily: FontFamily.dMSans,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF3E3E3E),
                ),
              ),
            ),
            TextButton(
              onPressed: onPrimaryButtonPressed,
              child: Text(
                primaryButtonTitle ?? 'Yes',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontFamily: FontFamily.dMSans,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static showBottomMediaSheet(
    BuildContext context, {
    String? header,
    String? cameraText,
    String? galleryText,
    VoidCallback? onCameraPressed,
    VoidCallback? onGalleryPressed,
  }) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 250.0,
          padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                header ?? '',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontFamily: FontFamily.dMSans,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF191919),
                ),
              ),
              const SizedBox(height: 26.0),
              ListTile(
                onTap: onCameraPressed,
                leading: const Icon(Icons.camera_alt_rounded),
                title: Text(
                  cameraText ?? 'Camera',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontFamily: FontFamily.dMSans,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF191919),
                  ),
                ),
              ),
              const Divider(
                indent: 12.0,
                endIndent: 12.0,
                color: Color(0xFFE5E5E5),
                thickness: 1.0,
              ),
              ListTile(
                onTap: onGalleryPressed,
                leading: const Icon(Icons.photo),
                title: Text(
                  galleryText ?? 'Gallery',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontFamily: FontFamily.dMSans,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF191919),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static showGenericBottomSheet(
    BuildContext context, {
    String? header,
    required List<Widget> options,
    String? cameraText,
    String? galleryText,
    VoidCallback? onCameraPressed,
    VoidCallback? onGalleryPressed,
    double bottomSheetHeight = 380.0,
  }) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            height: bottomSheetHeight,
            padding: const EdgeInsets.symmetric(
              vertical: 25.0,
              horizontal: 25.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  header ?? '',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontFamily: FontFamily.dMSans,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF191919),
                  ),
                ),
                const SizedBox(height: 26),
                ListView.separated(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return options[index];
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      indent: 12.0,
                      endIndent: 12.0,
                      color: Color(0xFFE5E5E5),
                      thickness: 1.0,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static showDefaultDialog(
    BuildContext context, {
    String? title,
    required Widget content,
    required String primaryButtonTitle,
    VoidCallback? onPrimaryButtonPressed,
    String? secondaryButtonTitle,
    VoidCallback? onSecondaryButtonPressed,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text(title ?? 'Credits'),
          titleTextStyle: const TextStyle(
            fontSize: 22.0,
            fontFamily: FontFamily.dMSans,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3E3E3E),
          ),
          content: content,
          contentTextStyle: const TextStyle(
            fontSize: 16.0,
            fontFamily: FontFamily.dMSans,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal,
            color: Color(0xFF3E3E3E),
          ),
          actions: [
            (onSecondaryButtonPressed != null)
                ? TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      secondaryButtonTitle ?? 'No',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: FontFamily.dMSans,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF3E3E3E),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            TextButton(
              onPressed: onPrimaryButtonPressed ?? () => Navigator.pop(context),
              child: Text(
                primaryButtonTitle,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontFamily: FontFamily.dMSans,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
