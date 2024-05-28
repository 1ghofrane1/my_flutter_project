import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:my_flutter_project/services/firestore.dart';

class ClassScreen extends StatefulWidget {
  const ClassScreen({Key? key}) : super(key: key);

  @override
  _ClassScreenState createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  final FirestoreService firestoreService = FirestoreService();
  List<DocumentSnapshot> myClasses = [];
  List<DocumentSnapshot> availableClasses = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Available Classes',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
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
                        List<DocumentSnapshot> allClasses = snapshot.data!.docs;

                        // Filter and sort classes by start time
                        DateTime now = DateTime.now();
                        availableClasses = allClasses.where((doc) {
                          DateTime startTime =
                              (doc['Start Time'] as Timestamp).toDate();
                          return startTime.isAfter(now) &&
                              !myClasses.contains(doc);
                        }).toList();

                        availableClasses.sort((a, b) {
                          DateTime aStartTime =
                              (a['Start Time'] as Timestamp).toDate();
                          DateTime bStartTime =
                              (b['Start Time'] as Timestamp).toDate();
                          return aStartTime.compareTo(bStartTime);
                        });

                        if (availableClasses.isEmpty) {
                          return const Center(
                            child: Text(
                              'No classes available',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: availableClasses.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot doc =
                                availableClasses[index]; // Define doc here
                            DocumentSnapshot document = availableClasses[index];
                            Map<String, dynamic>? data =
                                doc.data() as Map<String, dynamic>?;

                            if (data == null) {
                              return const SizedBox.shrink();
                            }

                            String className =
                                data['Class Name'] ?? 'Unknown Class';
                            DateTime scheduledTime =
                                (data['Scheduled Time'] as Timestamp?)
                                        ?.toDate() ??
                                    DateTime.now();
                            DateTime startDateTime =
                                (data['Start Time'] as Timestamp?)?.toDate() ??
                                    DateTime.now();
                            DateTime endDateTime =
                                (data['End Time'] as Timestamp?)?.toDate() ??
                                    DateTime.now();
                            String coachName = data['Coach'] ?? 'Unknown Coach';

                            int capacity = data['Capacity'] ?? 0;
                            //int availableSpots = data['available_spots'] ?? 0;
                            int enrolledCount = data['enrolled_count'] ?? 0;

                            return Card(
                              color: const Color.fromARGB(255, 39, 38, 38),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 8.0),
                              child: ListTile(
                                title: Text(
                                  className,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                                subtitle: Text(
                                  'Date: ${DateFormat.yMMMd().format(scheduledTime)}\nTime: ${DateFormat.Hm().format(startDateTime)} - ${DateFormat.Hm().format(endDateTime)}\nCoach: $coachName\nAvailable spots:  ${capacity - enrolledCount} / $capacity',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                // Inside the ListView.builder for available classes
                                trailing: FutureBuilder<bool>(
                                  future:
                                      firestoreService.isClassEnrolled(doc.id),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator(); // Show loading indicator while checking
                                    }

                                    if (snapshot.hasData &&
                                        snapshot.data == true) {
                                      // Class is already enrolled, disable add icon button
                                      return const IconButton(
                                        icon: Icon(Icons.add,
                                            color:
                                                Colors.grey), // Disabled color
                                        onPressed: null, // Disable onPressed
                                      );
                                    } else {
                                      // Class is not enrolled, enable add icon button
                                      return IconButton(
                                        icon: const Icon(Icons.add,
                                            color: Colors.green),
                                        onPressed: () {
                                          // Add logic to add the class to "My Classes" section
                                          String docID = doc.id;
                                          firestoreService.addToEnrolledClasses(
                                              docID, data);
                                        },
                                      );
                                    }
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
          ),
          const Divider(
            color: Color.fromARGB(62, 255, 255, 255),
            thickness: 1,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'My Classes',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Subscriber')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('EnrolledClasses')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        List<DocumentSnapshot> enrolledClasses =
                            snapshot.data!.docs;

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: enrolledClasses.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot document = enrolledClasses[index];
                            Map<String, dynamic>? data =
                                document.data() as Map<String, dynamic>?;

                            if (data == null) {
                              return const SizedBox.shrink();
                            }

                            // Fetch class details asynchronously
                            return FutureBuilder<Map<String, dynamic>?>(
                              future: firestoreService
                                  .getEnrolledClassDetails(document.id),
                              builder: (context, classDetailsSnapshot) {
                                if (classDetailsSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // While fetching class details, show a loading indicator
                                  return const CircularProgressIndicator();
                                }

                                if (classDetailsSnapshot.hasData) {
                                  Map<String, dynamic>? classDetails =
                                      classDetailsSnapshot.data;

                                  if (classDetails != null) {
                                    String className =
                                        classDetails['Class Name'] ??
                                            'Unknown Class';
                                    DateTime scheduledTime =
                                        (classDetails['Scheduled Time']
                                                    as Timestamp?)
                                                ?.toDate() ??
                                            DateTime.now();
                                    DateTime startDateTime =
                                        (classDetails['Start Time']
                                                    as Timestamp?)
                                                ?.toDate() ??
                                            DateTime.now();
                                    DateTime endDateTime =
                                        (classDetails['End Time'] as Timestamp?)
                                                ?.toDate() ??
                                            DateTime.now();
                                    String coachName = classDetails['Coach'] ??
                                        'Unknown Coach';

                                    return Card(
                                      color:
                                          const Color.fromARGB(255, 39, 38, 38),
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
                                          style: const TextStyle(
                                              color: Colors.white70),
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.remove,
                                              color: Colors.red),
                                          onPressed: () {
                                            // Get the document ID of the selected class
                                            String docID = document.id;
                                            // Remove the class from user's enrolled classes
                                            firestoreService
                                                .removeFromEnrolledClasses(
                                                    docID);
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                }

                                // If class details couldn't be fetched, show a message
                                return const Text(
                                    'Failed to fetch class details');
                              },
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
          ),
        ],
      ),
    );
  }
}
