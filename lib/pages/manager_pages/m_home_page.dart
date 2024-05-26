import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  int _notVerifiedCount = 0;
  int _totalSubscribersCount = 0;

  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _updateNotVerifiedCount();
    _updateTotalSubscribersCount(); // Add this call
  }

  // Function to fetch count of not verified members from Firestore and update the UI
  void _updateNotVerifiedCount() async {
    int count = await firestoreService.countDocumentsInNotVerifiedCollection();
    if (count >= 0) {
      setState(() {
        _notVerifiedCount = count;
      });
    } else {
      print('Error counting not verified documents');
    }
  }

  // Function to fetch count of total subscribers from Firestore and update the UI
  void _updateTotalSubscribersCount() async {
    int count = await firestoreService.countDocumentsInSubscribersCollection();
    if (count >= 0) {
      setState(() {
        _totalSubscribersCount = count;
      });
    } else {
      print('Error counting total subscribers');
    }
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
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Manager Dashboard',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Card for Not Verified Members
            Card(
              color: Colors.grey[800],
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Not Verified Members',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Count: $_notVerifiedCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NotVerified(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Card for Total Subscribers
            Card(
              color: Colors.grey[800],
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Subscribers',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Count: $_totalSubscribersCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GymMembers(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
