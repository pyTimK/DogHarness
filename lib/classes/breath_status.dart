import 'package:bluetooth_app_test/classes/data_status.dart';
import 'package:flutter/material.dart';

@immutable
class BreathStatus extends DataStatus {
  BreathStatus(int breath)
      : super(
          value: breath,
          label: 'Breath\n/min',
          status: _getStatus(breath),
          color: _getColor(breath),
          icon: 'air',
        );

  static const _lowMax = 17;
  static const _normalMax = 34;

  static String _getStatus(int breath) {
    if (breath < _lowMax) {
      return 'Low';
    } else if (breath < _normalMax) {
      return 'Normal';
    } else {
      return 'High';
    }
  }

  static Color _getColor(int breath) {
    if (breath < _lowMax) {
      return Colors.red;
    } else if (breath < _normalMax) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }
}
