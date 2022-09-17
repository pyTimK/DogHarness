class Owner {
  Owner({
    required this.id,
    required this.nickname,
    required this.email,
    this.photoUrl,
    required this.dogIds,
  });

  String id;
  String nickname;
  String email;
  String? photoUrl;
  List<String> dogIds;
}

class DogBreed {
  const DogBreed.aspin() : _name = "Aspin";
  const DogBreed.dobermanPinscher() : _name = "Doberman Pinscher";
  const DogBreed.americanBulldog() : _name = "American Bulldog";
  const DogBreed.beagle() : _name = "Beagle";
  const DogBreed.labrador() : _name = "Labrador";
  final String _name;

  @override
  String toString() => _name;
}

class DogSize {
  const DogSize.standard() : _name = "Standard";
  const DogSize.small() : _name = "Small";
  final String _name;

  @override
  String toString() => _name;
}

class Dog {
  Dog({
    required this.id,
    required this.name,
    required this.breed,
    required this.size,
    required this.recordId,
    required this.ownerId,
    this.humanIds = const [],
  });

  String id;
  String name;
  DogBreed breed;
  DogSize size;
  String recordId;
  String ownerId;
  List<String> humanIds;
}
