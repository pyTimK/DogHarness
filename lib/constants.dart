import 'package:bluetooth_app_test/models/dog.dart';

abstract class Constants {
  static const String appName = 'DogtAPP';
  static const String deviceName = 'DogTAPP';
}

abstract class RouteNames {
  static const String addDog = '/addDog';
  static const String dogProfile = '/dogProfile';
  static const String ownerProfile = '/ownerProfile';
  static const String about = '/about';
}

abstract class StorageNames {
  static const defaultDate = "defaultDate";
  static const steps = "steps";
  static const pulseAve = "pulseAve";
  static const pulseNum = "pulseNum";
}

abstract class DataTypes {
  static const String step = "STEP";
  static const String pulse = "BPM";
  static const String breath = "BREATH";
}
