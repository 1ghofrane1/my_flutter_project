import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_project/pages/subscribers_pages/height_weight.dart';

class GenderSelectionScreen extends StatefulWidget {
  @override
  _GenderSelectionScreenState createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String selectedGender = "";
  late DateTime _selectedDate;

  TextEditingController genderController = TextEditingController();
  late TextEditingController birthdateController;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    // Initialize birthdate controller with initial value
    birthdateController = TextEditingController.fromValue(
      TextEditingValue(
        text: _selectedDate.toString(), // Initial text value
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    genderController.dispose();
    birthdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/pics/logo.png',
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome to ATHLETIX',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Select your gender',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'To estimate your body\'s metabolic rate',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      genderRadioButton('Male'),
                      const SizedBox(width: 20),
                      genderRadioButton('Female'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Select your birthday',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'To help personalize ATHLETIX for you.',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 200,
                    child: CupertinoTheme(
                      data: const CupertinoThemeData(
                        brightness: Brightness.dark,
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextStyle(
                            fontSize: 20,
                            color: Color(0xFFBEF264),
                          ),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: _selectedDate,
                        maximumDate: DateTime.now(),
                        onDateTimeChanged: (DateTime newDate) {
                          setState(() {
                            _selectedDate = newDate;
                          });
                          birthdateController.text = newDate.toString();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: selectedGender.isNotEmpty
                          ? () async {
                              if (_formKey.currentState!.validate()) {
                                // Retrieve the current user's ID
                                String? userId =
                                    FirebaseAuth.instance.currentUser?.uid;
                                if (userId != null && userId.isNotEmpty) {
                                  try {
                                    // Update the subscriber's document with the selected gender and birthday
                                    await FirebaseFirestore.instance
                                        .collection('Subscriber')
                                        .doc(userId)
                                        .update({
                                      'gender': selectedGender,
                                      'birthday': _selectedDate,
                                    });
                                    // Navigate to the next screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            HeightWeightSelectionScreen(),
                                      ),
                                    );
                                  } catch (e) {
                                    print('Error updating document: $e');
                                  }
                                } else {
                                  print('User not logged in');
                                }
                              }
                            }
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please select your gender'),
                                ),
                              );
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
                              size: 20.0,
                              color: Color.fromARGB(197, 255, 255, 255)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget genderRadioButton(String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = value;
        });
        genderController.text = value;
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          border: Border.all(
            color: selectedGender == value
                ? const Color(0xFFBEF264)
                : const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
            width: 2,
          ),
          color: Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              activeColor: const Color(0xFFBEF264),
              value: value,
              groupValue: selectedGender,
              onChanged: (newValue) {
                setState(() {
                  selectedGender = newValue!;
                });
                genderController.text = newValue!;
              },
            ),
            Text(
              value,
              style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ],
        ),
      ),
    );
  }
}
