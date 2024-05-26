import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import FirebaseFirestore for Timestamp

class ClassDetailScreen extends StatelessWidget {
  final String className;
  final DateTime classTime;
  final Timestamp startTime;
  final Timestamp endTime;
  final String coachName;
  final String description;

  const ClassDetailScreen({
    required this.className,
    required this.classTime,
    required this.startTime,
    required this.endTime,
    required this.coachName,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    // Convert Timestamp to DateTime
    DateTime startDateTime = startTime.toDate();
    DateTime endDateTime = endTime.toDate();

    return Scaffold(
      appBar: AppBar(
        title: Text(className),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${DateFormat.yMMMd().format(classTime)}'),
            // Display the formatted DateTime objects
            Text(
                'Time: ${DateFormat.Hm().format(startDateTime)} - ${DateFormat.Hm().format(endDateTime)}'),
            Text('Coach: $coachName'),
            Text('Description: $description'),
          ],
        ),
      ),
    );
  }
}
