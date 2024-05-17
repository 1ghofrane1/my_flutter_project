import 'package:flutter/material.dart';

class TargetMuscleScreen extends StatefulWidget {
  @override
  _TargetMuscleScreenState createState() => _TargetMuscleScreenState();
}

class _TargetMuscleScreenState extends State<TargetMuscleScreen> {
  bool _showFrontSide = true;
  List<String> _selectedMuscles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Target Muscle',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Select target muscle group',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showFrontSide = true;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return _showFrontSide ? Colors.green : Colors.white;
                      },
                    ),
                  ),
                  child:
                      Text('Front Side', style: TextStyle(color: Colors.black)),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showFrontSide = false;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return !_showFrontSide ? Colors.green : Colors.white;
                      },
                    ),
                  ),
                  child:
                      Text('Back Side', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: _showFrontSide
                    ? [
                        _buildCheckBox('Shoulder'),
                        _buildCheckBox('Triceps'),
                        _buildCheckBox('Biceps'),
                        _buildCheckBox('Chest'),
                        _buildCheckBox('Neck'),
                        _buildCheckBox('Legs'),
                        _buildCheckBox('Abs'),
                      ]
                    : [
                        _buildCheckBox('Calf muscles'),
                        _buildCheckBox('Trapezius'),
                        _buildCheckBox('Deltoids'),
                        _buildCheckBox('Triceps'),
                        _buildCheckBox('Biceps'),
                        _buildCheckBox('Hips'),
                      ],
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Perform action when Finished button is pressed
                  },
                  child: Text('Finished'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckBox(String title) {
    return InkWell(
      onTap: () {
        setState(() {
          if (_selectedMuscles.contains(title)) {
            _selectedMuscles.remove(title); // Deselect the muscle
          } else {
            _selectedMuscles.add(title); // Select the muscle
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          border: Border.all(
            color: _selectedMuscles.contains(title)
                ? const Color(0xFFBEF264)
                : const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
            width: 1,
           
          ),
          color: Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: _selectedMuscles.contains(title),
              onChanged: (newValue) {
                setState(() {
                  if (newValue!) {
                    _selectedMuscles.add(title); // Select the muscle
                  } else {
                    _selectedMuscles.remove(title); // Deselect the muscle
                  }
                });
              },
              visualDensity: VisualDensity.compact,
              activeColor: const Color(0xFFBEF264),
            ),
            Text(
              title,
              style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ],
        ),
      ),
    );
  }
}
