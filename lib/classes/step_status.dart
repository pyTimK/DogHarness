import 'package:bluetooth_app_test/classes/data_status.dart';
import 'package:flutter/material.dart';

@immutable
class StepStatus extends DataStatus {
  StepStatus(int steps)
      : super(
          value: steps,
          label: 'Steps',
          status: getStatus(steps),
          color: getColor(steps),
          icon: 'paw',
        );

  static const _sedentaryMax = 2499;
  static const _activeMax = 5000;

  static String getStatus(int steps) {
    if (steps < _sedentaryMax) {
      return 'Sedentary';
    } else if (steps < _activeMax) {
      return 'Active';
    } else {
      return 'Highly Active';
    }
  }

  static Color getColor(int steps) {
    if (steps < _sedentaryMax) {
      return Colors.red;
    } else if (steps < _activeMax) {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }
}
