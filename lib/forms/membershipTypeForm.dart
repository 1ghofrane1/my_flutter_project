import 'package:flutter/material.dart';
import 'package:my_flutter_project/services/firestore.dart';

class MembershipForm extends StatefulWidget {
  const MembershipForm({Key? key}) : super(key: key);

  @override
  State<MembershipForm> createState() => _MembershipFormState();
}

class _MembershipFormState extends State<MembershipForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _membershipNameController =
      TextEditingController();
  final TextEditingController _membershipPricingController =
      TextEditingController();
  String? _selectedDuration;
  bool _isSubmitting = false; // Track whether form is being submitted

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Membership Type',
                style: TextStyle(
                  color: Color(0xFF171717),
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _membershipNameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(fontSize: 14.0),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter membership name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              DropdownButtonFormField<String>(
                value: _selectedDuration,
                onChanged: (newValue) {
                  setState(() {
                    _selectedDuration = newValue;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Duration',
                  labelStyle: TextStyle(fontSize: 14.0),
                ),
                items: <String?>[
                  'Monthly',
                  'Quarterly',
                  'Semi-annual',
                  'Annual'
                ].map<DropdownMenuItem<String>>((String? value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value ?? ''),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select membership duration';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _membershipPricingController,
                decoration: const InputDecoration(
                  labelText: 'Pricing',
                  labelStyle: TextStyle(fontSize: 14.0),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter membership pricing';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
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

                          final membershipPricing = double.tryParse(
                                  _membershipPricingController.text) ??
                              0;
                          final membershipName = _membershipNameController.text;

                          try {
                            await _firestoreService.addMembership(
                              membershipName: membershipName,
                              selectedDuration: _selectedDuration,
                              membershipPricing: membershipPricing,
                            );

                            _membershipNameController.clear();
                            _membershipPricingController.clear();
                            setState(() {
                              _selectedDuration = null;
                            });
                          } catch (e) {
                            print('Error adding membership: $e');
                          } finally {
                            setState(() {
                              _isSubmitting = false; // Reset submitting state
                            });
                          }
                        }
                      },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
