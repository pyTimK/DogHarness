/// This file contains the FlutterSecureStorageService class
/// that implements the StorageService abstract class.
/// This class is used to store and retrieve data using
/// the flutter_secure_storage package.

// import 'package:azeus_admin_app/services/storage/storage_service.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class FlutterSecureStorageService implements StorageService {
//   static final FlutterSecureStorageService _instance =
//       FlutterSecureStorageService._internal();

//   factory FlutterSecureStorageService() => _instance;

//   FlutterSecureStorageService._internal();

//   @override
//   Future<void> setString(String key, String value) async {
//     const storage = FlutterSecureStorage();
//     await storage.write(key: key, value: value);
//   }

//   @override
//   Future<String> getString(String key, {String defaultValue = ""}) async {
//     const storage = FlutterSecureStorage();
//     return await storage.read(key: key) ?? defaultValue;
//   }

//   @override
//   Future<void> remove(String key) async {
//     const storage = FlutterSecureStorage();
//     await storage.delete(key: key);
//   }
// }
