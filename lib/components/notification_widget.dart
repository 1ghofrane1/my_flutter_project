import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: Colors.yellow.withOpacity(0.2),
      child: const Text('Recent Notifications'),
    );
  }
}
