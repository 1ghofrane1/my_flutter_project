import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_project/pages/manager_pages/bottom_navbar.dart';
import 'package:my_flutter_project/pages/manager_pages/classes.dart';
import 'package:my_flutter_project/pages/manager_pages/gym_members.dart';
import 'package:my_flutter_project/pages/manager_pages/not_verified.dart';
import 'package:my_flutter_project/services/firestore.dart';
import 'package:intl/intl.dart';

class MHomePage extends StatefulWidget {
  const MHomePage({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome to the Manager Dashboard',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Not Verified Members Card
            _buildCard(
              title: 'Not Verified Members',
              count: _notVerifiedCount,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotVerified()),
              ),
            ),
            const SizedBox(height: 20),
            // Total Subscribers Card
            _buildCard(
              title: 'Total Subscribers',
              count: _totalSubscribersCount,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GymMembers()),
              ),
            ),
            const SizedBox(height: 20),
            // Upcoming Classes Card
            _buildUpcomingClassesCard(),
            const SizedBox(height: 20),
            // Recent Activity Card
            _buildRecentActivityCard(),
            const SizedBox(height: 20),
            // Quick Actions Card
            _buildQuickActionsCard(),
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required int count,
    required VoidCallback onTap,
  }) {
    return Card(
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
            Text(
              title,
              style: const TextStyle(
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
                  'Count: $count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  onPressed: onTap,
                  icon: const Icon(Icons.arrow_forward),
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingClassesCard() {
    return Card(
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
              'Upcoming Classes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Example upcoming classes list
            StreamBuilder<QuerySnapshot>(
              stream: firestoreService.classesListStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                List<DocumentSnapshot> classes = snapshot.data!.docs;
                return Column(
                  children: classes.take(3).map((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    DateTime startTime =
                        (data['Start Time'] as Timestamp).toDate();
                    return ListTile(
                      title: Text(
                        data['Class Name'] ?? 'Unknown Class',
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        DateFormat('yyyy-MM-dd – kk:mm').format(startTime),
                        style: const TextStyle(color: Colors.white70),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard() {
    return Card(
      color: Colors.grey[800],
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            // Example recent activities
            ListTile(
              title: Text(
                'New member added: John Doe',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                '2 hours ago',
                style: TextStyle(color: Colors.white70),
              ),
              leading: Icon(Icons.person_add, color: Colors.white),
            ),
            ListTile(
              title: Text(
                'Class created: Yoga Basics',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                '1 day ago',
                style: TextStyle(color: Colors.white70),
              ),
              leading: Icon(Icons.event_note, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return Card(
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
              'Quick Actions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement add new class functionality
                  },
                  child: const Text('Add Class'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement add new member functionality
                  },
                  child: const Text('Add Member'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement send notification functionality
                  },
                  child: const Text('Send Notification'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
