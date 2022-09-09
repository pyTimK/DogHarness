/// This file contains the SharedPreferencesService class
/// that implements the StorageService abstract class.
/// This class is used to store and retrieve data using
/// the shared_preferences package.

import 'package:bluetooth_app_test/services/storage/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService implements StorageService {
  static final SharedPreferencesService _instance = SharedPreferencesService._internal();

  factory SharedPreferencesService() => _instance;

  SharedPreferencesService._internal();

  @override
  Future<void> setString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  @override
  Future<String> getString(String key, {String defaultValue = ""}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? defaultValue;
  }

  @override
  Future<void> remove(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  @override
  Future<int> getInt(String key, {int defaultValue = 0}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? defaultValue;
  }
}
