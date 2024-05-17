import 'package:flutter/material.dart';
import 'package:my_flutter_project/pages/subscribers_pages/target_muscle.dart';

class HeightWeightSelectionScreen extends StatefulWidget {
  @override
  _HeightWeightSelectionScreenState createState() =>
      _HeightWeightSelectionScreenState();
}

class _HeightWeightSelectionScreenState
    extends State<HeightWeightSelectionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
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
                  'Enter your height and weight',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _heightController,
                        label: 'Height (cm)',
                        icon: Icons.height,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _weightController,
                        label: 'Weight (kg)',
                        icon: Icons.monitor_weight,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Proceed to the next screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TargetMuscleScreen(),
                          ),
                        );
                      }
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      required IconData icon}) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: Icon(icon, color: const Color(0xFFBEF264)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFBEF264), width: 1.5),
          borderRadius: BorderRadius.circular(35),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFBEF264), width: 2.0),
          borderRadius: BorderRadius.circular(35),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
          borderRadius: BorderRadius.circular(35),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
          borderRadius: BorderRadius.circular(35),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }
}
