import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_project/components/my_button.dart';
import 'manage_sub.dart';

class MHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user's ID
    // ignore: unused_local_variable
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Dashboard'),
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
      body: Center(
        child: MyButton(
          text: 'Manage USERS',
          onTap: () {
            // Navigate to ManageSub when the button is tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ManageSub()),
            );
          },
        ),
      ),
    );
  }
}
