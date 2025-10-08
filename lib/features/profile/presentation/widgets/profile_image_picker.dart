import 'package:image_picker/image_picker.dart';

class ProfileImagePicker {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    return image?.path;
  }
}
