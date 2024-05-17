import 'package:flutter/material.dart';
import 'package:my_flutter_project/pages/subscribers_pages/sub_home_page.dart';

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Image.asset(
                'lib/pics/logo.png',
                height: 50,
              ),
            ),
            const Text(
              'Welcome to ATHLETIX',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Select target muscle group',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
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
                        return _showFrontSide
                            ? const Color(0xFFBEF264)
                            : Colors.white;
                      },
                    ),
                    minimumSize: MaterialStateProperty.all(const Size(140, 50)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'Front Side',
                    style: TextStyle(
                      color: _showFrontSide ? Colors.black : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showFrontSide = false;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return !_showFrontSide
                            ? const Color(0xFFBEF264)
                            : Colors.white;
                      },
                    ),
                    minimumSize: MaterialStateProperty.all(const Size(140, 50)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'Back Side',
                    style: TextStyle(
                      color: !_showFrontSide ? Colors.black : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SubHomePage()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFFBEF264)),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 15)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Finished',
                      style: TextStyle(
                        color: Color(0xFF171717),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
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
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _selectedMuscles.contains(title)
                ? const Color(0xFFBEF264)
                : const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
            width: 1,
          ),
          color: Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
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
