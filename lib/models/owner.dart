import 'package:flutter/material.dart';

@immutable
class Owner {
  const Owner({
    required this.id,
    required this.nickname,
    required this.email,
    this.photoUrl,
    required this.dogIds,
    required this.defaultDogId,
  });

  final String id;
  final String nickname;
  final String email;
  final String? photoUrl;
  final List<String> dogIds;
  final String defaultDogId;

  static const _invalidPhotoUrl_ = '_invalidPhotoUrl_';
  Owner copyWith({
    String? id,
    String? nickname,
    String? email,
    String? photoUrl = _invalidPhotoUrl_,
    List<String>? dogIds,
    String? defaultDogId,
  }) {
    return Owner(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      photoUrl: photoUrl == _invalidPhotoUrl_ ? this.photoUrl : photoUrl,
      dogIds: dogIds ?? this.dogIds,
      defaultDogId: defaultDogId ?? this.defaultDogId,
    );
  }

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
