import 'package:flutter/material.dart';
import 'package:my_flutter_project/services/firestore.dart';

class AddClassForm extends StatefulWidget {
  const AddClassForm({Key? key}) : super(key: key);

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

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        //padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _classNameController,
                decoration: InputDecoration(labelText: 'Class Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter class name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                value: _selectedCoach,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCoach = newValue;
                  });
                },
                items: <String>['Coach A', 'Coach B', 'Coach C']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Select Coach'),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a coach';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _classCapacityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Class Capacity'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter class capacity';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ListTile(
                title: Text(_selectedDate == null
                    ? 'Select Date'
                    : 'Selected Date: ${_selectedDate.toString().split(' ')[0]}'),
                onTap: () async {
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
                },
              ),
              ListTile(
                title: Text(_startTime == null
                    ? 'Select Start Time'
                    : 'Selected Start Time: ${_startTime!.hour}:${_startTime!.minute}'),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _startTime = pickedTime;
                    });
                  }
                },
              ),
              ListTile(
                title: Text(_endTime == null
                    ? 'Select End Time'
                    : 'Selected End Time: ${_endTime!.hour}:${_endTime!.minute}'),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _endTime = pickedTime;
                    });
                  }
                },
              ),
              SizedBox(height: 20.0),
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
                          if (_selectedDate != null && _startTime != null) {
                            classDateTime = DateTime(
                              _selectedDate!.year,
                              _selectedDate!.month,
                              _selectedDate!.day,
                              _startTime!.hour,
                              _startTime!.minute,
                            );
                          }
                          try {
                            /*await _firestoreService.addClass(
                              className: className,
                              coach: _selectedCoach!,
                              capacity: classCapacity,
                              dateTime: classDateTime,
                            );*/
                            _classNameController.clear();
                            _classCapacityController.clear();
                            setState(() {
                              _selectedDate = null;
                              _startTime = null;
                              _endTime = null;
                              _selectedCoach = null;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Class added successfully')),
                            );
                          } catch (e) {
                            print('Error adding class: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to add class')),
                            );
                          } finally {
                            setState(() {
                              _isSubmitting = false;
                            });
                          }
                        }
                      },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
