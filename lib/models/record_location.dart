class RecordLocation {
  RecordLocation({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.altitude,
  });

  String id;
  double latitude;
  double longitude;
  double altitude;

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
