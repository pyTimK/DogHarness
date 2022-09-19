import 'package:bluetooth_app_test/services/storage/firebase_firestore.dart';
import 'package:flutter/cupertino.dart';

class RegistrationData extends ChangeNotifier {
  // initial load
  RegistrationData(this.uid) {
    _ownerExists();
  }

  // properties
  final String uid;

  // internal
  bool? _isRegistered;

  // getters
  bool? get isRegistered => _isRegistered;

  // setters
  set isRegistered(bool? value) {
    _isRegistered = value;
    notifyListeners();
  }

  // methods
  _ownerExists() async {
    final exists = await CloudFirestoreService.ownerExists(uid);
    isRegistered = exists;
  }
}
