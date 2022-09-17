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

  static Future<void> addOwner(
    String nickname,
  ) async {
    // await ownerCollection.doc(id).set({"name": name});
  }
}
