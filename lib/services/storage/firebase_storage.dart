import 'package:firebase_storage/firebase_storage.dart';

abstract class FirebaseStorageService {
  static final storage = FirebaseStorage.instance;
  static final storageRef = storage.ref();
}
