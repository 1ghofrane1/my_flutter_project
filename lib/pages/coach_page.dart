import 'package:flutter/material.dart';

class CoachPage extends StatefulWidget {
  @override
  _CoachPageState createState() => _CoachPageState();
}

class _CoachPageState extends State<CoachPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coach Page'),
      ),
      body: Center(
        child: Text('Hello, Coach!'),
      ),
    );
  }
}
