import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_project/components/class_calendar.dart';
import 'package:my_flutter_project/forms/addClassForm.dart';
import 'package:my_flutter_project/pages/class_detail.dart';
import 'package:my_flutter_project/pages/manager_pages/bottom_navbar.dart';
import 'package:my_flutter_project/pages/manager_pages/gym_members.dart';
import 'package:my_flutter_project/pages/manager_pages/m_home_page.dart';
import 'package:my_flutter_project/pages/manager_pages/next_class_card.dart';
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
  late Future<String> _coachNameFuture;
  final ValueNotifier<DateTime> _nextClassTimeNotifier =
      ValueNotifier(DateTime.now().add(const Duration(hours: 1)));

  @override
  void initState() {
    super.initState();
    _coachNameFuture = firestoreService.fetchCoachName();
    _updateNotVerifiedCount();
    _updateTotalSubscribersCount();
  }

  // Function to fetch count of not verified members from Firestore and update the UI
  void _updateNotVerifiedCount() async {
    int count = await firestoreService.countDocumentsInNotVerifiedCollection();
    if (count >= 0) {
      updateCount(count);
    } else {
      print('Error counting not verified documents');
    }
  }

  // Function to fetch count of total subscribers from Firestore and update the UI
  void _updateTotalSubscribersCount() async {
    int count = await firestoreService.countDocumentsInSubscribersCollection();
    if (count >= 0) {
      updateTotalSubscribersCount(count);
    } else {
      print('Error counting total subscribers');
    }
  }

  // Function to update the not verified count and refresh the UI
  void updateCount(int count) {
    setState(() {});
  }

  // Function to update the total subscribers count and refresh the UI
  void updateTotalSubscribersCount(int count) {
    setState(() {});
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
          MaterialPageRoute(builder: (context) => const GymMembers()),
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
          // Next class countdown section
          NextClassCard(
            nextClassTimeNotifier: _nextClassTimeNotifier,
            coachNameFuture: _coachNameFuture,
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

                  // Sort classes by start time
                  listClass.sort((a, b) {
                    DateTime aStartTime =
                        (a['Start Time'] as Timestamp).toDate();
                    DateTime bStartTime =
                        (b['Start Time'] as Timestamp).toDate();
                    return aStartTime.compareTo(bStartTime);
                  });

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
                      DateTime scheduledTime =
                          (data['Scheduled Time'] as Timestamp?)?.toDate() ??
                              DateTime.now();

                      Timestamp startTime =
                          data['Start Time'] ?? 'Unknown Time';
                      Timestamp endTime = data['End Time'] ?? 'Unknown Time';
                      String coachName = data['Coach'] ?? 'Unknown Coach';

                      // Convert Timestamp to DateTime
                      DateTime startDateTime = startTime.toDate();
                      DateTime endDateTime = endTime.toDate();

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
                            'Date: ${DateFormat.yMMMd().format(scheduledTime)}\nTime: ${DateFormat.Hm().format(startDateTime)} - ${DateFormat.Hm().format(endDateTime)}\nCoach: $coachName\nAvailable Spots: ${data['Capacity'] - data['enrolled_count']} / ${data['Capacity']}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(className),
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(Icons.edit)),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            tooltip: 'Delete Class',
                                            onPressed: () async {
                                              if (data['enrolled_count'] == 0) {
                                                bool confirmDelete =
                                                    await showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Confirm Delete'),
                                                      content: const Text(
                                                          'Are you sure you want to delete this Class?'),
                                                      actions: <Widget>[
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context, false);
                                                          },
                                                          child: const Text(
                                                              'Cancel'),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context, true);
                                                          },
                                                          child: const Text(
                                                              'Delete'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );

                                                if (confirmDelete != null &&
                                                    confirmDelete) {
                                                  firestoreService
                                                      .deleteClass(document.id)
                                                      .then((_) {
                                                    Navigator.pop(context);
                                                  });
                                                }
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Cannot Delete Class'),
                                                      content: const Text(
                                                        'This class cannot be deleted because there are enrolled members.',
                                                      ),
                                                      actions: <Widget>[
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              const Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Date: ${DateFormat.yMMMd().format(scheduledTime)}',
                                          style: const TextStyle(
                                              color: Colors.black87),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Time: ${DateFormat.Hm().format(startDateTime)} - ${DateFormat.Hm().format(endDateTime)}',
                                          style: const TextStyle(
                                              color: Colors.black87),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Coach: $coachName',
                                          style: const TextStyle(
                                              color: Colors.black87),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Capacity: ${data['Capacity']}',
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              },
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
