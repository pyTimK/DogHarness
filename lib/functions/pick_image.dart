import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? xFile =
      await picker.pickImage(source: ImageSource.gallery, maxWidth: 512, maxHeight: 512, imageQuality: 75);
  if (xFile == null) {
    return null;
  }

  final path = xFile.path;
  final file = File(path);
  return file;
}
