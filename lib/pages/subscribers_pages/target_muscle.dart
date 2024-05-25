import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_project/pages/subscribers_pages/health.dart';
import 'package:my_flutter_project/pages/subscribers_pages/sub_home_page.dart';

class TargetMuscleScreen extends StatefulWidget {
  @override
  _TargetMuscleScreenState createState() => _TargetMuscleScreenState();
}

class _TargetMuscleScreenState extends State<TargetMuscleScreen> {
  bool _showFrontSide = true;
  List<String> _selectedMuscles = [];
  String _selectedGoal = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Image.asset(
                'lib/pics/logo.png',
                height: 50,
              ),
            ),
            const Text(
              'Welcome to ATHLETIX',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Select your goal',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGoalButton('Weight loss'),
                const SizedBox(width: 10),
                _buildGoalButton('Weight gain'),
                const SizedBox(width: 10),
                _buildGoalButton('Endurance improvement'),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Select target muscle group',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showFrontSide = true;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return _showFrontSide
                            ? const Color(0xFFBEF264)
                            : Colors.white;
                      },
                    ),
                    minimumSize: MaterialStateProperty.all(const Size(140, 50)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'Front Side',
                    style: TextStyle(
                      color: _showFrontSide ? Colors.black : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showFrontSide = false;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return !_showFrontSide
                            ? const Color(0xFFBEF264)
                            : Colors.white;
                      },
                    ),
                    minimumSize: MaterialStateProperty.all(const Size(140, 50)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'Back Side',
                    style: TextStyle(
                      color: !_showFrontSide ? Colors.black : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: _showFrontSide
                    ? [
                        _buildCheckBox('Shoulder'),
                        _buildCheckBox('Triceps'),
                        _buildCheckBox('Biceps'),
                        _buildCheckBox('Chest'),
                        _buildCheckBox('Neck'),
                        _buildCheckBox('Legs'),
                        _buildCheckBox('Abs'),
                      ]
                    : [
                        _buildCheckBox('Calf muscles'),
                        _buildCheckBox('Trapezius'),
                        _buildCheckBox('Deltoids'),
                        _buildCheckBox('Triceps'),
                        _buildCheckBox('Biceps'),
                        _buildCheckBox('Hips'),
                      ],
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_selectedGoal.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a goal.'),
                          ),
                        );
                        return;
                      }
                      if (_selectedMuscles.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Please select at least one muscle group.'),
                          ),
                        );
                        return;
                      }

                      // Retrieve the current user's ID
                      String? userId = FirebaseAuth.instance.currentUser?.uid;
                      if (userId != null && userId.isNotEmpty) {
                        try {
                          // Update the subscriber's document with selected muscles and goal
                          await FirebaseFirestore.instance
                              .collection('Subscriber')
                              .doc(userId)
                              .update({
                            'selectedMuscles': _selectedMuscles,
                            'goal': _selectedGoal,
                          });
                          // Navigate to the SubHomePage
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HealthDetailsScreen()),
                          );
                        } catch (e) {
                          print('Error updating document: $e');
                        }
                      } else {
                        print('User not logged in');
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFFBEF264)),
                      minimumSize:
                          MaterialStateProperty.all(const Size(50, 50)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue',
                          style: TextStyle(
                            color: Color(0xFF171717),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward_ios,
                            color: Color.fromARGB(197, 255, 255, 255)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckBox(String title) {
    return InkWell(
      onTap: () {
        setState(() {
          if (_selectedMuscles.contains(title)) {
            _selectedMuscles.remove(title); // Deselect the muscle
          } else {
            _selectedMuscles.add(title); // Select the muscle
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _selectedMuscles.contains(title)
                ? const Color(0xFFBEF264)
                : const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
            width: 1,
          ),
          color: Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: _selectedMuscles.contains(title),
              onChanged: (newValue) {
                setState(() {
                  if (newValue!) {
                    _selectedMuscles.add(title); // Select the muscle
                  } else {
                    _selectedMuscles.remove(title); // Deselect the muscle
                  }
                });
              },
              visualDensity: VisualDensity.compact,
              activeColor: const Color(0xFFBEF264),
            ),
            Text(
              title,
              style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalButton(String title) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedGoal = title;
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            return _selectedGoal == title
                ? const Color(0xFFBEF264)
                : Colors.white;
          },
        ),
        minimumSize: MaterialStateProperty.all(const Size(140, 50)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: _selectedGoal == title ? Colors.black : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
