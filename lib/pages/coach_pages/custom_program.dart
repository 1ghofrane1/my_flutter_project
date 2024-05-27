import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_project/services/firestore.dart';

class CustomProgram extends StatefulWidget {
  const CustomProgram({super.key});

  @override
  _CustomProgramState createState() => _CustomProgramState();
}

class _CustomProgramState extends State<CustomProgram> {
  final FirestoreService _firestoreService = FirestoreService();
  String? selectedSubscriberId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.subscribersListStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final subscribers = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: subscribers.length,
            itemBuilder: (context, index) {
              final subscriber = subscribers[index];
              final subscriberData = subscriber.data() as Map<String, dynamic>;
              final isSelected = selectedSubscriberId == subscriber.id;

              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFBEF264)
                        : Colors.transparent,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Card(
                  color: Colors.grey[850],
                  child: ListTile(
                    title: Text(
                      '${subscriberData['fname']} ${subscriberData['lname']}',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(subscriberData['email'],
                        style: TextStyle(color: Colors.white70)),
                    onTap: () {
                      setState(() {
                        selectedSubscriberId = subscriber.id;
                      });
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      /*floatingActionButton: selectedSubscriberId != null
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubscriberDetailsScreen(
                      subscriberId: selectedSubscriberId!,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.fitness_center),
            )
          : null,*/
    );
  }
}

class SubscriberDetailsScreen extends StatelessWidget {
  final String subscriberId;

  const SubscriberDetailsScreen({super.key, required this.subscriberId});

  @override
  Widget build(BuildContext context) {
    final FirestoreService _firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriber Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestoreService.subscribers.doc(subscriberId).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final subscriberData = snapshot.data?.data() as Map<String, dynamic>?;

          if (subscriberData == null) {
            return const Center(child: Text('No data available'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Name: ${subscriberData['fname']} ${subscriberData['lname']}'),
                Text('Email: ${subscriberData['email']}'),
                Text('Phone: ${subscriberData['phone_number']}'),
                Text('Weight: ${subscriberData['weight']}'),
                Text('Height: ${subscriberData['height']}'),
                Text('Gender: ${subscriberData['gender']}'),
                Text(
                    'Selected Muscles: ${subscriberData['selectedMuscles'].join(', ')}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Add logic to provide a workout program
                  },
                  child: const Text('Provide Workout Program'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
