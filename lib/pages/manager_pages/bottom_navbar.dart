import 'package:flutter/material.dart';

class MyBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MyBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Gym Members',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Classes',
        ),
      ],
      currentIndex: currentIndex,
      backgroundColor: const Color(0xFF171717),
      selectedItemColor: const Color(0xFFBEF264),
      unselectedItemColor: Colors.white,
      onTap: onTap,
    );
  }
}
