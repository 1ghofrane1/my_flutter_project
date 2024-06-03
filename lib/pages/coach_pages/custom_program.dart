// lib/pages/coach_pages/custom_program.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_project/pages/coach_pages/workout_plan.dart';
import 'package:my_flutter_project/services/firestore.dart';

class CustomProgram extends StatefulWidget {
  const CustomProgram({Key? key}) : super(key: key);

  @override
  _CustomProgramState createState() => _CustomProgramState();
}

class _CustomProgramState extends State<CustomProgram> {
  final FirestoreService _firestoreService = FirestoreService();
  String? selectedSubscriberId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscribers', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF171717),
      ),
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
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Card(
                  color: Colors.grey[850],
                  child: ExpansionTile(
                    key: PageStorageKey(subscriber.id),
                    title: Text(
                      '${subscriberData['fname']} ${subscriberData['lname']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Goal: ${subscriberData['goal']}',
                      style: const TextStyle(color: Color(0xFFBEF264)),
                    ),
                    trailing: Icon(
                      isSelected ? Icons.expand_less : Icons.expand_more,
                      color: Colors.white,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: const Text('Gender',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(subscriberData['gender'],
                                  style:
                                      const TextStyle(color: Colors.white70)),
                            ),
                            ListTile(
                              title: const Text('Weight',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  '${subscriberData['weight'].toString()} kg',
                                  style:
                                      const TextStyle(color: Colors.white70)),
                            ),
                            ListTile(
                              title: const Text('Height',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  '${subscriberData['height'].toString()} cm',
                                  style:
                                      const TextStyle(color: Colors.white70)),
                            ),
                            const Text(
                              'Selected Muscles',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: (subscriberData['selectedMuscles']
                                      as List<dynamic>)
                                  .map((muscle) => Chip(
                                        label: Text(muscle),
                                        backgroundColor:
                                            const Color(0xFFBEF264),
                                        labelStyle: const TextStyle(
                                            color: Color(0xFF171717)),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) =>
                                          DraggableScrollableSheet(
                                        initialChildSize: 0.8,
                                        maxChildSize: 0.9,
                                        minChildSize: 0.5,
                                        builder: (context, scrollController) {
                                          return Container(
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF171717),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                            ),
                                            child: WorkoutPlan(
                                                selectedSubscriberId),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xFFBEF264)),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 20)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add,
                                          color: Color(0xFF171717)), // Add icon
                                      SizedBox(width: 6),
                                      Text(
                                        'Add plan',
                                        style: TextStyle(
                                          color: Color(0xFF171717),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    onExpansionChanged: (bool expanded) {
                      setState(() {
                        selectedSubscriberId = expanded ? subscriber.id : null;
                      });
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
