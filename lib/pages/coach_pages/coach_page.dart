import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_project/pages/coach_pages/coach_home.dart';
import 'package:my_flutter_project/pages/coach_pages/custom_program.dart';
import 'package:my_flutter_project/pages/coach_pages/my_classes.dart';

class CoachPage extends StatefulWidget {
  const CoachPage({super.key});

  @override
  _CoachPageState createState() => _CoachPageState();
}

class _CoachPageState extends State<CoachPage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const CustomProgram(),
    const myClasses(),
    const coachHome(),
    // Add other screens here
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),*/
      backgroundColor: const Color(0xFF171717),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF171717),
        selectedItemColor: const Color(0xFFBEF264),
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Program',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Classes',
          ),
          // Add other items here
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Program Screen',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
