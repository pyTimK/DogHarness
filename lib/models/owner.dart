class Owner {
  Owner({
    this.id,
    required this.nickname,
    required this.email,
    this.photoUrl,
    required this.dogIds,
  });

  String? id;
  String nickname;
  String email;
  String? photoUrl;
  List<String> dogIds;

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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'email': email,
      'photoUrl': photoUrl,
      'dogIds': dogIds,
    };
  }
}
