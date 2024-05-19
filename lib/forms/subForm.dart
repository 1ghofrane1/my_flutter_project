import 'package:flutter/material.dart';
import 'package:my_flutter_project/services/firestore.dart';
import 'package:my_flutter_project/pages/manager_pages/controllers/gym_members_controller.dart';
import 'package:get/get.dart';

class SubForm extends StatefulWidget {
  const SubForm({Key? key}) : super(key: key);

  @override
  State<SubForm> createState() => _SubFormState();
}

class _SubFormState extends State<SubForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controller = Get.put(GymMemberController());

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _isSubmitting = false; // Track whether form is being submitted
  bool _isLoading = false;
  final FirestoreService firestoreService = FirestoreService();
  String? _selectedDuration;
  List<String> _membershipDurations = [];
  late TextEditingController startDate = TextEditingController();

  late String endDate = "";

  @override
  void initState() {
    super.initState();
    _fetchMembershipDurations();
  }

  Future<void> _fetchMembershipDurations() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<String> durations =
          await firestoreService.fetchMembershipDurations();
      setState(() {
        _membershipDurations = durations;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching membership durations: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

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
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(fontSize: 14.0),
                ),
                keyboardType: TextInputType.phone,
                maxLength: 8, // Set maximum length to 8 characters
                validator: (value) {
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
              const SizedBox(height: 0.1),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                DropdownButtonFormField<String>(
                  value: _selectedDuration,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedDuration = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Membership Duration',
                    labelStyle: TextStyle(fontSize: 14.0),
                  ),
                  items: _membershipDurations
                      .map<DropdownMenuItem<String>>((String duration) {
                    return DropdownMenuItem<String>(
                      value: duration,
                      child: Text(duration),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select membership duration';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 5.0),
              TextField(
                controller: startDate,
                decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  labelText: "Start Date",
                  labelStyle: TextStyle(fontSize: 14.0),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      startDate.text = pickedDate.toString().substring(0, 10);
                      if (_selectedDuration == 'Monthly') {
                        DateTime endDateValue =
                            pickedDate.add(const Duration(days: 30));
                        setState(() {
                          endDate = endDateValue.toString();
                        });
                        controller.endDateUpdate(endDate);
                      } else if (_selectedDuration == 'Quarterly') {
                        DateTime endDateValue =
                            pickedDate.add(const Duration(days: 90));
                        endDate = endDateValue.toString();
                        setState(() {
                          endDate = endDateValue.toString();
                        });
                        controller.endDateUpdate(endDate);
                      } else if (_selectedDuration == 'Semi-annual') {
                        DateTime endDateValue =
                            pickedDate.add(const Duration(days: 180));
                        endDate = endDateValue.toString();
                        setState(() {
                          endDate = endDateValue.toString();
                        });
                        controller.endDateUpdate(endDate);
                      } else if (_selectedDuration == 'Annual') {
                        DateTime endDateValue =
                            pickedDate.add(const Duration(days: 365));
                        endDate = endDateValue.toString();
                        setState(() {
                          endDate = endDateValue.toString();
                        });
                        controller.endDateUpdate(endDate);
                      }
                    });
                  }
                },
              ),
              const SizedBox(
                height: 5,
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("End Date: ${controller.enddate}"),
                  ],
                ),
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
                                _isSubmitting = true;
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
                                  selectedDuration: _selectedDuration!,
                                  startDate: DateTime.parse(startDate.text),
                                  endDate: DateTime.parse(endDate),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Subscriber added successfully.'),
                                  ),
                                );

                                _firstnameController.clear();
                                _lastnameController.clear();
                                _emailController.clear();
                                _phoneNumberController.clear();

                                // Reset the flag to enable the submit button
                                setState(() {
                                  _isSubmitting = false;
                                });

                                // Close the form
                                Navigator.pop(context);
                              } catch (e) {
                                print('Error adding subscriber: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Failed to add subscriber. Please try again later.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );

                                // Reset the flag to enable the submit button
                                setState(() {
                                  _isSubmitting = false;
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
