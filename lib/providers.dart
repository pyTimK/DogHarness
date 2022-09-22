import 'package:bluetooth_app_test/helpers/date_helper.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:bluetooth_app_test/models/dog.dart';
import 'package:bluetooth_app_test/models/owner.dart';
import 'package:bluetooth_app_test/models/record.dart';
import 'package:bluetooth_app_test/models/record_date.dart';
import 'package:bluetooth_app_test/models/record_location.dart';
import 'package:bluetooth_app_test/services/storage/firebase_firestore.dart';
import 'package:bluetooth_app_test/state_notifiers/is_user_registered_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//
final userProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.userChanges();
});

//
final isUserRegisteredProvider = StateNotifierProvider<IsUserRegisteredNotifier, AsyncValue<bool>>((ref) {
  final user = ref.watch(userProvider).value;
  return IsUserRegisteredNotifier(user);
});

final ownerProvider = StreamProvider<Owner>((ref) {
  final user = ref.watch(userProvider).value;
  if (user == null) return const Stream.empty();
  return CloudFirestoreService.getOwner(user.uid);
});

//
final dogsProvider = FutureProvider<List<Dog>>((ref) async {
  final dogIds = await ref.watch(ownerProvider.selectAsync((owner) => owner.dogIds));
  final dogs = await CloudFirestoreService.getDogs(dogIds);
  return dogs;
});

//
final defaultDogProvider = Provider<Dog?>((ref) {
  final defaultDogId = ref.watch(ownerProvider.select((owner) => owner.value?.defaultDogId));
  final dogs = ref.watch(dogsProvider.select((dogs) => dogs.value));

  if (defaultDogId == null || dogs == null || !dogs.map((dog) => dog.id).contains(defaultDogId)) {
    return null;
  }

  final defaultDog = dogs.firstWhere((dog) => dog.id == defaultDogId);
  return defaultDog;
});

//
final defaultDateProvider = StateProvider<DateTime>((ref) {
  return DateHelper.now;
});

//
final recordProvider = FutureProvider<Record?>((ref) async {
  final defaultDogId = ref.watch(defaultDogProvider.select((dog) => dog?.id));

  if (defaultDogId == null) {
    return null;
  }

  final record = await CloudFirestoreService.getRecord(defaultDogId);
  return record;
});

//
final recordDateProvider = FutureProvider<RecordDate?>((ref) async {
  final recordId = await ref.watch(recordProvider.selectAsync((record) => record?.id));
  final defaultDate = ref.watch(defaultDateProvider);
  final dateString = DateHelper.toDateString(defaultDate);

  logger.wtf(dateString);
  if (recordId == null) {
    return null;
  }

  final recordDate = await CloudFirestoreService.getRecordDate(recordId, dateString);
  return recordDate;
});

//
final recordLocationProvider = FutureProvider<List<RecordLocation>>((ref) async {
  final recordId = await ref.watch(recordProvider.selectAsync((record) => record?.id));
  final recordDateId = await ref.watch(recordDateProvider.selectAsync((recordDate) => recordDate?.id));

  if (recordId == null || recordDateId == null) {
    return [];
  }
  final recordLocation = await CloudFirestoreService.getRecordLocations(recordId, recordDateId);
  return recordLocation;
});
