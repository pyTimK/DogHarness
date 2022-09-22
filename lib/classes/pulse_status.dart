import 'package:bluetooth_app_test/classes/data_status.dart';
import 'package:bluetooth_app_test/models/dog.dart';
import 'package:flutter/material.dart';

@immutable
class PulseStatus extends DataStatus {
  PulseStatus(int pulse, DogSize size)
      : super(
          value: pulse,
          label: 'Pulse\n/min',
          status: _getStatus(pulse, size),
          color: _getColor(pulse, size),
          icon: 'heartbeat',
        );

  static const _standardLowMax = 59;
  static const _standardNormalMax = 120;
  static const _smallNormalMaxSmall = 120;

  static String _getStatus(int pulse, DogSize size) {
    if (size.isStandard) {
      if (pulse < _standardLowMax) {
        return 'Low';
      } else if (pulse < _standardNormalMax) {
        return 'Normal';
      } else {
        return 'High';
      }
    } else {
      if (pulse < _smallNormalMaxSmall) {
        return 'Normal';
      } else {
        return 'High';
      }
    }
  }

  static Color _getColor(int pulse, DogSize size) {
    if (size.isStandard) {
      if (pulse < _standardLowMax) {
        return Colors.red;
      } else if (pulse < _standardNormalMax) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    } else {
      if (pulse < _smallNormalMaxSmall) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    }
  }
}
