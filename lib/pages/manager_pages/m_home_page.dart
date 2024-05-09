import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_flutter_project/components/summary_card.dart';
import 'package:my_flutter_project/components/analytics_chart.dart';
import 'package:my_flutter_project/components/quick_action.dart';
import 'package:my_flutter_project/components/notification_widget.dart';
import 'package:my_flutter_project/components/chat_widget.dart';
import 'package:my_flutter_project/components/class_calendar.dart'; // Import the class calendar widget
import 'package:my_flutter_project/pages/manager_pages/manage_sub.dart';
import 'package:my_flutter_project/pages/manager_pages/sub_membership.dart'; // Import the ManageSub page

class MHomePage extends StatelessWidget {
  const MHomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    // Call countSubscribers method to get the total number of subscribers
    int totalSubscribers = ManageSub.countSubscribers;

    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF171717),
        primaryColor: const Color(0xFF4CAF50), // Set primary color
        //accentColor: const Color(0xFFFFC107), // Set accent color
        textTheme: ThemeData.dark().textTheme.copyWith(
              // ignore: deprecated_member_use
              bodyText1: TextStyle(color: Colors.white), // Text color
              bodyText2: TextStyle(color: Colors.white), // Text color
              headline6: TextStyle(color: Colors.white), // Headline color
            ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          actions: [
            // Logout button
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        //drawer: NavigationDrawer(), // Add the navigation drawer
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Card for Total Subscribers
                // Summary Card for Total Subscribers
                SummaryCard(
                  title: 'Total Subscribers',
                  value: totalSubscribers.toString(),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageSub(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                // Analytics Chart
                const Text(
                  'Analytics',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const AnalyticsChart(),
                const SizedBox(height: 20.0),
                // Quick Actions
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                QuickAction(label: 'Generate Invoice', onTap: () {}),
                QuickAction(
                  label: 'Track Membership',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Membership()),
                    );
                  },
                ),

                const SizedBox(height: 20.0),
                // Notifications
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const NotificationWidget(),
                const SizedBox(height: 20.0),
                // Chat Widget
                const Text(
                  'Chat',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const ChatWidget(),
                const SizedBox(height: 20.0),
                // Class Calendar
                const Text(
                  'Class Calendar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                ClassCalendar(), // Add the class calendar widget
                const SizedBox(height: 20.0),
                // Button to go to ManageSub
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ManageSub(), // Adjusted to use const constructor
                      ),
                    );
                  },
                  child: const Text(
                      'Manage Subscriptions'), // Adjusted to use const constructor
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
