import 'package:cloud_firestore/cloud_firestore.dart';

class DogBreed {
  const DogBreed.aspin() : _name = "Aspin";
  const DogBreed.dobermanPinscher() : _name = "Doberman Pinscher";
  const DogBreed.americanBulldog() : _name = "American Bulldog";
  const DogBreed.beagle() : _name = "Beagle";
  const DogBreed.labrador() : _name = "Labrador";
  final String _name;

  static List<DogBreed> all = const [
    DogBreed.aspin(),
    DogBreed.dobermanPinscher(),
    DogBreed.americanBulldog(),
    DogBreed.beagle(),
    DogBreed.labrador(),
  ];

  factory DogBreed.fromString(String name) {
    switch (name) {
      case "Aspin":
        return const DogBreed.aspin();
      case "Doberman Pinscher":
        return const DogBreed.dobermanPinscher();
      case "American Bulldog":
        return const DogBreed.americanBulldog();
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

class DogSize {
  const DogSize.standard() : _name = "Standard";
  const DogSize.small() : _name = "Small";
  final String _name;

  static List<DogSize> all = const [
    DogSize.standard(),
    DogSize.small(),
  ];

  factory DogSize.fromString(String name) {
    switch (name) {
      case "Standard":
        return const DogSize.standard();
      case "Small":
        return const DogSize.small();
      default:
        return const DogSize.standard();
    }
  }

  @override
  String toString() => _name;
}

class Dog {
  Dog({
    this.id,
    required this.name,
    required this.photoUrl,
    required this.breed,
    required this.size,
    required this.birthday,
    required this.ownerId,
    this.humanIds = const [],
  });

  String? id;
  String name;
  String photoUrl;
  DogBreed breed;
  DogSize size;
  DateTime birthday;
  String ownerId;
  List<String> humanIds;

  factory Dog.fromMap(Map<String, dynamic> data, String documentId) {
    if (data.isEmpty) {
      throw Exception("No data");
    }
    return Dog(
      id: documentId,
      name: data['name'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
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
