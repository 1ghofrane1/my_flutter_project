import 'package:flutter/material.dart';
import 'package:my_flutter_project/pages/manager_pages/manage_sub.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Navigation Menu'),
          ),
          ListTile(
            title: const Text('Manage Subscribers'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ManageSub()),
              );
            },
          ),
          // Add more navigation items as needed
        ],
      ),
    );
  }
}
