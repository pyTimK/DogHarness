import 'package:flutter/material.dart';

@immutable
class RecordDate {
  const RecordDate({
    required this.id,
    required this.numSteps,
    required this.numDistance,
    required this.avePulse,
    required this.aveBreath,
  });

  final String id;
  final int numSteps;
  final int numDistance;
  final int avePulse;
  final int aveBreath;

  RecordDate copyWith({
    String? id,
    int? numSteps,
    int? numDistance,
    int? avePulse,
    int? aveBreath,
  }) {
    return RecordDate(
      id: id ?? this.id,
      numSteps: numSteps ?? this.numSteps,
      numDistance: numDistance ?? this.numDistance,
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
      numDistance: data['numDistance'] ?? 0,
      avePulse: data['avePulse'] ?? 0,
      aveBreath: data['aveBreath'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'numSteps': numSteps,
      'numDistance': numDistance,
      'avePulse': avePulse,
      'aveBreath': aveBreath,
    };
  }
}
