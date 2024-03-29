import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class DogBreed {
  const DogBreed.aspin() : _name = "Aspin";
  const DogBreed.siberianHusky() : _name = "SIberian Husky";
  const DogBreed.borderCollie() : _name = "Border Collie";
  const DogBreed.beagle() : _name = "Beagle";
  const DogBreed.labrador() : _name = "Labrador";
  final String _name;

  static List<DogBreed> all = const [
    DogBreed.aspin(),
    DogBreed.siberianHusky(),
    DogBreed.borderCollie(),
    DogBreed.beagle(),
    DogBreed.labrador(),
  ];

  factory DogBreed.fromString(String name) {
    switch (name) {
      case "Aspin":
        return const DogBreed.aspin();
      case "SIberian Husky":
        return const DogBreed.siberianHusky();
      case "Border Collie":
        return const DogBreed.borderCollie();
      case "Beagle":
        return const DogBreed.beagle();
      case "Labrador":
        return const DogBreed.labrador();
      default:
        return const DogBreed.aspin();
    }
  }

  @override
  String toString() => _name;
}

@immutable
class DogSize {
  static const standardStr = "Standard";
  static const smallStr = "Small";

  const DogSize.standard() : _name = standardStr;
  const DogSize.small() : _name = smallStr;
  final String _name;

  static List<DogSize> all = const [
    DogSize.standard(),
    DogSize.small(),
  ];

  factory DogSize.fromString(String name) {
    switch (name) {
      case standardStr:
        return const DogSize.standard();
      case smallStr:
        return const DogSize.small();
      default:
        return const DogSize.standard();
    }
  }

  @override
  String toString() => _name;

  bool get isStandard => _name == standardStr;
}

@immutable
class Dog {
  static const stepLengthMeters = 0.67056;
  const Dog({
    required this.id,
    required this.name,
    this.photoUrl,
    required this.breed,
    required this.size,
    required this.birthday,
    required this.ownerId,
    this.humanIds = const [],
  });

  final String id;
  final String name;
  final String? photoUrl;
  final DogBreed breed;
  final DogSize size;
  final DateTime birthday;
  final String ownerId;
  final List<String> humanIds;

  static const _invalidPhotoUrl_ = '_invalidPhotoUrl_';
  Dog copyWith({
    String? id,
    String? name,
    String? photoUrl = _invalidPhotoUrl_,
    DogBreed? breed,
    DogSize? size,
    DateTime? birthday,
    String? ownerId,
    List<String>? humanIds,
  }) {
    return Dog(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl == _invalidPhotoUrl_ ? this.photoUrl : photoUrl,
      breed: breed ?? this.breed,
      size: size ?? this.size,
      birthday: birthday ?? this.birthday,
      ownerId: ownerId ?? this.ownerId,
      humanIds: humanIds ?? this.humanIds,
    );
  }

  factory Dog.fromMap(Map<String, dynamic> data, String documentId) {
    if (data.isEmpty) {
      throw Exception("No data");
    }
    return Dog(
      id: documentId,
      name: data['name'] ?? '',
      photoUrl: data['photoUrl'],
      breed: DogBreed.fromString(data['breed'] ?? ''),
      size: DogSize.fromString(data['size'] ?? ''),
      birthday: (data['birthday'] as Timestamp).toDate(),
      ownerId: data['ownerId'] ?? '',
      humanIds: List<String>.from(data['humanIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photoUrl': photoUrl,
      'breed': breed.toString(),
      'size': size.toString(),
      'birthday': birthday,
      'ownerId': ownerId,
      'humanIds': humanIds,
    };
  }
}
