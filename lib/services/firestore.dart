import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference subscribers =
      FirebaseFirestore.instance.collection('Subscriber');

  final CollectionReference gymAndManagerRef =
      FirebaseFirestore.instance.collection('Gym and Manager');

  // Fetch the current manager ID
  Future<String?> getCurrentManagerId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      // Handle the case where no user is signed in
      return '';
    }
  }

  // Fetch the current gym ID

  Future<String?> getCurrentGymId() async {
    String? gymId;

    String? currentManagerId = await getCurrentManagerId();

    // Query the 'Gym And Managers' collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Gym And Managers')
        .where('managerId', isEqualTo: currentManagerId)
        .limit(1) // Limit the result to 1 document
        .get();

    // Extract gymId from the document if it exists
    if (querySnapshot.docs.isNotEmpty) {
      gymId = querySnapshot.docs.first['gymId'];
    }

    return gymId;
  }

  Future<void> addSub({
    required String firstname,
    required String lastname,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      // Fetch the current gym ID
      String? gymId = await getCurrentGymId();

      // add new subscriber to the 'subscribers' collection
      DocumentReference newSubscriberRef = await subscribers.add({
        'first name': firstname,
        'last name': lastname,
        'email': email,
        'phone_number': phoneNumber,
        'timestamp': Timestamp.now(),
        'gym id': gymId, // in order to link
      });

      // referencement par id
      await FirebaseFirestore.instance
          .collection('Gym')
          .doc(gymId)
          .collection('my_gym_sub')
          .doc() // current subscriber id
          .set({
        'subscriber_id': newSubscriberRef.id,
      });
    } catch (e) {
      print('Error adding subscriber: $e');
      // Handle the error as needed
      throw e; // Rethrow the exception to propagate it
    }
  }

  // Get the stream of current gym subscribers
  Stream<QuerySnapshot> getCurrentGymSubscribersStream() async* {
    try {
      // Fetch the current gym ID
      String? gymId = await getCurrentGymId();
      if (gymId != null) {
        // Get the stream of subscribers under the 'my_gym_sub' collection of the current gym
        yield* FirebaseFirestore.instance
            .collection('Gym')
            .doc(gymId)
            .collection('my_gym_sub')
            .snapshots();
      }
    } catch (e) {
      print('Error fetching current gym subscribers: $e');
      // You can handle the error here as needed
    }
  }

  // Update a subscriber by ID
  Future<void> updateSub(String docID, String newFirstName) {
    return subscribers.doc(docID).update({
      'first name': newFirstName,
      'timestamp': Timestamp.now(),
    });
  }

  // Delete a subscriber by ID
  Future<void> deleteSub(String docID) {
    return subscribers.doc(docID).delete();
  }


Future<void> addMembership({
  required String membershipName,
  required String? selectedDuration,
  required double membershipPricing,
}) async {
  try {
    String? gymId = await getCurrentGymId();
    // Add new membership to the 'Membership' collection
    DocumentReference newMembershipType = await FirebaseFirestore.instance.collection('Membership').add({
      'Membership Name': membershipName,
      'Membership Duration': selectedDuration,
      'Membership Pricing': membershipPricing,
      'gym id': gymId,
    });

    // Reference by ID
    await FirebaseFirestore.instance
        .collection('Gym')
        .doc(gymId)
        .collection('gym_membership')
        .doc()
        .set({
      'membership_id': newMembershipType.id,
    });
  } catch (e) {
    print('Error adding membership: $e');
    throw e; // Rethrow the exception to propagate it
  }
}




}
