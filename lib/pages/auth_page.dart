import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_project/pages/gym_acc.dart';
import 'package:my_flutter_project/pages/home_page.dart';
import 'package:my_flutter_project/pages/login_or_register_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for the authentication state
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            // If user is logged in
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Gym Managers')
                    .doc(user.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData && snapshot.data!.exists) {
                    // If the user's document exists in the 'Gym Managers' collection
                    return const GymAcc(); // Display GymAcc widget
                  } else {
                    // If the user's document does not exist in the 'Gym Managers' collection
                    return HomePage(); // Display HomePage widget
                  }
                },
              );
            } else {
              // If no user data is available, return the login or register screen
              return const LoginOrRegisterScreen();
            }
          } else {
            // If user is not logged in, return the login or register screen
            return const LoginOrRegisterScreen();
          }
        },
      ),
    );
  }
}
