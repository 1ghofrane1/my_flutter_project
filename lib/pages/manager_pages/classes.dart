import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_project/components/class_calendar.dart';
import 'package:my_flutter_project/forms/addClassForm.dart';
import 'package:my_flutter_project/pages/manager_pages/bottom_navbar.dart';
import 'package:my_flutter_project/pages/manager_pages/gym_members.dart';
import 'package:my_flutter_project/pages/manager_pages/m_home_page.dart';
import 'package:my_flutter_project/pages/manager_pages/next_class_card.dart';
import 'package:my_flutter_project/services/firestore.dart';
import 'package:intl/intl.dart';

class Classes extends StatefulWidget {
  const Classes({super.key});

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
          MaterialPageRoute(builder: (context) => const MHomePage()),
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

  Future<List<Map<String, dynamic>>> getSubscriberNames(
      String classDocID) async {
    try {
      // Reference to the "Subscribers" subcollection of the class document
      CollectionReference subscribersRef = FirebaseFirestore.instance
          .collection('Class')
          .doc(classDocID)
          .collection('Subscribers');

      // Fetch all documents in the "Subscribers" subcollection
      QuerySnapshot snapshot = await subscribersRef.get();

      // Extract and return the subscriber details
      List<Map<String, dynamic>> subscriberNames = snapshot.docs.map((doc) {
        return {
          'fname': doc['fname'] ?? '',
          'lname': doc['lname'] ?? '',
        };
      }).toList();

      return subscriberNames;
    } catch (e) {
      print('Error fetching subscriber names: $e');
      // Rethrow the error with more context
      throw Exception('Failed to fetch subscriber names');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classes',
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xFF171717),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          const ClassCalendar(),
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
                          trailing: IconButton(
                            icon: const Icon(Icons.open_in_full,
                                color: Colors.white),
                            onPressed: () {
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
                                              onPressed: () {
                                                // Add your edit logic here
                                              },
                                              icon: const Icon(Icons.edit),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              tooltip: 'Delete Class',
                                              onPressed: () async {
                                                // Delete logic
                                              },
                                            ),
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
                                          // Other content
                                          FutureBuilder<
                                              List<Map<String, dynamic>>>(
                                            future:
                                                getSubscriberNames(document.id),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const CircularProgressIndicator();
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              } else if (!snapshot.hasData ||
                                                  snapshot.data!.isEmpty) {
                                                return const Text(
                                                    'No subscribers found');
                                              } else {
                                                List<Map<String, dynamic>>
                                                    subscribers =
                                                    snapshot.data!;
                                                return Wrap(
                                                  children: subscribers
                                                      .map((subscriber) {
                                                    String fname =
                                                        subscriber['fname'] ??
                                                            'Unknown';
                                                    String lname =
                                                        subscriber['lname'] ??
                                                            'Unknown';
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8.0),
                                                      child: Text(
                                                          'Subscriber: $fname $lname'),
                                                    );
                                                  }).toList(),
                                                );
                                              }
                                            },
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
        backgroundColor: const Color(0xFFBEF264),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: MyBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
