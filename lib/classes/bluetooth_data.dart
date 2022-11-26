import 'dart:math';

import 'package:bluetooth_app_test/constants.dart';
import 'package:bluetooth_app_test/functions/utils.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:bluetooth_app_test/providers/breath.dart';
import 'package:bluetooth_app_test/providers/providers.dart';
import 'package:bluetooth_app_test/providers/pulse.dart';
import 'package:bluetooth_app_test/providers/steps.dart';
import 'package:bluetooth_app_test/services/storage/shared_preferences_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _storageService = SharedPreferencesService();

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
  void handleData(WidgetRef ref) async {
    logger.e("PULSE RECEIVED");

    final pulseAve = await _storageService.getInt(StorageNames.pulseAve);
    final pulseNum = await _storageService.getInt(StorageNames.pulseNum);
    final pulseAveNew = getNewAve(pulseAve, pulseNum, value);
    final pulseNumNew = pulseNum + 1;

    await _storageService.setInt(StorageNames.pulseAve, pulseAveNew);
    await _storageService.setInt(StorageNames.pulseNum, pulseNumNew);

    ref.read(pulseProvider.notifier).add(value);
    ref.read(pulseAveProvider.notifier).state = pulseAveNew;
  }
}

enum _ChangeType {
  rising,
  falling,
  steady,
}

int _localMaxima = 0;
int _lastDistance = 0;
_ChangeType _changeType = _ChangeType.rising;
DateTime? _startingTime;

class BreathBluetoothData implements BluetoothData {
  BreathBluetoothData(this.value);

  @override
  String dataType = DataTypes.breath;

  @override
  int value;

  @override
  void handleData(WidgetRef ref) async {
    logger.e("BREATH RECEIVED");

    _startingTime ??= DateTime.now();

    final distance = max(min(value, 15), 8);

    if (distance > _lastDistance) {
      _changeType = _ChangeType.rising;
    } else if (distance < _lastDistance) {
      if (_changeType != _ChangeType.falling) {
        _localMaxima++;
        if (_startingTime == null) return;
        final minDiffMillis = max(DateTime.now().difference(_startingTime!).inMilliseconds, 1);
        final breathPerMin = ((_localMaxima / minDiffMillis) * (1000 * 60)).round();

        await _storageService.setInt(StorageNames.breathPerMin, breathPerMin);
        ref.read(breathAveProvider.notifier).state = breathPerMin;
      }
      _changeType = _ChangeType.falling;
    } else {
      _changeType = _ChangeType.steady;
    }

    ref.read(breathProvider.notifier).add(distance);

    _lastDistance = distance;
  }
}
