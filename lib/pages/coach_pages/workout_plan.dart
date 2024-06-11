import 'package:flutter/material.dart';

class WorkoutPlan extends StatefulWidget {
  final String? subscriberId;
  final List<dynamic> selectedMuscles;

  WorkoutPlan(this.subscriberId, this.selectedMuscles);

  @override
  _WorkoutPlanState createState() => _WorkoutPlanState();
}

class _WorkoutPlanState extends State<WorkoutPlan> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<String> remainingMuscleGroups = [];
  Map<String, List<WorkoutSet>> muscleGroupWorkouts = {};
  String? _selectedMuscleGroup;

  final List<String> exercises = [
    'Squats',
    'Bench Press',
    'Deadlift',
    'Pull-Ups',
    'Bicep Curls',
    'Tricep Extensions',
    'Leg Press',
    'Shoulder Press',
    'Lunges',
    'Plank'
  ];

  @override
  void initState() {
    super.initState();
    remainingMuscleGroups = List.from(widget.selectedMuscles);
  }

  void _addWorkoutSet(String muscleGroup) {
    setState(() {
      muscleGroupWorkouts[muscleGroup]?.add(WorkoutSet());
    });
  }

  void _removeWorkoutSet(String muscleGroup, int index) {
    setState(() {
      muscleGroupWorkouts[muscleGroup]?.removeAt(index);
    });
  }

  void _addMuscleGroup() {
    if (_selectedMuscleGroup != null) {
      setState(() {
        muscleGroupWorkouts[_selectedMuscleGroup!] = [];
        remainingMuscleGroups.remove(_selectedMuscleGroup);
        _selectedMuscleGroup = null;
      });
    }
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.white70),
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
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.white70),
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
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: _selectedMuscleGroup,
                        items: remainingMuscleGroups
                            .map((muscle) => DropdownMenuItem<String>(
                                  value: muscle,
                                  child: Text(muscle,
                                      style:
                                          const TextStyle(color: Colors.black)),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedMuscleGroup = value;
                          });
                        },
                        selectedItemBuilder: (context) {
                          return remainingMuscleGroups.map((muscle) {
                            return Text(
                              muscle,
                              style: const TextStyle(color: Colors.white),
                            );
                          }).toList();
                        },
                        decoration: const InputDecoration(
                          labelText: 'Muscle Group',
                          labelStyle: TextStyle(color: Colors.white70),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFBEF264)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a muscle group';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                        width: 10), // Adjust the spacing between the elements
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color(0xFFBEF264),
                            width: 1, // Adjust the width of the border
                          ), // Colored border
                        ),
                        child: IconButton(
                          onPressed: _addMuscleGroup,
                          icon: Icon(
                            Icons.add,
                            color: const Color(0xFFBEF264), // Icon color
                          ),
                          iconSize: 28, // Icon size
                          padding: const EdgeInsets.all(
                              5), // Adjust the padding around the icon
                          splashRadius: 24, // Splash radius
                          tooltip: 'Add Muscle Group', // Tooltip
                          splashColor: Colors.transparent, // Splash color
                          highlightColor: Colors.transparent, // Highlight color
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ...muscleGroupWorkouts.entries.map((entry) {
                  String muscleGroup = entry.key;
                  List<WorkoutSet> workoutSets = entry.value;
                  return Card(
                    color: Color(0xFF2C2C2C),
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            muscleGroup,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Table(
                            columnWidths: {
                              0: const FlexColumnWidth(),
                              1: workoutSets.isEmpty
                                  ? const FlexColumnWidth()
                                  : const IntrinsicColumnWidth(),
                              2: const FlexColumnWidth(),
                              3: const FlexColumnWidth(),
                            },
                            border: TableBorder.all(color: Color(0xB3FFFFFF)),
                            children: [
                              TableRow(
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      'Set',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      'Exercise',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      'Reps',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      'kg',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add,
                                        color: Color(0xFFBEF264)),
                                    onPressed: () =>
                                        _addWorkoutSet(muscleGroup),
                                  ),
                                ],
                              ),
                              ...workoutSets.asMap().entries.map((entry) {
                                int index = entry.key;
                                WorkoutSet set = entry.value;
                                return TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    DropdownButtonFormField<String>(
                                      value: set.exercise,
                                      items: exercises
                                          .map((exercise) =>
                                              DropdownMenuItem<String>(
                                                value: exercise,
                                                child: Text(exercise),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          set.exercise = value;
                                        });
                                      },
                                      selectedItemBuilder: (context) {
                                        return exercises.map((exercise) {
                                          return Text(
                                            exercise,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          );
                                        }).toList();
                                      },
                                      decoration: const InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xB3FFFFFF)),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFBEF264)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select an exercise';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      controller: set.repsController,
                                      keyboardType: TextInputType.number,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      decoration: const InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white70),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFBEF264)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter reps';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      controller: set.kgController,
                                      keyboardType: TextInputType.number,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      decoration: const InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white70),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFBEF264)),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter kg';
                                        }
                                        return null;
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.remove,
                                          color: Colors.red),
                                      onPressed: () =>
                                          _removeWorkoutSet(muscleGroup, index),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Save logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBEF264),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
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
      ),
    );
  }
}

class WorkoutSet {
  String? exercise;
  final TextEditingController kgController = TextEditingController();
  final TextEditingController repsController = TextEditingController();

  Map<String, dynamic> toMap() {
    final int kg = int.tryParse(kgController.text) ?? 0;
    final int reps = int.tryParse(repsController.text) ?? 0;
    return {
      'exercise': exercise,
      'kg': kg,
      'reps': reps,
      'previous': kg * reps,
    };
  }
}
