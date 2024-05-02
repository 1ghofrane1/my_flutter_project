import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Get collection of Subscribers
  final CollectionReference subscribers =
      FirebaseFirestore.instance.collection('Subscriber');

  // Create: add a new subscriber
  Future<void> addSub({
    required String firstname,
    required String lastname,
    required String email,
    required String phoneNumber,
  }) {
    return subscribers.add({
      'first name': firstname,
      'last name': lastname,
      'email': email,
      'phone_number': phoneNumber,
      'timestamp': Timestamp.now(),
      // Add more fields as needed
    });
  }

  // read: get all subscribers from database
  Stream<QuerySnapshot> getAllSubsStream() {
    final SubsStream =
        subscribers.orderBy('timestamp', descending: true).snapshots();
    return SubsStream;
  }

  // update a sub  by ID
  Future<void> updateSub(String docID, String NewFirstName) {
    return subscribers.doc(docID).update({
      'first name': NewFirstName,
      'timestamp': Timestamp.now(),
    });
  }
  // delete a sub by ID
  Future<void> deleteSub(String docID){
    return subscribers.doc(docID).delete();
  }
}
