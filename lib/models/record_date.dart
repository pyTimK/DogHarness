class RecordDate {
  RecordDate({
    required this.id,
    required this.numSteps,
    required this.numDistance,
    required this.avePulse,
    required this.aveBreath,
  });

  String id;
  int numSteps;
  int numDistance;
  int avePulse;
  int aveBreath;

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
