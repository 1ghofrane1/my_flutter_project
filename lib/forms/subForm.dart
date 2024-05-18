import 'package:flutter/material.dart';
import 'package:my_flutter_project/services/firestore.dart';

class SubForm extends StatefulWidget {
  const SubForm({Key? key}) : super(key: key);

  @override
  State<SubForm> createState() => _SubFormState();
}

class _SubFormState extends State<SubForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _isSubmitting = false; // Track whether form is being submitted

  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              TextFormField(
                controller: _firstnameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9E9E9E)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0x9E9E9E9E)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0x62BEF264)),
                  ),
                  fillColor: Colors.transparent,
                  filled: true,
                  labelText: 'First Name',
                  labelStyle: TextStyle(fontSize: 14.0),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter subscriber's first name";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastnameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9E9E9E)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0x9E9E9E9E)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0x62BEF264)),
                  ),
                  fillColor: Colors.transparent,
                  filled: true,
                  labelText: 'Last Name',
                  labelStyle: TextStyle(fontSize: 14.0),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter subscriber's last name";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9E9E9E)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0x9E9E9E9E)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0x62BEF264)),
                  ),
                  fillColor: Colors.transparent,
                  filled: true,
                  labelText: 'Email',
                  labelStyle: TextStyle(fontSize: 14.0),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter subscriber's email";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9E9E9E)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0x9E9E9E9E)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0x62BEF264)),
                  ),
                  fillColor: Colors.transparent,
                  filled: true,
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(fontSize: 14.0),
                ),
                keyboardType: TextInputType.phone,
                maxLength: 8, // Set maximum length to 8 characters
                validator: (value) {
                  // Check if the phone number is empty
                  if (value == null || value.isEmpty) {
                    return "Please enter subscriber's phone number";
                  }

                  // Check if all characters are numbers
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return "Phone number should contain only numbers";
                  }

                  // Check if the first digit is 2, 3, 5, 7, or 9
                  if (!['2', '3', '5', '7', '9'].contains(value[0])) {
                    return "Invalid phone number format";
                  }

                  // If all conditions are met, return null (no error)
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _isSubmitting
                        ? null
                        : () async {
                            // Disable button if submitting
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isSubmitting =
                                    true; // Set submitting state to true
                              });
                              final firstname = _firstnameController.text;
                              final lastname = _lastnameController.text;
                              final email = _emailController.text;
                              final phoneNumber = _phoneNumberController.text;
                              try {
                                await firestoreService.addSubscriber(
                                  fname: firstname,
                                  lname: lastname,
                                  email: email,
                                  phone: phoneNumber,
                                );

                                // Clear all text controllers
                                _firstnameController.clear();
                                _lastnameController.clear();
                                _emailController.clear();
                                _phoneNumberController.clear();

                                // Close the form
                                //Navigator.pop(context);
                              } catch (e) {
                                print('Error adding subscriber: $e');
                              } finally {
                                setState(() {
                                  _isSubmitting =
                                      false; // Reset submitting state
                                });
                              }
                            }
                          },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
