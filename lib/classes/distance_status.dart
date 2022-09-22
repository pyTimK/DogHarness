import 'package:bluetooth_app_test/classes/data_status.dart';
import 'package:bluetooth_app_test/classes/step_status.dart';
import 'package:bluetooth_app_test/functions/steps_to_distance.dart';
import 'package:flutter/material.dart';

@immutable
class DistanceStatus extends DataStatus {
  DistanceStatus(int steps)
      : super(
          value: stepsToDistance(steps),
          label: 'Meters\ncovered',
          status: StepStatus.getStatus(steps),
          color: StepStatus.getColor(steps),
          icon: 'location-pin',
        );
}
