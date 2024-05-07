import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: Colors.green.withOpacity(0.2),
      child: const Text('Chat Widget Placeholder'),
    );
  }
}
