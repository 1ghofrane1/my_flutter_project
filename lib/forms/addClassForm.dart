import 'package:flutter/material.dart';
import 'package:my_flutter_project/services/firestore_service.dart';
import 'package:intl/intl.dart';

class AddClassForm extends StatefulWidget {
  const AddClassForm({super.key});

  @override
  _AddClassFormState createState() => _AddClassFormState();
}

class _AddClassFormState extends State<AddClassForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _classCapacityController =
      TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _selectedCoach;
  bool _isSubmitting = false;
  List<Map<String, dynamic>> _coaches = [];

  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _fetchCoaches();
  }

  Future<void> _fetchCoaches() async {
    try {
      List<Map<String, dynamic>> coaches =
          await _firestoreService.fetchCoaches();
      setState(() {
        _coaches = coaches;
      });
    } catch (e) {
      print('Error fetching coaches: $e');
    }
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = pickedTime;
        } else {
          _endTime = pickedTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _classNameController,
                  decoration: const InputDecoration(
                    labelText: 'Class Name',
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter class name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15.0),
                DropdownButtonFormField<String>(
                  value: _selectedCoach,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCoach = newValue;
                    });
                  },
                  items: _coaches.map<DropdownMenuItem<String>>((coach) {
                    return DropdownMenuItem<String>(
                      value: coach['fullname'],
                      child: Text(coach['fullname']),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Select Coach',
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a coach';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15.0),
                TextFormField(
                  controller: _classCapacityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Class Capacity',
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter class capacity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15.0),
                ListTile(
                  title: Text(
                    _selectedDate == null
                        ? 'Select Date'
                        : 'Selected Date: ${DateFormat.yMMMd().format(_selectedDate!)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  shape: const UnderlineInputBorder(),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: _selectDate,
                ),
                const SizedBox(height: 15.0),
                ListTile(
                  title: Text(
                    _startTime == null
                        ? 'Select Start Time'
                        : 'Selected Start Time: ${_startTime!.format(context)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  shape: const UnderlineInputBorder(),
                  trailing: const Icon(Icons.access_time),
                  onTap: () => _selectTime(isStartTime: true),
                ),
                const SizedBox(height: 15.0),
                ListTile(
                  title: Text(
                    _endTime == null
                        ? 'Select End Time'
                        : 'Selected End Time: ${_endTime!.format(context)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  shape: const UnderlineInputBorder(),
                  trailing: const Icon(Icons.access_time),
                  onTap: () => _selectTime(isStartTime: false),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isSubmitting = true;
                            });
                            final className = _classNameController.text;
                            final classCapacity =
                                int.parse(_classCapacityController.text);
                            DateTime? classDateTime;
                            DateTime? endTime;
                            DateTime? startTime;
                            if (_selectedDate != null) {
                              classDateTime = DateTime(
                                _selectedDate!.year,
                                _selectedDate!.month,
                                _selectedDate!.day,
                              );
                              if (_startTime != null) {
                                startTime = DateTime(
                                  _selectedDate!.year,
                                  _selectedDate!.month,
                                  _selectedDate!.day,
                                  _startTime!.hour,
                                  _startTime!.minute,
                                );
                              }
                              if (_endTime != null) {
                                endTime = DateTime(
                                  _selectedDate!.year,
                                  _selectedDate!.month,
                                  _selectedDate!.day,
                                  _endTime!.hour,
                                  _endTime!.minute,
                                );
                              }
                            }
                            try {
                              await _firestoreService.addClass(
                                className: className,
                                coach: _selectedCoach!,
                                capacity: classCapacity,
                                scheduledDate: classDateTime,
                                startTime: startTime,
                                endTime: endTime,
                              );
                              _classNameController.clear();
                              _classCapacityController.clear();
                              setState(() {
                                _selectedDate = null;
                                _startTime = null;
                                _endTime = null;
                                _selectedCoach = null;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Class added successfully'),
                                ),
                              );
                            } catch (e) {
                              print('Error adding class: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Failed to add class')),
                              );
                            } finally {
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
          ),
        ),
      ),
    );
  }
}
