import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user's ID
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          // Logout button
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      /*body: 
      StreamBuilder(
        // Query the "Gym Managers" collection based on the current user's ID
        stream: FirebaseFirestore.instance
            .collection('Gym Managers')
            .doc(userId)
            .snapshots(),
            
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show loading indicator
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Show error message
          }
          // Check if data is available and not null
          if (snapshot.hasData && snapshot.data!.exists) {
            // If data is successfully loaded, display the user's name
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            String name = data['name'] ??
                'No Name'; // Fetch name field or display 'No Name' if not available
            return Center(
              child: Text(
                'Logged in as: $name',
                style: TextStyle(fontSize: 20),
              ),
            );
          } else {
            // Handle case when document doesn't exist
            return Text('Document does not exist');
          }
        },
      ),*/
    );
  }
}
