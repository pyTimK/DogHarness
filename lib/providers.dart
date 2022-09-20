import 'package:bluetooth_app_test/models/dog.dart';
import 'package:bluetooth_app_test/models/owner.dart';
import 'package:bluetooth_app_test/services/storage/firebase_firestore.dart';
import 'package:bluetooth_app_test/state_notifiers/default_date_notifier.dart';
import 'package:bluetooth_app_test/state_notifiers/is_user_registered_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//
final nullableUserProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.userChanges();
});

//
final isUserRegisteredProvider = StateNotifierProvider<IsUserRegisteredNotifier, AsyncValue<bool>>((ref) {
  final user = ref.watch(nullableUserProvider).value;
  return IsUserRegisteredNotifier(user);
});

//
final ownerProvider = FutureProvider<Owner?>((ref) async {
  final user = ref.watch(nullableUserProvider);
  final isUserRegistered = ref.watch(isUserRegisteredProvider);
  if (user.value == null || isUserRegistered.value == null || !isUserRegistered.value!) {
    return null;
  }

  final owner = await CloudFirestoreService.getOwner(user.value!.uid);
  return owner;
});

//
final dogsProvider = FutureProvider<List<Dog>>((ref) async {
  final owner = ref.watch(ownerProvider);
  if (owner.value == null) {
    return [];
  }
  final dogs = await CloudFirestoreService.getDogs(owner.value!.dogIds);
  return dogs;
});

//
final defaultDogProvider = FutureProvider<Dog?>((ref) async {
  final owner = ref.watch(ownerProvider);
  final dogs = ref.watch(dogsProvider);
  if (owner.value == null || dogs.value == null) {
    return null;
  }
  final defaultDog = dogs.value!.firstWhere((dog) => dog.id == owner.value!.defaultDogId);
  return defaultDog;
});

//
final defaultDateProvider = StateNotifierProvider<DefaultDateNotifier, AsyncValue<DateTime>>(
  (ref) => DefaultDateNotifier(),
);
