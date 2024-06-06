import 'package:image_picker/image_picker.dart';

enum Media { camera, gallery }

class ImagePickerService {
  ImagePickerService._();

  /// Singleton to ensure only one class instance is created
  static final ImagePickerService _instance = ImagePickerService._();
  factory ImagePickerService() => _instance;

  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImage(Media media) async {
    XFile? image;

    if (media == Media.camera) {
      image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        return image;
      } else {
        return null;
      }
    } else if (media == Media.gallery) {
      image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        return image;
      } else {
        return null;
      }
    }
    return null;
  }
}
