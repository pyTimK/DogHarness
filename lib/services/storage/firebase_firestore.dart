import 'package:bluetooth_app_test/models/dog.dart';
import 'package:bluetooth_app_test/models/owner.dart';
import 'package:bluetooth_app_test/models/record.dart';
import 'package:bluetooth_app_test/models/record_date.dart';
import 'package:bluetooth_app_test/models/record_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  static Future<String> addOwner(Owner owner, {DocumentReference? doc}) async {
    if (doc == null) {
      final docRef = await _ownerCollection.add(owner.toMap());
      return docRef.id;
    }

    await doc.set(owner.toMap());
    return doc.id;
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

  static Stream<Owner> getOwner(String id) {
    return _ownerCollection.doc(id).snapshots().map((snapshot) {
      return Owner.fromMap(snapshot.data()!, snapshot.id);
    });
  }

  //! Dog
  static Future<String> addDog(Dog dog) async {
    final docRef = await _dogCollection.add(dog.toMap());
    return docRef.id;
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

  //! Record
  static Future<String> addRecord(Record record) async {
    final docRef = await _recordCollection.add(record.toMap());
    return docRef.id;
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

  //? Get owner in stream
  // static Stream<Owner> getOwner(String id) {
  //   return ownerCollection.doc(id).snapshots().map((snapshot) {
  //     return Owner.fromMap(snapshot.data()!, snapshot.id);
  //   });
  // }

  //? Get all owners in stream
  // static Stream<List<Owner>> owners() {
  //   return ownerCollection.snapshots().map((snapshot) {
  //     return snapshot.docs.map((doc) => Owner.fromMap(doc.data(), doc.id)).toList();
  //   });
  // }

  static String get generateOwnerId => _ownerCollection.doc().id;
  static String get generateDogId => _dogCollection.doc().id;

  static Future<void> register(Owner owner, Dog dog) {
    final ownerRef = _ownerCollection.doc(owner.id);
    final dogRef = _dogCollection.doc(dog.id);
    final recordRef = _recordCollection.doc(dog.id);

    final batch = _db.batch();

    batch.set(ownerRef, owner.toMap());
    batch.set(dogRef, dog.toMap());
    batch.set(recordRef, Record.fromNull(dog.id).toMap());

    return batch.commit();
  }
}
