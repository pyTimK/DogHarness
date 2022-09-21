import 'package:bluetooth_app_test/services/storage/firebase_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsUserRegisteredNotifier extends StateNotifier<AsyncValue<bool>> {
  IsUserRegisteredNotifier(User? user) : super(const AsyncValue.loading()) {
    _init(user);
  }

  Future<void> _init(User? user) async {
    if (user == null) {
      if (mounted) {
        state = const AsyncValue.data(false);
      }
      return;
    }

    final exists = await CloudFirestoreService.ownerExists(user.uid);
    if (mounted) {
      state = AsyncValue.data(exists);
    }
  }

  void setIsUserRegistered(bool isUserRegistered) {
    state = AsyncValue.data(isUserRegistered);
  }
}
