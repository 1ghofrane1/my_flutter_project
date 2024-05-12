import 'package:flutter/material.dart';

void openSubBox({
  required BuildContext context,
  required Function(String, String, String, String) onSubmit,
  String? docID,
}) {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Add Subscriber"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: firstnameController,
            decoration: const InputDecoration(labelText: 'First Name'),
          ),
          TextField(
            controller: lastnameController,
            decoration: const InputDecoration(labelText: 'Last Name'),
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Phone Number'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            onSubmit(
              firstnameController.text,
              lastnameController.text,
              emailController.text,
              phoneNumberController.text,
            );
            firstnameController.clear();
            lastnameController.clear();
            emailController.clear();
            phoneNumberController.clear();
            Navigator.pop(context);
          },
          child: const Text('Add'),
        )
      ],
    ),
  );
}
