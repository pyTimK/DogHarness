import 'package:bluetooth_app_test/models/dog.dart';
import 'package:bluetooth_app_test/models/owner.dart';
import 'package:bluetooth_app_test/models/record.dart';
import 'package:bluetooth_app_test/models/record_date.dart';
import 'package:bluetooth_app_test/models/record_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CloudFirestoreService {
  static final db = FirebaseFirestore.instance;
  static final ownerCollection = db.collection("owner");
  static final dogCollection = db.collection("dog");
  static final recordCollection = db.collection("record");

  static CollectionReference<Map<String, dynamic>> dateCollection(String recordId) =>
      recordCollection.doc(recordId).collection("date");
  static CollectionReference<Map<String, dynamic>> timeCollection(String recordId, String dateId) =>
      dateCollection(recordId).doc(dateId).collection("time");

  //! Owner
  static Future<String> addOwner(Owner owner, {DocumentReference? doc}) async {
    if (doc == null) {
      final docRef = await ownerCollection.add(owner.toMap());
      return docRef.id;
    }

    await doc.set(owner.toMap());
    return doc.id;
  }

  static Future<void> updateOwner(Owner owner) async {
    await ownerCollection.doc(owner.id).update(owner.toMap());
  }

  static Future<void> deleteOwner(Owner owner) async {
    await ownerCollection.doc(owner.id).delete();
  }

  static Future<bool> ownerExists(String uid) async {
    // final doc = await FirebaseFirestore.instance.collection("owner").doc(uid).get();
    final doc = await ownerCollection.doc(uid).get();
    return doc.exists;
  }

  static Future<Owner?> getOwner(String ownerId) async {
    final doc = await ownerCollection.doc(ownerId).get();
    if (doc.exists && doc.data() != null) {
      return Owner.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  //! Dog
  static Future<String> addDog(Dog dog) async {
    final docRef = await dogCollection.add(dog.toMap());
    return docRef.id;
  }

  static Future<void> updateDog(Dog dog) async {
    await dogCollection.doc(dog.id).update(dog.toMap());
  }

  static Future<void> deleteDog(Dog dog) async {
    await dogCollection.doc(dog.id).delete();
  }

  static Future<Dog?> getDog(String dogId) async {
    final doc = await dogCollection.doc(dogId).get();
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
    final docRef = await recordCollection.add(record.toMap());
    return docRef.id;
  }

  static Future<void> updateRecord(Record record) async {
    await recordCollection.doc(record.id).update(record.toMap());
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
    await recordCollection.doc(record.id).delete();
  }

  static Future<Record?> getRecord(String recordId) async {
    final doc = await recordCollection.doc(recordId).get();
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

  static String get generateOwnerId => ownerCollection.doc().id;
  static String get generateDogId => dogCollection.doc().id;

  static Future<void> register(Owner owner, Dog dog) {
    final ownerRef = ownerCollection.doc(owner.id);
    final dogRef = dogCollection.doc(dog.id);
    final recordRef = recordCollection.doc(dog.id);

    final batch = db.batch();

    batch.set(ownerRef, owner.toMap());
    batch.set(dogRef, dog.toMap());
    batch.set(recordRef, Record.fromNull(dog.id).toMap());

    return batch.commit();
  }
}
