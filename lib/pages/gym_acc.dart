import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:my_flutter_project/components/my_button.dart';
import 'package:my_flutter_project/components/skip_button.dart';
import 'package:my_flutter_project/pages/home_page.dart';
import 'package:my_flutter_project/pages/manager_pages/m_home_page.dart';

class GymAcc extends StatefulWidget {
  const GymAcc({Key? key});

  @override
  State<GymAcc> createState() => _GymAccState();
}

class _GymAccState extends State<GymAcc> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _gymNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String gymName = _gymNameController.text;
      String address = _addressController.text;
      String phoneNumber = _phoneNumberController.text;

      // Add gym details to Firestore
      DocumentReference gymRef =
          await FirebaseFirestore.instance.collection('Gym').add({
        'gymName': gymName,
        'address': address,
        'phoneNumber': phoneNumber,
      });

      // Get the gym ID assigned by Firestore
      String gymId = gymRef.id;

      // Retrieve the manager ID associated with the current user
      String managerId = getCurrentUserId(); // Retrieve the current user's ID

      // Add gym manager and link to the gym

      addGymAndManager(gymId, managerId);

      // Navigate to the home page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MHomePage()),
      );
    }
  }

  void addGymAndManager(String gymId, String managerId) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference gymManagersRef =
        firestore.collection('Gym And Managers');
    gymManagersRef.add({
      'gymId': gymId,
      'managerId': managerId,
    });
  }

  String getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      // Handle the case where no user is signed in
      return ''; // Or you can return null if it's appropriate for your use case
    }
  }

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      border: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF9E9E9E)),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0x9E9E9E9E)),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0x62BEF264)),
      ),
      labelStyle: const TextStyle(color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Image.asset(
                    'lib/pics/logo.png',
                    height: 90,
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Let\'s create an account for your Gym!',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: _gymNameController,
                          decoration: _buildInputDecoration('Gym Name'),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _addressController,
                          decoration: _buildInputDecoration('Address'),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        IntlPhoneField(
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                          initialCountryCode: 'TN',
                          decoration: _buildInputDecoration('Phone Number'),
                          //change country code color

                          onChanged: (phone) {
                            print(phone.completeNumber);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 20),
                  MyButton(
                    onTap: _submitForm,
                    text: 'Submit',
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SkipButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
