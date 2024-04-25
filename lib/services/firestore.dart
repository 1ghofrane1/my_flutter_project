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
      // Add more fields as needed
    });
  }
}
