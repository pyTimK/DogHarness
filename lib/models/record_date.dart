import 'package:bluetooth_app_test/classes/breath_status.dart';
import 'package:bluetooth_app_test/classes/distance_status.dart';
import 'package:bluetooth_app_test/classes/pulse_status.dart';
import 'package:bluetooth_app_test/classes/step_status.dart';
import 'package:bluetooth_app_test/functions/steps_to_distance.dart';
import 'package:bluetooth_app_test/models/dog.dart';
import 'package:flutter/material.dart';

@immutable
class RecordDate {
  const RecordDate({
    required this.id,
    required this.numSteps,
    required this.avePulse,
    required this.aveBreath,
  });

  final String id;
  final int numSteps;
  final int avePulse;
  final int aveBreath;

  RecordDate copyWith({
    String? id,
    int? numSteps,
    int? avePulse,
    int? aveBreath,
  }) {
    return RecordDate(
      id: id ?? this.id,
      numSteps: numSteps ?? this.numSteps,
      avePulse: avePulse ?? this.avePulse,
      aveBreath: aveBreath ?? this.aveBreath,
    );
  }

  factory RecordDate.fromMap(Map<String, dynamic> data, String documentId) {
    if (data.isEmpty) {
      throw Exception("No data");
    }
    return RecordDate(
      id: documentId,
      numSteps: data['numSteps'] ?? 0,
      avePulse: data['avePulse'] ?? 0,
      aveBreath: data['aveBreath'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'numSteps': numSteps,
      'avePulse': avePulse,
      'aveBreath': aveBreath,
    };
  }

  bool get hasData => numSteps != 0 || avePulse != 0 || aveBreath != 0;
  int get distance => stepsToDistance(numSteps);

  StepStatus get stepStatus => StepStatus(numSteps);
  PulseStatus pulseStatus(Dog dog) => PulseStatus(avePulse, dog.size);
  BreathStatus get breathStatus => BreathStatus(aveBreath);
  DistanceStatus get distanceStatus => DistanceStatus(numSteps);
}
