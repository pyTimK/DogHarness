import 'dart:io';

import 'package:bluetooth_app_test/models/dog.dart';
import 'package:bluetooth_app_test/models/owner.dart';
import 'package:bluetooth_app_test/models/record.dart';
import 'package:bluetooth_app_test/models/record_date.dart';
import 'package:bluetooth_app_test/models/record_location.dart';
import 'package:bluetooth_app_test/services/storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class CloudFirestoreService {
  static final _db = FirebaseFirestore.instance;
  static final _ownerCollection = _db.collection("owner");
  static final _dogCollection = _db.collection("dog");
  static final _recordCollection = _db.collection("record");

  static CollectionReference<Map<String, dynamic>> dateCollection(String recordId) =>
      _recordCollection.doc(recordId).collection("date");
  static CollectionReference<Map<String, dynamic>> timeCollection(String recordId, String dateId) =>
      dateCollection(recordId).doc(dateId).collection("time");

  //! Owner
  static Future<String> addOwner(Owner owner) async {
    final docRef = await _ownerCollection.add(owner.toMap());
    return docRef.id;
  }

  static Future<void> setOwner(Owner owner) async {
    await _ownerCollection.doc(owner.id).set(owner.toMap());
  }

  static Future<void> updateOwner(Owner owner) async {
    await _ownerCollection.doc(owner.id).update(owner.toMap());
  }

  static Future<void> deleteOwner(Owner owner) async {
    await _ownerCollection.doc(owner.id).delete();
  }

  static Future<bool> ownerExists(String uid) async {
    // final doc = await FirebaseFirestore.instance.collection("owner").doc(uid).get();
    final doc = await _ownerCollection.doc(uid).get();
    return doc.exists;
  }

  static Future<Owner?> getOwner(String uid) async {
    final doc = await _ownerCollection.doc(uid).get();
    if (!doc.exists) return null;
    return Owner.fromMap(doc.data()!, doc.id);
  }

  static Stream<Owner> getOwnerStream(String id) {
    return _ownerCollection.doc(id).snapshots().map((snapshot) {
      return Owner.fromMap(snapshot.data()!, snapshot.id);
    });
  }

  //! Dog
  static Future<String> addDog(Dog dog) async {
    final docRef = await _dogCollection.add(dog.toMap());
    return docRef.id;
  }

  static Future<void> setDog(Dog dog) async {
    await _dogCollection.doc(dog.id).set(dog.toMap());
  }

  static Future<void> updateDog(Dog dog) async {
    await _dogCollection.doc(dog.id).update(dog.toMap());
  }

  static Future<void> deleteDog(Dog dog) async {
    await _dogCollection.doc(dog.id).delete();
  }

  static Future<Dog?> getDog(String dogId) async {
    final doc = await _dogCollection.doc(dogId).get();
    if (doc.exists && doc.data() != null) {
      return Dog.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  static Future<List<Dog>> getDogs(List<String> dogIds) async {
    final dogs = <Dog>[];
    for (final dogId in dogIds) {
      final dog = await getDog(dogId);
      if (dog != null) {
        dogs.add(dog);
      }
    }
    return dogs;
  }

  static Stream<List<Dog>> getDogsStream(List<String> dogIds) {
    return _dogCollection.where(FieldPath.documentId, whereIn: dogIds).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Dog.fromMap(doc.data(), doc.id)).toList();
    });
  }

  static Future<List<Owner>> getHumanBuddies(Dog dog) async {
    final buddies = <Owner>[];
    for (final humanId in dog.humanIds) {
      final human = await getOwner(humanId);
      if (human != null) {
        buddies.add(human);
      }
    }

    return buddies;
  }

  static Future<void> addDogToOwner({required Owner owner, required String dogId}) async {
    if (owner.dogIds.contains(dogId)) {
      return;
    }

    final dog = await getDog(dogId);
    if (dog == null) return;
    await updateOwner(owner.copyWith(dogIds: [...owner.dogIds, dogId]));
    await updateDog(dog.copyWith(humanIds: [...dog.humanIds, owner.id]));
  }

  //! Record
  static Future<String> addRecord(Record record) async {
    final docRef = await _recordCollection.add(record.toMap());
    return docRef.id;
  }

  static Future<void> setRecord(Record record) async {
    await _recordCollection.doc(record.id).set(record.toMap());
  }

  static Future<void> updateRecord(Record record) async {
    await _recordCollection.doc(record.id).update(record.toMap());
  }

  static Future<void> deleteRecord(Record record) async {
    await dateCollection(record.id!).get().then((snapshot) async {
      for (DocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        // get doc
        if (doc.data() != null) {
          final recordDate = RecordDate.fromMap(doc.data()!, doc.id);
          await deleteRecordDate(recordDate, record.id!);
        }
      }
    });
    await _recordCollection.doc(record.id).delete();
  }

  static Future<Record?> getRecord(String recordId) async {
    final doc = await _recordCollection.doc(recordId).get();
    if (doc.exists && doc.data() != null) {
      return Record.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  //! Record Date
  static Future<String> addRecordDate(RecordDate recordDate, String recordId) async {
    final docRef = await dateCollection(recordId).add(recordDate.toMap());
    return docRef.id;
  }

  static Future<void> setRecordDate(RecordDate recordDate, String recordId) async {
    await dateCollection(recordId).doc(recordDate.id).set(recordDate.toMap());
  }

  static Future<void> updateRecordDate(RecordDate recordDate, String recordId) async {
    await dateCollection(recordId).doc(recordDate.id).update(recordDate.toMap());
  }

  static Future<void> deleteRecordDate(RecordDate recordDate, String recordId) async {
    await timeCollection(recordId, recordDate.id!).get().then((value) {
      for (final doc in value.docs) {
        doc.reference.delete();
      }
    });
    await dateCollection(recordId).doc(recordDate.id).delete();
  }

  static Future<RecordDate?> getRecordDate(String recordId, String dateId) async {
    final doc = await dateCollection(recordId).doc(dateId).get();
    if (doc.exists && doc.data() != null) {
      return RecordDate.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  //! Record Location
  static Future<String> addRecordLocation(RecordLocation recordLocation, String recordId, String dateId) async {
    final docRef = await timeCollection(recordId, dateId).add(recordLocation.toMap());
    return docRef.id;
  }

  static Future<void> setRecordLocation(RecordLocation recordLocation, String recordId, String dateId) async {
    await timeCollection(recordId, dateId).doc(recordLocation.id).set(recordLocation.toMap());
  }

  static Future<void> updateRecordLocation(RecordLocation recordLocation, String recordId, String dateId) async {
    await timeCollection(recordId, dateId).doc(recordLocation.id).update(recordLocation.toMap());
  }

  static Future<void> deleteRecordLocation(RecordLocation recordLocation, String recordId, String dateId) async {
    await timeCollection(recordId, dateId).doc(recordLocation.id).delete();
  }

  static Future<RecordLocation?> getRecordLocation(String recordId, String dateId, String timeId) async {
    final doc = await timeCollection(recordId, dateId).doc(timeId).get();
    if (doc.exists && doc.data() != null) {
      return RecordLocation.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  static Future<List<RecordLocation>> getRecordLocations(String recordId, String recordDateId) async {
    final locations = <RecordLocation>[];
    final snapshot = await timeCollection(recordId, recordDateId).get();
    for (final doc in snapshot.docs) {
      locations.add(RecordLocation.fromMap(doc.data(), doc.id));
    }
    return locations;
  }

  static String get generateDogId => _dogCollection.doc().id;

  static Future<void> registerDog({
    required String id,
    File? avatar,
    required String name,
    required DogBreed breed,
    required DogSize size,
    required DateTime birthday,
    required String ownerId,
  }) async {
    // Upload avatar
    final dogPhotoUrl = await FirebaseStorageService.uploadImage(id: id, image: avatar, isOwner: false);

    // Create Dog
    final dog = Dog(
      id: id,
      name: name,
      breed: breed,
      size: size,
      birthday: birthday,
      ownerId: ownerId,
      humanIds: const [],
      photoUrl: dogPhotoUrl,
    );

    // Save Dog
    setDog(dog);
  }

  static Future<void> registerOwner({
    required User user,
    File? ownerAvatar,
    required String nickname,
    required String defaultDogId,
  }) async {
    // Upload avatar
    final ownerPhotoUrl = await FirebaseStorageService.uploadImage(id: user.uid, image: ownerAvatar);

    // Create Owner
    final owner = Owner(
      id: user.uid,
      nickname: nickname,
      email: user.email!,
      dogIds: [defaultDogId],
      defaultDogId: defaultDogId,
      photoUrl: ownerPhotoUrl ?? user.photoURL,
    );

    // Save Owner
    setOwner(owner);
  }
}
