import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_flutter_project/services/firestore.dart';

class ManageSub extends StatefulWidget {
  // Define countSubscribers as a public variable
  static int countSubscribers = 0;

  const ManageSub({Key? key}) : super(key: key);

  @override
  State<ManageSub> createState() => _ManageSubState();
}

class _ManageSubState extends State<ManageSub> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  List<DocumentSnapshot> subsList = [];

  @override
  void initState() {
    super.initState();
    // Fetch the list of subscribers when the widget initializes
    fetchSubsList();
  }

  // Method to fetch the list of subscribers
  void fetchSubsList() async {
    QuerySnapshot snapshot = await firestoreService.getAllSubsStream().first;
    setState(() {
      subsList = snapshot.docs;
      // Update countSubscribers when subsList changes
      ManageSub.countSubscribers = subsList.length;
    });
  }

  void openSubBox({String? docID}) {
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
            IntlPhoneField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.black),
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
              if (docID == null) {
                firestoreService.addSub(
                  firstname: firstnameController.text,
                  lastname: lastnameController.text,
                  email: emailController.text,
                  phoneNumber: phoneNumberController.text,
                );
              } else {
                firestoreService.updateSub(docID, firstnameController.text);
              }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Subscriptions"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openSubBox,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total Subscribers: ${ManageSub.countSubscribers}',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: subsList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = subsList[index];
                String docID = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String firstNameText = data['first name'];
                String lastNameText = data["last name"];

                // Update the line where you retrieve the subscription status
                bool subscriptionStatus = data['subscription_status'] ?? false;

                return Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      '$firstNameText $lastNameText',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      subscriptionStatus ? 'Active' : 'Inactive',
                      style: TextStyle(
                        color: subscriptionStatus ? Colors.green : Colors.red,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              onPressed: () => openSubBox(docID: docID),
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () =>
                                  firestoreService.deleteSub(docID),
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                            ),
                          ],
                        ),
                        const VerticalDivider(thickness: 1, width: 1),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () async {
                                final text = 'sms:${data['phone_number']}';
                                if (await canLaunch(text)) {
                                  await launch(text);
                                } else {
                                  throw 'Could not launch $text';
                                }
                              },
                              icon: const Icon(Icons.message),
                            ),
                            IconButton(
                              onPressed: () async {
                                final text = 'tel:${data['phone_number']}';
                                if (await canLaunch(text)) {
                                  await launch(text);
                                } else {
                                  throw 'Could not launch $text';
                                }
                              },
                              icon: const Icon(Icons.phone),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
