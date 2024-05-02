import 'package:cloud_firestore/cloud_firestore.dart';

class CRUDsubscribers {
  // get collection of sub
  final CollectionReference subscribers =
      FirebaseFirestore.instance.collection('Subscribers');

  // create a new sub profile
  Future<void> addSub(String FN, String LN) {
    return subscribers.add({
      'First  Name': FN,
      'Last Name': LN,
      'timestamp': Timestamp.now(),
    });
  }
}
