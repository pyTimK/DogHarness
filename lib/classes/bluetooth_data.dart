import 'package:bluetooth_app_test/constants.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:bluetooth_app_test/providers/pulse.dart';
import 'package:bluetooth_app_test/providers/steps.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BluetoothData {
  abstract String dataType;
  abstract int value;
  void handleData(WidgetRef ref);

  factory BluetoothData.fromBytes(List<int> bytes) {
    final asciiList = String.fromCharCodes(bytes).trim().split(' ');
    final dataType = asciiList[0];

    switch (dataType) {
      case DataTypes.step:
        return StepBluetoothData();

      case DataTypes.pulse:
        final value = int.parse(asciiList[1]);
        return PulseBluetoothData(value);

      case DataTypes.breath:
        final value = int.parse(asciiList[1]);
        return BreathBluetoothData(value);

      default:
        logger.e('Unknown data type: $dataType');
        return PulseBluetoothData(1);
    }
  }
}

class StepBluetoothData implements BluetoothData {
  StepBluetoothData();

  @override
  String dataType = DataTypes.step;

  @override
  int value = 0;

  @override
  void handleData(WidgetRef ref) {
    logger.e("STEP RECEIVED");
    ref.read(stepProvider.notifier).add();
  }
}

class PulseBluetoothData implements BluetoothData {
  PulseBluetoothData(this.value);

  @override
  String dataType = DataTypes.pulse;

  @override
  int value;

  @override
  void handleData(WidgetRef ref) {
    logger.e("PULSE RECEIVED");
    ref.read(pulseProvider.notifier).add(value);
  }
}

class BreathBluetoothData implements BluetoothData {
  BreathBluetoothData(this.value);

  @override
  String dataType = DataTypes.breath;

  @override
  int value;

  @override
  void handleData(WidgetRef ref) {
    logger.e("BREATH RECEIVED");
  }
}
