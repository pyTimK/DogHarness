import 'package:flutter/material.dart';

@immutable
class Record {
  const Record({
    required this.id,
    required this.numSteps,
    required this.numDistance,
    required this.avePulse,
    required this.aveBreath,
  });

  const Record.fromNull(this.id)
      : numSteps = 0,
        numDistance = 0,
        avePulse = 0,
        aveBreath = 0;

  final String id;
  final int numSteps;
  final int numDistance;
  final int avePulse;
  final int aveBreath;

  Record copyWith({
    String? id,
    int? numSteps,
    int? numDistance,
    int? avePulse,
    int? aveBreath,
  }) {
    return Record(
      id: id ?? this.id,
      numSteps: numSteps ?? this.numSteps,
      numDistance: numDistance ?? this.numDistance,
      avePulse: avePulse ?? this.avePulse,
      aveBreath: aveBreath ?? this.aveBreath,
    );
  }

  factory Record.fromMap(Map<String, dynamic> data, String documentId) {
    if (data.isEmpty) {
      throw Exception("No data");
    }
    return Record(
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
