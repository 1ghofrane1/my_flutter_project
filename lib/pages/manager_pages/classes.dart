import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_project/components/class_calendar.dart';
import 'package:my_flutter_project/forms/addClassForm.dart';
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
  late Future<String> _coachNameFuture;
  final ValueNotifier<DateTime> _nextClassTimeNotifier =
      ValueNotifier(DateTime.now().add(const Duration(hours: 1)));
  int _notVerifiedCount = 0;
  int _totalSubscribersCount = 0;

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
    setState(() {
      _notVerifiedCount = count;
    });
  }

  // Function to update the total subscribers count and refresh the UI
  void updateTotalSubscribersCount(int count) {
    setState(() {
      _totalSubscribersCount = count;
    });
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
                      Row(
                        children: [
                          /*const Icon(
                            Icons.access_time,
                            color: Colors.white,
                            size: 20,
                          ),*/
                          Text("Next Class in: ",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16)),
                          const SizedBox(width: 8),
                          ValueListenableBuilder(
                            valueListenable: _nextClassTimeNotifier,
                            builder: (context, value, child) {
                              return StreamBuilder<QuerySnapshot>(
                                stream: firestoreService.classesListStream(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData ||
                                      snapshot.data!.docs.isEmpty) {
                                    return const Text(
                                      'No upcoming classes',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    );
                                  }

                                  // Sort classes by start time
                                  List<DocumentSnapshot> sortedClasses =
                                      snapshot.data!.docs;
                                  sortedClasses.sort((a, b) {
                                    DateTime aStartTime =
                                        (a['Start Time'] as Timestamp).toDate();
                                    DateTime bStartTime =
                                        (b['Start Time'] as Timestamp).toDate();
                                    return aStartTime.compareTo(bStartTime);
                                  });

                                  // Find the next class
                                  DateTime now = DateTime.now();
                                  DateTime nextClassTime =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          9999999999999);
                                  for (DocumentSnapshot classDocument
                                      in sortedClasses) {
                                    DateTime startTime =
                                        (classDocument['Start Time']
                                                as Timestamp)
                                            .toDate();
                                    if (startTime.isAfter(now) &&
                                        startTime.isBefore(nextClassTime)) {
                                      nextClassTime = startTime;
                                    }
                                  }

                                  // Calculate the time difference
                                  final timeDifference =
                                      nextClassTime.difference(DateTime.now());
                                  final timeRemaining =
                                      '${timeDifference.inHours}h ${timeDifference.inMinutes.remainder(60)}m';

                                  return Text(
                                    timeRemaining,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      FutureBuilder<String>(
                        future: _coachNameFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Loading...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            );
                          } else {
                            return Text(
                              'With Coach: ${snapshot.data}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  /*const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  ),*/
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
                      DateTime scheduledTime =
                          (data['Scheduled Time'] as Timestamp?)?.toDate() ??
                              DateTime.now();

                      Timestamp startTime =
                          data['Start Time'] ?? 'Unknown Time';
                      Timestamp endTime = data['End Time'] ?? 'Unknown Time';
                      String coachName = data['Coach'] ?? 'Unknown Coach';
                      String description =
                          data['description'] ?? 'No description available';
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
                            'Date: ${DateFormat.yMMMd().format(scheduledTime)}\nTime: ${DateFormat.Hm().format(startDateTime)} - ${DateFormat.Hm().format(endDateTime)}\nCoach: $coachName',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(className),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Date: ${DateFormat.yMMMd().format(scheduledTime)}',
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Time: ${DateFormat.Hm().format(startDateTime)} - ${DateFormat.Hm().format(endDateTime)}',
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Coach: $coachName',
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Description: $description',
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Close'),
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
