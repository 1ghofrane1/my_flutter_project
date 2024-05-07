import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onPressed; // Callback for button press

  const SummaryCard({
    Key? key,
    required this.title,
    required this.value,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: onPressed, // Navigate to ManageSub on button press
              icon: Icon(Icons.arrow_forward), // Add your desired icon
            ),
          ],
        ),
      ),
    );
  }
}
