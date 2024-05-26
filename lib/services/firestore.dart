import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference subscribers =
      FirebaseFirestore.instance.collection('Subscriber');

////////////////////////////////////// ADD NEW SUBSCRIBER //////////////////////////////////////
  Future<String> addSubscriber({
    required String fname,
    required String lname,
    required String email,
    required String phone,
    required String selectedDuration,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // Check if the email already exists in the Subscriber collection
      QuerySnapshot existingSubscribers = await FirebaseFirestore.instance
          .collection('Subscriber')
          .where('email', isEqualTo: email)
          .get();

      if (existingSubscribers.docs.isNotEmpty) {
        return 'Email already exists in the Subscriber collection.';
      }

      // Add the new subscriber if the email does not exist
      DocumentReference newMemberRef =
          await FirebaseFirestore.instance.collection('Subscriber').add({
        'fname': fname,
        'lname': lname,
        'email': email,
        'phone_number': phone,
        'selected_duration': selectedDuration,
        'start_date': startDate,
        'end_date': endDate,
        'timestamp': Timestamp.now(),
      });

      // tesssst
      print('Subscriber added successfully with ID: ${newMemberRef.id}');
      return 'Subscriber added successfully.';
    } catch (e) {
      print('Error adding subscriber: $e');
      // Rethrow the error with more context
      throw Exception('Failed to add subscriber. Please try again later.');
    }
  }

/////////////////////////////////// DISPLAY SUBSCRIBERS /////////////////////////////////////
  Stream<QuerySnapshot> subscribersListStream() {
    return FirebaseFirestore.instance.collection('Subscriber').snapshots();
  }

  // Update a subscriber by ID
  Future<void> updateSub(
      String docID,
      String newFirstName,
      String newLastName,
      String newEmail,
      String newPhone,
      String newSelectedDuration,
      String newStartDate,
      String newEndDate) {
    return subscribers.doc(docID).update({
      'fname': newFirstName,
      'lname': newLastName,
      'email': newEmail,
      'phone': newPhone,
      'selected_duration': newSelectedDuration,
      'start_date': Timestamp.fromDate(DateTime.parse(newStartDate)),
      'end_date': Timestamp.fromDate(DateTime.parse(newEndDate)),
      'timestamp': Timestamp.now(),
    });
  }

  // Delete a subscriber by ID
  Future<void> deleteSub(String docID) {
    return subscribers.doc(docID).delete();
  }

///////////////////////////////////////// NEW MEMBERSHIP ////////////////////////////////////////
  Future<void> addMembership({
    required String? selectedDuration,
    required double membershipPricing,
  }) async {
    // Validate input parameters

    if (selectedDuration == null || selectedDuration.isEmpty) {
      throw ArgumentError('Selected duration cannot be empty');
    }
    if (membershipPricing <= 0) {
      throw ArgumentError('Membership pricing must be a positive value');
    }

    try {
      // Optionally, check if the membership already exists
      QuerySnapshot existingMemberships = await FirebaseFirestore.instance
          .collection('Membership')
          .where('Membership Duration', isEqualTo: selectedDuration)
          .get();

      if (existingMemberships.docs.isNotEmpty) {
        throw Exception(
            'A membership with the same name and duration already exists.');
      }

      // Add new membership to the 'Membership' collection
      DocumentReference newMembershipType =
          await FirebaseFirestore.instance.collection('Membership').add({
        'Membership Duration': selectedDuration,
        'Membership Pricing': membershipPricing,
      });

      // Optionally, log or return a success message
      print('Membership added successfully with ID: ${newMembershipType.id}');
    } catch (e) {
      print('Error adding membership: $e');
      // Rethrow the error with more context
      throw Exception('Failed to add membership. Please try again later.');
    }
  }

  Future<List<String>> fetchMembershipDurations() async {
    try {
      // Query the 'Membership' collection to fetch all documents
      QuerySnapshot membershipSnapshots =
          await FirebaseFirestore.instance.collection('Membership').get();

      // Extract membership durations from the snapshots
      List<String> membershipDurations = membershipSnapshots.docs
          .map((doc) => doc['Membership Duration'] as String)
          .toList();

      // Return the list of membership durations
      return membershipDurations;
    } catch (e) {
      print('Error fetching membership durations: $e');
      // Rethrow the error with more context
      throw Exception(
          'Failed to fetch membership durations. Please try again later.');
    }
  }

//////////////////////////////////////// DISPLAY MEMBERSHIPS ////////////////////////////////////////
  Stream<QuerySnapshot> membershipsListStream() {
    return FirebaseFirestore.instance.collection('Membership').snapshots();
  }

  // Update a membership by ID
  Future<void> updateMembership(String docID, String newMembershipName,
      String newMembershipDuration, double newMembershipPricing) {
    return FirebaseFirestore.instance
        .collection('Membership')
        .doc(docID)
        .update({
      'Membership Name': newMembershipName,
      'Membership Duration': newMembershipDuration,
      'Membership Pricing': newMembershipPricing,
    });
  }

  // Delete a membership by ID
  Future<void> deleteMembership(String docID) {
    return FirebaseFirestore.instance
        .collection('Membership')
        .doc(docID)
        .delete();
  }

///////////////////////////////////////// ADD CLASS ////////////////////////////////////////
  Future<void> addClass({
    required String className,
    required String coach,
    required int capacity,
    required DateTime? scheduledDate,
    required DateTime? startTime,
    required DateTime? endTime,
  }) async {
    // Validate input parameters
    if (className.isEmpty) {
      throw ArgumentError('Class name cannot be empty');
    }
    if (coach.isEmpty) {
      throw ArgumentError('Coach name cannot be empty');
    }
    if (capacity <= 0) {
      throw ArgumentError('Capacity must be a positive integer');
    }
    if (scheduledDate == null) {
      throw ArgumentError('Scheduled date cannot be null');
    }
    if (startTime == null) {
      throw ArgumentError('Start time cannot be null');
    }
    if (endTime == null) {
      throw ArgumentError('End time cannot be null');
    }
    if (startTime.isAfter(endTime)) {
      throw ArgumentError('Start time must be before end time');
    }

    try {
      // Check for schedule conflicts
      QuerySnapshot existingClasses = await FirebaseFirestore.instance
          .collection('Class')
          .where('Coach', isEqualTo: coach)
          .where('Scheduled Time', isEqualTo: scheduledDate)
          .where('Start Time', isEqualTo: startTime)
          .get();

      if (existingClasses.docs.isNotEmpty) {
        throw Exception(
            'There is already a class with the same coach at the same time.');
      }

      // Add new class to the 'Class' collection
      await FirebaseFirestore.instance.collection('Class').add({
        'Class Name': className,
        'Coach': coach,
        'Capacity': capacity,
        'Scheduled Time': scheduledDate,
        'Creation Date': Timestamp.now(),
        'Start Time': startTime,
        'End Time': endTime,
      });

      // Optionally, log a success message
      print('Class added successfully');
    } catch (e) {
      print('Error adding class: $e');
      // Rethrow the error with more context
      throw Exception('Failed to add class. Please try again later.');
    }
  }

///////////////////////////////////////// DISPLAY CLASSES ////////////////////////////////////////

  Stream<QuerySnapshot> notVerifListStream() {
    return FirebaseFirestore.instance.collection('Not Verified').snapshots();
  }

  Future<int> countDocumentsInNotVerifiedCollection() async {
    try {
      // Get a reference to Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the "Not Verified" collection
      CollectionReference notVerifiedCollectionRef =
          firestore.collection('Not Verified');

      // Get the documents in the collection
      QuerySnapshot snapshot = await notVerifiedCollectionRef.get();

      // Count the number of documents
      int count = snapshot.size;

      // Return the count
      return count;
    } catch (e) {
      print('Error counting documents: $e');
      // Return -1 or any other value to indicate an error
      return -1;
    }
  }

  Future<int> countDocumentsInSubscribersCollection() async {
    try {
      // Get a reference to Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the "Not Verified" collection
      CollectionReference subRef = firestore.collection('Subscriber');

      // Get the documents in the collection
      QuerySnapshot snapshot = await subRef.get();

      // Count the number of documents
      int count = snapshot.size;

      // Return the count
      return count;
    } catch (e) {
      print('Error counting documents: $e');
      // Return -1 or any other value to indicate an error
      return -1;
    }
  }

  Future<void> addNewUser({
    required String fname,
    required String lname,
    required String email,
    required String phone,
    required String role,
  }) async {
    try {
      // Check if the email already exists in the collection
      QuerySnapshot existingUsers = await FirebaseFirestore.instance
          .collection(role)
          .where('email', isEqualTo: email)
          .get();

      if (existingUsers.docs.isNotEmpty) {
        throw Exception('Email already exists in the $role collection.');
      }

      // Get the document from "Not Verified" collection
      QuerySnapshot notVerifiedUsers = await FirebaseFirestore.instance
          .collection('Not Verified')
          .where('email', isEqualTo: email)
          .get();

      if (notVerifiedUsers.docs.isEmpty) {
        throw Exception(
            'No user found in "Not Verified" collection with the provided email.');
      }

      DocumentSnapshot notVerifiedDoc = notVerifiedUsers.docs.first;
      String notVerifiedDocId = notVerifiedDoc.id;

      // Add the new user to the specified role collection with the same ID
      await FirebaseFirestore.instance
          .collection(role)
          .doc(notVerifiedDocId)
          .set({
        'fname': fname,
        'lname': lname,
        'email': email,
        'phone_number': phone,
        'timestamp': Timestamp.now(),
      });

      print('User added successfully with ID: $notVerifiedDocId');

      // Delete the user data from the 'Not Verified' collection
      await FirebaseFirestore.instance
          .collection('Not Verified')
          .doc(notVerifiedDocId)
          .delete();

      print('User data deleted from "Not Verified" collection');
    } catch (e) {
      print('Error adding user: $e');
      throw Exception('Failed to add user. Please try again later.');
    }
  }

  Future<void> deleteNotVerifiedUser(String email) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Not Verified')
          .where('email', isEqualTo: email)
          .get();

      snapshot.docs.forEach((doc) {
        doc.reference.delete();
        print('User data deleted from "Not Verified" collection');
      });
    } catch (e) {
      print('Error deleting user: $e');
      throw Exception('Failed to delete user. Please try again later.');
    }
  }

// Method to calculate the number of new subscribers for each month
  Future<Map<String, int>> calculateNewSubscribersByMonth() async {
    try {
      // Get all subscribers from Firestore
      QuerySnapshot subscriberSnapshot =
          await subscribers.orderBy('timestamp').get();

      // Map to store the count of new subscribers for each month
      Map<String, int> newSubscribersByMonth = {};

      // Iterate through each subscriber document
      for (QueryDocumentSnapshot subscriberDoc in subscriberSnapshot.docs) {
        // Extract timestamp of subscriber registration
        Map<String, dynamic>? data =
            subscriberDoc.data() as Map<String, dynamic>?;

        if (data != null) {
          Timestamp? timestamp = data['timestamp'] as Timestamp?;

          // Perform null check before proceeding
          if (timestamp != null) {
            // Extract year and month from timestamp
            String yearMonth =
                '${timestamp.toDate().year}-${timestamp.toDate().month}';

            // If the month doesn't exist in the map, initialize count to 1
            if (!newSubscribersByMonth.containsKey(yearMonth)) {
              newSubscribersByMonth[yearMonth] = 1;
            } else {
              // Increment count if month already exists
              newSubscribersByMonth[yearMonth] =
                  (newSubscribersByMonth[yearMonth] ?? 0) + 1;
            }
          }
        }
      }

      return newSubscribersByMonth;
    } catch (e) {
      print('Error calculating new subscribers by month: $e');
      // Rethrow the error with more context
      throw Exception(
          'Failed to calculate new subscribers by month. Please try again later.');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCoaches() async {
    try {
      // Get all documents from the "Coach" collection
      QuerySnapshot coachSnapshots =
          await FirebaseFirestore.instance.collection('Coach').get();

      // Extract the id, fname, lname, and fullname from each document
      List<Map<String, dynamic>> coaches = coachSnapshots.docs.map((doc) {
        return {
          'id': doc.id,
          'fname': doc['fname'],
          'lname': doc['lname'],
          'fullname': '${doc['fname']} ${doc['lname']}',
        };
      }).toList();

      // Return the list of coaches
      return coaches;
    } catch (e) {
      print('Error fetching coaches: $e');
      // Rethrow the error with more context
      throw Exception('Failed to fetch coaches. Please try again later.');
    }
  }

  Stream<QuerySnapshot> classesListStream() {
    return FirebaseFirestore.instance.collection('Class').snapshots();
  }

  Future<String> fetchCoachName() async {
    final snapshot = await classesListStream().first;
    if (snapshot.docs.isEmpty) {
      return '';
    }

    List<QueryDocumentSnapshot> sortedClasses =
        snapshot.docs.cast<QueryDocumentSnapshot>();
    sortedClasses.sort((a, b) {
      DateTime aStartTime = (a['Start Time'] as Timestamp).toDate();
      DateTime bStartTime = (b['Start Time'] as Timestamp).toDate();
      return aStartTime.compareTo(bStartTime);
    });

    DateTime now = DateTime.now();
    DateTime nextClassTime = DateTime.fromMillisecondsSinceEpoch(9999999999999);
    String coachName = '';
    for (QueryDocumentSnapshot classDocument in sortedClasses) {
      DateTime startTime = (classDocument['Start Time'] as Timestamp).toDate();
      if (startTime.isAfter(now) && startTime.isBefore(nextClassTime)) {
        nextClassTime = startTime;
        coachName = classDocument['Coach'] as String;
      }
    }

    return coachName;
  }
  
}
