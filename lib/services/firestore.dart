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
  Stream<QuerySnapshot> classesListStream() {
    return FirebaseFirestore.instance.collection('Class').snapshots();
  }
}
