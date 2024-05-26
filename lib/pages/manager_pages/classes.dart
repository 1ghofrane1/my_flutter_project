import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_project/components/class_calendar.dart';
import 'package:my_flutter_project/forms/addClassForm.dart';
import 'package:my_flutter_project/forms/subForm.dart';
import 'package:my_flutter_project/pages/class_detail.dart';
import 'package:my_flutter_project/pages/manager_pages/bottom_navbar.dart';
import 'package:my_flutter_project/pages/manager_pages/gym_members.dart';
import 'package:my_flutter_project/pages/manager_pages/m_home_page.dart';
import 'package:my_flutter_project/services/firestore.dart';
import 'package:intl/intl.dart';

class Classes extends StatefulWidget {
  const Classes({Key? key}) : super(key: key);

  @override
  _ClassesState createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  int _selectedIndex = 2;
  final FirestoreService firestoreService = FirestoreService();
  DateTime _nextClassTime = DateTime.now().add(const Duration(hours: 1));
  String _coachName = "John Doe";
  final ValueNotifier<DateTime> _nextClassTimeNotifier =
      ValueNotifier(DateTime.now().add(const Duration(hours: 1)));

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MHomePage()),
        );
      } else if (index == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GymMembers()),
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
                  List<DocumentSnapshot> listClass = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: listClass.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = listClass[index];
                      Map<String, dynamic>? data =
                          document.data() as Map<String, dynamic>?;

                      if (data == null) {
                        return const SizedBox.shrink();
                      }

                      String className = data['Class Name'] ?? 'Unknown Class';
                      DateTime classTime =
                          (data['Scheduled Time'] as Timestamp?)?.toDate() ??
                              DateTime.now();
                      String coachName = data['Coach'] ?? 'Unknown Coach';
                      String description =
                          data['description'] ?? 'No description available';

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
                          subtitle: Text(
                            'Time: ${DateFormat.yMMMd().add_jm().format(classTime)}\nCoach: $coachName',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClassDetailScreen(
                                  className: className,
                                  classTime: classTime,
                                  coachName: coachName,
                                  description: description,
                                ),
                              ),
                            );
                          },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text('Add New Class'),
                content: AddClassForm(),
              );
            },
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFFBEF264),
        //shape: const CircleBorder(),
      ),
      bottomNavigationBar: MyBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
