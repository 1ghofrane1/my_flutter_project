import 'package:flutter/material.dart';

class SubDetailsDialog {
  static void show(BuildContext context, String fullName, String email) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Details'),
          content: SafeArea(
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    fullName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    email,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () async {
                    // Handle SMS action
                  },
                  icon: const Icon(Icons.message),
                ),
                IconButton(
                  onPressed: () async {
                    // Handle phone call action
                  },
                  icon: const Icon(Icons.phone),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'Membership Type',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
            //DropdownButtonFormField<String>(
              // Add your dropdown button widget here
            //),
            TextField(
              // Add your text field widget for start date here
            ),
            TextField(
              // Add your text field widget for end date here
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // Handle save action
                  },
                  child: const Text("Save"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
