import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_project/services/firestore.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class NextClassCard extends StatelessWidget {
  final ValueNotifier<DateTime> nextClassTimeNotifier;
  final Future<String> coachNameFuture;

  const NextClassCard({
    super.key,
    required this.nextClassTimeNotifier,
    required this.coachNameFuture,
  });

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Card(
      color: Colors.grey[800],
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFFBEF264), width: 2.0),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Next Class in:",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<DateTime>(
              valueListenable: nextClassTimeNotifier,
              builder: (context, value, child) {
                return StreamBuilder<QuerySnapshot>(
                  stream: firestoreService.classesListStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text(
                        'No upcoming classes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      );
                    }

                    // Sort classes by start time
                    List<DocumentSnapshot> sortedClasses = snapshot.data!.docs;
                    sortedClasses.sort((a, b) {
                      DateTime aStartTime =
                          (a['Start Time'] as Timestamp).toDate();
                      DateTime bStartTime =
                          (b['Start Time'] as Timestamp).toDate();
                      return aStartTime.compareTo(bStartTime);
                    });

                    // Find the next class
                    DateTime now = DateTime.now();
                    DateTime? nextClassTime;
                    for (DocumentSnapshot classDocument in sortedClasses) {
                      DateTime startTime =
                          (classDocument['Start Time'] as Timestamp).toDate();
                      if (startTime.isAfter(now)) {
                        nextClassTime = startTime;
                        break;
                      }
                    }

                    if (nextClassTime == null) {
                      return const Text(
                        'No upcoming classes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      );
                    }

                    // Update the next class time notifier
                    nextClassTimeNotifier.value = nextClassTime;

                    // Calculate the time difference
                    final timeDifference = nextClassTime.difference(now);

                    return TimerCountdown(
                      format: CountDownTimerFormat.hoursMinutesSeconds,
                      endTime: nextClassTime,
                      timeTextStyle: const TextStyle(
                          color: Color(0xFFBEF264),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      onEnd: () {
                        nextClassTimeNotifier.value = DateTime.now();
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 8),
            FutureBuilder<String>(
              future: coachNameFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
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
      ),
    );
  }
}
