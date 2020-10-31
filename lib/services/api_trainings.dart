import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class ApiTrainings {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String path;
  CollectionReference ref;

  ApiTrainings(this.path) {
    ref = _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.get();
  }

  Future<QuerySnapshot> getQueryCollection(dynamic array, dynamic value) {
    return ref.where(array, isEqualTo: value).get();
  }

  Future<QuerySnapshot> getTrainingsByDate(
      dynamic array, dynamic value, dynamic date) {
    return ref
        .where(array, isEqualTo: value)
        .where("trainingDate", isEqualTo: date)
        .get();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.doc(id).get();
  }

  Future<void> removeDocument(String id) {
    return ref.doc(id).delete();
  }

  Future<DocumentReference> addDocument(Map data) {
    return ref.add(data);
  }

  Future<void> updateDocument(Map data, String id) {
    return ref.doc(id).update(data);
  }
}
