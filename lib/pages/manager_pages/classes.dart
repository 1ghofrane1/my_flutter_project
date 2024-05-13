import 'package:flutter/material.dart';
import 'package:my_flutter_project/components/class_calendar.dart';
import 'package:my_flutter_project/components/expandable_fab.dart';
import 'package:my_flutter_project/forms/AddClassForm.dart';
import 'package:my_flutter_project/pages/manager_pages/gym_members.dart';
import 'package:table_calendar/table_calendar.dart';

class Classes extends StatefulWidget {
  const Classes({Key? key});

  @override
  State<Classes> createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ClassCalendar(),
          const SizedBox(height: 20),
          const Center(
            child: Text('Classes', style: TextStyle(color: Colors.white)),
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
