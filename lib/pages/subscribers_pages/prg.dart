import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProgramScreen extends StatefulWidget {
  const ProgramScreen({Key? key});

  @override
  _ProgramScreenState createState() => _ProgramScreenState();
}

class _ProgramScreenState extends State<ProgramScreen> {
  String _goal = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchGoal();
  }

  Future<void> _fetchGoal() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('Subscriber')
            .doc(userId)
            .get();
        setState(() {
          _goal = snapshot['goal'];
          _loading = false;
        });
      }
    } catch (e) {
      print('Error fetching goal: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF171717),
      appBar: AppBar(
        backgroundColor: const Color(0xFF171717),
        title: Text(
          'Program Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(color: const Color(0xFFBEF264)),
            )
          : Column(
              children: [
                // First section: Goal details
                Container(
                  padding: const EdgeInsets.all(20),
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF262626),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Your Goal',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFBEF264),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _goal,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Goal Completion',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFBEF264),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                color: const Color(0xFFBEF264),
                                value: 75,
                                title: '75%',
                                radius: 60,
                                titleStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF171717),
                                ),
                              ),
                              PieChartSectionData(
                                color: const Color(0xFF262626),
                                value: 25,
                                title: '',
                                radius: 60,
                              ),
                            ],
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 0,
                            centerSpaceRadius: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Second section: Program details
                const Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Program Details',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFBEF264),
                          ),
                        ),
                        // Add program details here
                        // Example:
                        // Text('Day 1: Chest and Triceps'),
                        // Text('Day 2: Back and Biceps'),
                        // Text('Day 3: Legs and Shoulders'),
                        // ...
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
