import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_project/pages/home_page.dart';
import 'package:my_flutter_project/pages/login_or_register_screen.dart';
import 'package:my_flutter_project/pages/manager_pages/gym_members.dart';
import 'package:my_flutter_project/pages/manager_pages/m_home_page.dart';

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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            // If user is logged in
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Manager')
                    .doc(user.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData && snapshot.data!.exists) {
                    // If the user's document exists in the 'Manager' collection
                    return const GymMembers(); // Redirect to GymMembers for managers
                  } else {
                    // If the user's document does not exist in the 'Manager' collection
                    return HomePage(); // Redirect to HomePage for non-managers
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
