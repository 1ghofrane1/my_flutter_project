import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_flutter_project/components/my_button.dart';
import 'package:my_flutter_project/components/my_textfield.dart';
import 'package:my_flutter_project/pages/home_page.dart';

class GymAcc extends StatefulWidget {
  const GymAcc({super.key});

  @override
  State<GymAcc> createState() => _GymAccState();
}

class _GymAccState extends State<GymAcc> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _gymNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF171717),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  // Logo
                  Image.asset(
                    'lib/pics/logo.png',
                    height: 90,
                  ),
                  SizedBox(height: 50),
                  // Title
                  Text(
                    'Let\'s create an account for your Gym!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Gym Name
                  MyTextFlield(
                    controller: _gymNameController,
                    hintText: 'Gym Name',
                    obscureText: false,
                  ),
                  SizedBox(height: 10),
                  // Address
                  MyTextFlield(
                    controller: _addressController,
                    hintText: 'Address',
                    obscureText: false,
                  ),
                  SizedBox(height: 10),
                  // Contact Information
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IntlPhoneField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (phone) {
                        print(phone.completeNumber);
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  // Submit Button
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, proceed with account creation
                        // You can access the form field values using the controllers
                        // For example: _gymNameController.text, _addressController.text, _phoneNumberController.text, etc.
                      }
                    },
                    child: Text('Create Account'),
                  ),
                  MyButton(
                      text: 'skip',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
