import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_flutter_project/components/class_calendar.dart';
import 'package:my_flutter_project/components/expandable_fab.dart';
import 'package:my_flutter_project/forms/AddClassForm.dart';
import 'package:my_flutter_project/pages/manager_pages/gym_members.dart';

class Classes extends StatefulWidget {
  const Classes({Key? key});

  @override
  State<Classes> createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  late DateTime _nextClassTime;
  late String _coachName;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Initialize next class time and coach name (replace with your actual data)
    _nextClassTime = DateTime.now()
        .add(const Duration(hours: 1)); // Example: Next class in 1 hour
    _coachName = "John Doe"; // Example: Coach name
    // Start a timer to update the countdown every second
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {}); // Update the UI every second
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the time difference between now and the next class time
    Duration timeDifference = _nextClassTime.difference(DateTime.now());
    // Format the time remaining as hours and minutes
    String timeRemaining =
        '${timeDifference.inHours}h ${timeDifference.inMinutes.remainder(60)}m';

    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          ClassCalendar(),
          const SizedBox(height: 20),
          const Center(
            child: Text('Classes', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 20),
          // Next class countdown section
          Card(
            color: Colors.grey[800],
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next class in',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '$timeRemaining',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'with Coach $_coachName',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ExpandableFab(
        firstSecondaryIcon: Icons.event_available,
        secondSecondaryIcon: Icons.person,
        firstSecondaryOnPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  title: Text('Add Class'),
                  content: AddClassForm(),
                  actions: <Widget>[],
                );
              });
        },
        secondSecondaryOnPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GymMembers(),
            ),
          );
        },
      ),
    );
  }
}
