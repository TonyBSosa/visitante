import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference visitors =
      FirebaseFirestore.instance.collection('visitors');

  // Create a new visitor
  Future<void> addVisitor(Map<String, dynamic> visitorData) {
    return visitors.add(visitorData);
  }

  // Get stream of visitors
  Stream<QuerySnapshot> getVisitorsStream() {
    return visitors.orderBy('entryTime', descending: true).snapshots();
  }

  // Update visitor
  Future<void> updateVisitor(String docID, Map<String, dynamic> updatedData) {
    return visitors.doc(docID).update(updatedData);
  }

  // Delete visitor
  Future<void> deleteVisitor(String docID) {
    return visitors.doc(docID).delete();
  }
}
