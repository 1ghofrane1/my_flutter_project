/*
import 'package:flutter/material.dart';

class FetchUser extends StatelessWidget {
  const FetchUser({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';

// Define a function that fetches the courses attended by a student from Firestore
Future<List<Map<String, dynamic>>> fetchCourses(String studentId) async {
  // Reference to the Firestore instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Reference to the "students" collection and the "attending" subcollection
  CollectionReference studentRef = firestore.collection('students');
  CollectionReference attendingRef =
      studentRef.doc(studentId).collection('attending');

  // Retrieve course IDs the student is attending
  QuerySnapshot courseIds = await attendingRef.get();

  // Fetch details of each course asynchronously
  List<DocumentSnapshot> courseDocs =
      await Future.wait(courseIds.docs.map((doc) {
    // Fetch the course document from the "courses" collection
    return firestore.collection('courses').doc(doc.id).get();
  }));

  // Filter out non-existent courses and format the data
  List<Map<String, dynamic>> courses = courseDocs
      .where((doc) => doc.exists) // Filter out non-existent courses
      .map((doc) => {
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>
          }) // Format the data into a map
      .toList(); // Convert the filtered courses into a list

  return courses; // Return the list of courses
}

void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    String gymName = _gymNameController.text;
    String address = _addressController.text;
    String phoneNumber = _phoneNumberController.text;

    // Add gym details to Firestore
    DocumentReference gymRef =
        await FirebaseFirestore.instance.collection('Gyms').add({
      'gymName': gymName,
      'address': address,
      'phoneNumber': phoneNumber,
    });

    // Get the gym ID assigned by Firestore
    String gymId = gymRef.id;

    // Retrieve the manager ID associated with the current user
    String managerId = getCurrentUserId(); // Replace this with the code to retrieve the manager ID

    // Add gym manager and link to the gym
    addGymManager(gymId, managerId);
    addGymToManager(gymId, managerId);

    // Navigate to the home page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }
}

void getCurrentUserId() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String userId = user.uid;
    return userId;
  }
}
*/