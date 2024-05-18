import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_project/components/class_calendar.dart';
import 'package:my_flutter_project/components/expandable_fab.dart';
import 'package:my_flutter_project/forms/AddClassForm.dart';
import 'package:my_flutter_project/pages/manager_pages/gym_members.dart';
import 'package:my_flutter_project/services/firestore.dart';
import 'package:intl/intl.dart';

class Classes extends StatefulWidget {
  const Classes({Key? key}) : super(key: key);

  @override
  _ClassesState createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  final FirestoreService firestoreService = FirestoreService();
  DateTime _nextClassTime = DateTime.now().add(const Duration(hours: 1));
  String _coachName = "John Doe";
  final ValueNotifier<DateTime> _nextClassTimeNotifier =
      ValueNotifier(DateTime.now().add(const Duration(hours: 1)));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            margin: const EdgeInsets.symmetric(horizontal: 20),
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
                      const Text(
                        'Next class in',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: _nextClassTimeNotifier,
                        builder: (context, value, child) {
                          final timeDifference =
                              value.difference(DateTime.now());
                          final timeRemaining =
                              '${timeDifference.inHours}h ${timeDifference.inMinutes.remainder(60)}m';
                          return Text(
                            timeRemaining,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Text(
                    'with Coach $_coachName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestoreService.classesListStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  print(
                      "HEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEREEEEEEEEEEEEEEEEEEEEEEEEEEE");
                  List<DocumentSnapshot> listClass = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: listClass.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = listClass[index];
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      String className = data['Class Name'];
                      /*DateTime classTime = data['class_time'].toDate();
                      String coachName = data['coach_name'];*/

                      return Card(
                        color: const Color.fromARGB(255, 39, 38, 38),
                        margin: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 8.0,
                        ),
                        child: ListTile(
                          title: Text(
                            className,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          /*subtitle: Text(
                              'Time: ${DateFormat.yMMMd().add_jm().format(classTime)}\nCoach: $coachName'),*/
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text(
                      'No classes available',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
              },
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
