import 'package:flutter/material.dart';
import 'package:my_flutter_project/pages/subscribers_pages/birthday.dart';

class GenderSelectionScreen extends StatefulWidget {
  @override
  _GenderSelectionScreenState createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  String selectedGender = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  genderRadioButton('Male'),
                  const SizedBox(height: 20),
                  genderRadioButton('Female'),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: selectedGender.isNotEmpty
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Birthday(),
                            ),
                          );
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
                    minimumSize: MaterialStateProperty.all(const Size(50, 50)),
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
              // Additional content can be added here
            ],
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
