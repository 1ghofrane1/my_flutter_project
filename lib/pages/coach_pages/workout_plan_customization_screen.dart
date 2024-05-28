import 'package:flutter/material.dart';

class WorkoutPlanCustomizationScreen extends StatefulWidget {
  final String subscriberName; // Name of the selected subscriber

  WorkoutPlanCustomizationScreen({required this.subscriberName});

  @override
  _WorkoutPlanCustomizationScreenState createState() =>
      _WorkoutPlanCustomizationScreenState();
}

class _WorkoutPlanCustomizationScreenState
    extends State<WorkoutPlanCustomizationScreen> {
  List<String> availableWorkouts = [
    'Pushups',
    'Pullups',
    'Squats',
    'Lunges',
    // Add more workouts as needed
  ];

  List<String> selectedWorkouts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customize Workout Plan for ${widget.subscriberName}'),
      ),
      body: ListView.builder(
        itemCount: availableWorkouts.length,
        itemBuilder: (context, index) {
          final workout = availableWorkouts[index];
          return CheckboxListTile(
            title: Text(workout),
            value: selectedWorkouts.contains(workout),
            onChanged: (bool? value) {
              setState(() {
                if (value != null && value) {
                  selectedWorkouts.add(workout);
                } else {
                  selectedWorkouts.remove(workout);
                }
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Save selected workouts and navigate back
          Navigator.pop(context, selectedWorkouts);
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
