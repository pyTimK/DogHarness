import 'package:bluetooth_app_test/models/dog.dart';
import 'package:bluetooth_app_test/models/owner.dart';
import 'package:bluetooth_app_test/services/storage/firebase_firestore.dart';
import 'package:flutter/cupertino.dart';

class AccountData extends ChangeNotifier {
  AccountData(this.ownerId) {
    _loadData();
  }

  String ownerId;
  Owner? _owner;
  Dog? _defaultDog;
  List<Dog> _dogs = [];

  Owner? get owner => _owner;
  Dog? get defaultDog => _defaultDog;
  List<Dog> get dogs => _dogs;

  set owner(Owner? owner) {
    _owner = owner;
    notifyListeners();
  }

  set defaultDog(Dog? dog) {
    _defaultDog = dog;
    notifyListeners();
  }

  set dogs(List<Dog> dogs) {
    _dogs = dogs;
    notifyListeners();
  }

  _loadData() async {
    await _loadOwner(ownerId);
    await _loadDogs(owner!.dogIds);
    _loadDefaultDog(owner!.defaultDogId);
  }

  _loadOwner(String id) async {
    final loadedOwner = await CloudFirestoreService.getOwner(id);
    if (loadedOwner == null) {
      throw Exception("AccountData: owner is null");
    }
    owner = loadedOwner;
  }

  _loadDefaultDog(String id) {
    defaultDog = _dogs.firstWhere((dog) => dog.id == id);
  }

  _loadDogs(List<String> ids) async {
    final loadedDogs = await CloudFirestoreService.getDogs(ids);
    if (loadedDogs.isEmpty) {
      throw Exception("AccountData: dogs is empty");
    }
    dogs = loadedDogs;
  }
}
