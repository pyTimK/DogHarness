import 'dart:io';

import 'package:bluetooth_app_test/logger.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class FirebaseStorageService {
  static final _storage = FirebaseStorage.instance;
  static final _storageRef = _storage.ref();

  static Reference _ownerImageRef(String ownerId) => _storageRef.child("owner/$ownerId/profile.jpg");
  static Reference _dogImageRef(String dogId) => _storageRef.child("dog/$dogId/profile.jpg");

  static Future<String?> uploadImage({required String id, required File? image, isOwner = true}) async {
    if (image == null) {
      return null;
    }

    final ref = isOwner ? _ownerImageRef(id) : _dogImageRef(id);
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }
}
