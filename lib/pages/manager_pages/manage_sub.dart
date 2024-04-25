import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_flutter_project/services/firestore.dart';

class ManageSub extends StatefulWidget {
  const ManageSub({Key? key}) : super(key: key);

  @override
  State<ManageSub> createState() => _ManageSubState();
}

class _ManageSubState extends State<ManageSub> {
  // firestore
  final FirestoreService firestoreService = FirestoreService();
  //txt controller
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  //open a dialog box to add a sub
  void openSubBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Subscriber"),
        content: Column(
          //columnBackgroundColor: const Color(0xFFBEF264),
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
            IntlPhoneField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              initialCountryCode: 'TN',
              decoration: const InputDecoration(labelText: 'Phone Number'),
              onChanged: (phone) {
                print(phone.completeNumber);
              },
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // add a new Sub
              firestoreService.addSub(
                  firstname: firstnameController.text,
                  lastname: lastnameController.text,
                  email: emailController.text,
                  phoneNumber: phoneNumberController.text);

              // clear the form fields
              firstnameController.clear();
              lastnameController.clear();
              emailController.clear();
              phoneNumberController.clear();

              //close the box
              Navigator.pop(context);
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        title: const Text("Manage Subscription"),
        // Adding a leading icon button to navigate back to MHomePage
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back to MHomePage
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openSubBox,
        child: const Icon(Icons.add),
      ),
    );
  }
}
