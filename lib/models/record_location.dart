import 'package:flutter/material.dart';

@immutable
class RecordLocation {
  const RecordLocation({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.altitude,
  });

  final String id;
  final double latitude;
  final double longitude;
  final double altitude;

  RecordLocation copyWith({
    String? id,
    double? latitude,
    double? longitude,
    double? altitude,
  }) {
    return RecordLocation(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
    );
  }

  factory RecordLocation.fromMap(Map<String, dynamic> data, String documentId) {
    if (data.isEmpty) {
      throw Exception("No data");
    }
    return RecordLocation(
      id: documentId,
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
      altitude: data['altitude'] ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
    };
  }
}
