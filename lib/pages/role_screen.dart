import 'package:flutter/material.dart';

class PreAuthScreen extends StatefulWidget {
  const PreAuthScreen({super.key});

  @override
  _PreAuthScreenState createState() => _PreAuthScreenState();
}

class _PreAuthScreenState extends State<PreAuthScreen> {
  int? _selectedRole;
  bool _isButtonClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: Column(
        children: [
          const SizedBox(height: 100),
          Center(
            child: Image.asset('lib/pics/logo.png', height: 80),
          ),
          const SizedBox(height: 50),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Who\'s using',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'ATHLETIX',
                      style: TextStyle(
                        color: Color(0xFFBEF264),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          RadioListTile<int>(
            title: Text(
              'Admin',
              style: TextStyle(
                color: _selectedRole == 0 ? Colors.white : Colors.grey,
              ),
            ),
            value: 0,
            groupValue: _selectedRole,
            activeColor: Colors.white,
            onChanged: (int? value) {
              setState(() {
                _selectedRole = value!;
              });
            },
          ),
          RadioListTile<int>(
            title: Text(
              'Coach',
              style: TextStyle(
                color: _selectedRole == 1 ? Colors.white : Colors.grey,
              ),
            ),
            value: 1,
            groupValue: _selectedRole,
            activeColor: Colors.white,
            onChanged: (int? value) {
              setState(() {
                _selectedRole = value!;
              });
            },
          ),
          RadioListTile<int>(
            title: Text(
              'Subscriber',
              style: TextStyle(
                color: _selectedRole == 2 ? Colors.white : Colors.grey,
              ),
            ),
            value: 2,
            groupValue: _selectedRole,
            activeColor: Colors.white,
            onChanged: (int? value) {
              setState(() {
                _selectedRole = value!;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(30),
        child: ElevatedButton(
          onPressed: _selectedRole != null
              ? () {
                  setState(() {
                    _isButtonClicked = true;
                  });
                  if (_selectedRole == 0) {
                    Navigator.pushNamed(context, '/admin');
                  } else if (_selectedRole == 1) {
                    Navigator.pushNamed(context, '/coach');
                  } else if (_selectedRole == 2) {
                    Navigator.pushNamed(context, '/sub');
                  }
                }
              : () {
                  // Show error message if no radio button is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a role first'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _isButtonClicked ? const Color(0xFFBEF264) : Colors.transparent,
            side: BorderSide(
              color: _isButtonClicked ? Colors.transparent : Colors.grey,
              width: _isButtonClicked ? 0.0 : 2.0,
            ),
          ),
          child: Text(
            'Continue',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _isButtonClicked ? const Color(0xFF171717) : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
