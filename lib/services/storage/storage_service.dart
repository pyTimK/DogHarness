/// This file contains the StorageService abstract class
/// that will be extended by the actual storage service implementations.
/// An implementation of this class will be used to store and retrieve
/// data.

abstract class StorageService {
  Future<void> setString(String key, String value);
  Future<String> getString(String key, {String defaultValue = ""});
  Future<void> setInt(String key, int value);
  Future<int> getInt(String key, {int defaultValue = 0});
  Future<void> remove(String key);
}

abstract class StorageNames {
  static const steps = "steps";
  static const defaultDate = "defaultDate";
}
