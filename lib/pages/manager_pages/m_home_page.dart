import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_project/pages/manager_pages/bottom_navbar.dart';
import 'package:my_flutter_project/pages/manager_pages/classes.dart';
import 'package:my_flutter_project/pages/manager_pages/gym_members.dart';
import 'package:my_flutter_project/pages/manager_pages/not_verified.dart';
import 'package:my_flutter_project/services/firestore.dart';

class MHomePage extends StatefulWidget {
  @override
  _MHomePageState createState() => _MHomePageState();
}

class _MHomePageState extends State<MHomePage> {
  int _selectedIndex = 0;
  int _notVerifiedCount = 0; // Add this variable to hold the count
  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    // Call the function to count documents when the widget initializes
    _updateNotVerifiedCount();
  }

  // Function to fetch count from Firestore and update the UI
  void _updateNotVerifiedCount() async {
    int count = await firestoreService.countDocumentsInNotVerifiedCollection();
    if (count >= 0) {
      updateCount(count);
    } else {
      print('Error counting documents');
    }
  }

  // Function to update the count and refresh the UI
  void updateCount(int count) {
    setState(() {
      _notVerifiedCount = count;
    });
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      if (index == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GymMembers()),
        );
      } else if (index == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Classes()),
        );
      }
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home Screen Content'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotVerified(),
                  ),
                );
              },
              child: const Text('Go to Gym Members'),
            ),
            // Display the count of documents
            Text('Number of Not Verified documents: $_notVerifiedCount'),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
