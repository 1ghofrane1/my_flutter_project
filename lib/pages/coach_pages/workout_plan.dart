/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_project/services/firestore.dart';

class WorkoutPlan extends StatefulWidget {
  final String? subscriberId;

  const WorkoutPlan(this.subscriberId, {Key? key}) : super(key: key);

  @override
  _WorkoutPlanState createState() => _WorkoutPlanState();
}

class _WorkoutPlanState extends State<WorkoutPlan> {
  final List<String> exerciseOptions = [
    'Push-ups',
    'Squats',
    'Lunges',
    'Plank',
    'Burpees'
  ];
  final List<String> setsOptions = ['1', '2', '3', '4', '5'];
  final List<String> repsOptions = ['5', '10', '15', '20', '25'];

  final List<Map<String, dynamic>> workoutTable = [];

  void addWorkoutRow() {
    setState(() {
      workoutTable.add({
        'exercise': exerciseOptions.first,
        'sets': setsOptions.first,
        'reps': repsOptions.first,
      });
    });
  }

  void removeWorkoutRow(int index) {
    setState(() {
      workoutTable.removeAt(index);
    });
  }

  void saveWorkoutPlan() async {
    if (workoutTable.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add at least one exercise')),
      );
      return;
    }

    try {
      await FirestoreService()
          .saveWorkoutPlan(widget.subscriberId, workoutTable);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Workout plan saved successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save workout plan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        title: const Text('Workout Plan'),
        backgroundColor: const Color(0xFF171717),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Customize Workout Plan',
                    style: TextStyle(
                        color: Color(0xFFBEF264),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const SizedBox(height: 16.0),
                  Table(
                    border: TableBorder.all(color: Colors.grey),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                      3: FixedColumnWidth(48),
                    },
                    children: [
                      const TableRow(children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Exercise',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Sets',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Reps',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox.shrink(),
                      ]),
                      for (int index = 0; index < workoutTable.length; index++)
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButton<String>(
                                value: workoutTable[index]['exercise'],
                                dropdownColor: Colors.grey[850],
                                style: const TextStyle(color: Colors.white),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    workoutTable[index]['exercise'] = newValue!;
                                  });
                                },
                                items: exerciseOptions
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButton<String>(
                                value: workoutTable[index]['sets'],
                                dropdownColor: Colors.grey[850],
                                style: const TextStyle(color: Colors.white),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    workoutTable[index]['sets'] = newValue!;
                                  });
                                },
                                items: setsOptions
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButton<String>(
                                value: workoutTable[index]['reps'],
                                dropdownColor: Colors.grey[850],
                                style: const TextStyle(color: Colors.white),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    workoutTable[index]['reps'] = newValue!;
                                  });
                                },
                                items: repsOptions
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => removeWorkoutRow(index),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: addWorkoutRow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBEF264),
                      foregroundColor: const Color(0xFF171717),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                    ),
                    child: const Text('Add Exercise'),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: saveWorkoutPlan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                    ),
                    child: const Text('Save Workout Plan'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
/*
// lib/pages/coach_pages/workout_plan.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_project/services/firestore.dart';

class WorkoutPlan extends StatelessWidget {
  final String? subscriberId;

  WorkoutPlan(this.subscriberId);

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        backgroundColor: const Color(0xFF171717),
        title: const Text('Add Workout Plan',
            style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFBEF264)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFBEF264)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Duration (in minutes)',
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFBEF264)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the duration';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Save the workout plan to Firestore
                      FirestoreService().addWorkoutPlan(
                        subscriberId,
                        _titleController.text,
                        _descriptionController.text,
                        int.parse(_durationController.text),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFFBEF264)),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Save Workout Plan',
                    style: TextStyle(
                      color: Color(0xFF171717),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:my_flutter_project/services/firestore.dart';

class WorkoutPlan extends StatefulWidget {
  final String? subscriberId;

  WorkoutPlan(this.subscriberId);

  @override
  _WorkoutPlanState createState() => _WorkoutPlanState();
}

class _WorkoutPlanState extends State<WorkoutPlan> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<WorkoutSet> _workoutSets = [];

  void _addWorkoutSet() {
    setState(() {
      _workoutSets.add(WorkoutSet());
    });
  }

  void _removeWorkoutSet(int index) {
    setState(() {
      _workoutSets.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        backgroundColor: const Color(0xFF171717),
        title: const Text('Add Workout Plan',
            style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFBEF264)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFBEF264)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Set',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Previous',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'kg',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Reps',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Color(0xFFBEF264)),
                    onPressed: _addWorkoutSet,
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _workoutSets.length,
                  itemBuilder: (context, index) {
                    return WorkoutSetRow(
                      key: UniqueKey(),
                      set: _workoutSets[index],
                      onRemove: () => _removeWorkoutSet(index),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      FirestoreService().addWorkoutPlann(
                        widget.subscriberId,
                        _titleController.text,
                        _descriptionController.text,
                        _workoutSets.map((set) => set.toMap()).toList(),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFFBEF264)),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Save Workout Plan',
                    style: TextStyle(
                      color: Color(0xFF171717),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WorkoutSet {
  final TextEditingController kgController = TextEditingController();
  final TextEditingController repsController = TextEditingController();

  Map<String, dynamic> toMap() {
    final int kg = int.tryParse(kgController.text) ?? 0;
    final int reps = int.tryParse(repsController.text) ?? 0;
    return {
      'kg': kg,
      'reps': reps,
      'previous': kg * reps,
    };
  }
}

class WorkoutSetRow extends StatelessWidget {
  final WorkoutSet set;
  final VoidCallback onRemove;

  const WorkoutSetRow({
    Key? key,
    required this.set,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Set',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Expanded(
          child: Text(
            set.toMap()['previous'].toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: set.kgController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'kg',
              labelStyle: const TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFBEF264)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter kg';
              }
              return null;
            },
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: set.repsController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Reps',
              labelStyle: const TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFBEF264)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter reps';
              }
              return null;
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: onRemove,
        ),
      ],
    );
  }
}
