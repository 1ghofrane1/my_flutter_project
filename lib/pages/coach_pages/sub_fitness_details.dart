import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_project/pages/coach_pages/workout_plan_customization_screen.dart';
import 'package:my_flutter_project/services/firestore.dart';

class SubscriberDetailsScreen extends StatelessWidget {
  final String subscriberId;

  const SubscriberDetailsScreen({Key? key, required this.subscriberId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriber Details'),
        backgroundColor: const Color(0xFF171717),
      ),
      backgroundColor: const Color(0xFF171717),
      body: FutureBuilder<DocumentSnapshot>(
        future: firestoreService.subscribers.doc(subscriberId).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white)));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final subscriberData = snapshot.data?.data() as Map<String, dynamic>?;

          if (subscriberData == null) {
            return const Center(
                child: Text('No data available',
                    style: TextStyle(color: Colors.white)));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display subscriber details here as before

                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => _buildWorkoutProgramInterface(
                            context, subscriberData['fname']),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBEF264),
                    ),
                    child: const Text('Provide Workout Program'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWorkoutProgramInterface(
      BuildContext context, String subscriberName) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[850],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Customize Workout Plan for $subscriberName',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20.0),
          DataTable(
            columns: const [
              DataColumn(label: Text('Set')),
              DataColumn(label: Text('Previous')),
              DataColumn(label: Text('kg')),
              DataColumn(label: Text('reps')),
              DataColumn(label: Icon(Icons.check)),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('1')),
                DataCell(Text('')),
                DataCell(Text('')),
                DataCell(Text('')),
                DataCell(Icon(Icons.check)),
              ]),
              // Add more rows as needed
            ],
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {},
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add),
                SizedBox(width: 8.0),
                Text('Add Set'),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Add Exercises'),
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Cancel Workout'),
          ),
        ],
      ),
    );
  }
}
