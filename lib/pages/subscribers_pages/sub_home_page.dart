import 'package:flutter/material.dart';

class SubHomePage extends StatefulWidget {
  @override
  _SubHomePageState createState() => _SubHomePageState();
}

class _SubHomePageState extends State<SubHomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    GoalScreen(),
    ProgramScreen(),
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
            icon: Icon(Icons.flag),
            label: 'Goal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Program',
          ),
          // Add other items here
        ],
      ),
    );
  }
}

class GoalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Goal Screen',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class ProgramScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Program Screen',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
