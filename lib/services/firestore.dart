import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference subscribers =
      FirebaseFirestore.instance.collection('Subscriber');

  final CollectionReference gymAndManagerRef =
      FirebaseFirestore.instance.collection('Gym and Manager');

  // Fetch the current manager ID
  Future<String?> getCurrentManagerId() async {
    try {
      // Check if a user is currently authenticated
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // If a user is authenticated, obtain their user ID
        return user.uid;
      }
    } catch (e) {
      print('Error fetching current manager ID: $e');
    }
    return null; // Return null if no manager ID found
  }

  // Fetch the current gym ID
  Future<String?> getCurrentGymId() async {
    try {
      // Fetch the current manager ID
      String? managerId = await getCurrentManagerId();
      if (managerId != null) {
        // Query the 'Gym and Manager' collection to find the document associated with the managerId
        QuerySnapshot gymAndManagerSnapshot = await gymAndManagerRef
            .where('managerId', isEqualTo: managerId)
            .get();

        if (gymAndManagerSnapshot.docs.isNotEmpty) {
          DocumentSnapshot gymAndManagerDoc = gymAndManagerSnapshot.docs.first;
          return gymAndManagerDoc['gymId'];
        }
      }
    } catch (e) {
      print('Error fetching current gym ID: $e');
    }
    return null; // Return null if no gym ID found
  }

  // Function to check if 'gym_subscribers' collection exists
  Future<bool> gymSubscribersCollectionExists(String gymId) async {
    DocumentSnapshot gymDocSnapshot = await FirebaseFirestore.instance
        .collection('Gym')
        .doc(gymId)
        .collection('gym_subscribers')
        .doc('dummyDoc') // Use any existing document ID or a dummy one
        .get();

    return gymDocSnapshot.exists;
  }

  // Function to create 'gym_subscribers' collection
  Future<void> createGymSubscribersCollection(String gymId) async {
    await FirebaseFirestore.instance
        .collection('Gym')
        .doc(gymId)
        .collection('gym_subscribers')
        .doc() // Use any existing document ID or a dummy one
        .set({}); // Set empty data to create the collection
  }

  // Add a new subscriber
  Future<void> addSub({
    required String firstname,
    required String lastname,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      // Fetch the current gym ID
      String? gymId = await getCurrentGymId();
      if (gymId != null) {
        bool gymSubscribersExists = await gymSubscribersCollectionExists(gymId);
        if (!gymSubscribersExists) {
          // Create 'gym_subscribers' collection if it doesn't exist
          await createGymSubscribersCollection(gymId);
        }

        // Add the new subscriber to the 'subscribers' collection
        DocumentReference newSubscriberRef = await subscribers.add({
          'first name': firstname,
          'last name': lastname,
          'email': email,
          'phone_number': phoneNumber,
          'timestamp': Timestamp.now(),
        });

        // Add the subscriber ID to the 'gym_subscribers' collection under the gym document
        await FirebaseFirestore.instance
            .collection('Gym')
            .doc(gymId)
            .collection('gym_subscribers')
            .doc()
            .set({
          'subscriber_id': newSubscriberRef.id,
        });
      }
    } catch (e) {
      print('Error adding subscriber: $e');
    }
  }

  // Get the stream of current gym subscribers
  Stream<QuerySnapshot> getCurrentGymSubscribersStream() async* {
    try {
      // Fetch the current gym ID
      String? gymId = await getCurrentGymId();
      if (gymId != null) {
        // Get the stream of subscribers under the 'gym_subscribers' collection of the current gym
        yield* FirebaseFirestore.instance
            .collection('Gym')
            .doc(gymId)
            .collection('gym_subscribers')
            .orderBy('timestamp', descending: true)
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
}
