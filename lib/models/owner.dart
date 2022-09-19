class Owner {
  Owner({
    required this.id,
    required this.nickname,
    required this.email,
    this.photoUrl,
    required this.dogIds,
    required this.defaultDogId,
  });

  String id;
  String nickname;
  String email;
  String? photoUrl;
  List<String> dogIds;
  String defaultDogId;

  factory Owner.fromMap(Map<String, dynamic> data, String documentId) {
    if (data.isEmpty) {
      throw Exception("No data");
    }
    return Owner(
      id: documentId,
      nickname: data['nickname'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
      dogIds: List<String>.from(data['dogIds'] ?? []),
      defaultDogId: data['defaultDogId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'email': email,
      'photoUrl': photoUrl,
      'dogIds': dogIds,
      'defaultDogId': defaultDogId,
    };
  }
}
