import 'package:cloud_firestore/cloud_firestore.dart';
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
  void openSubBox({String? docID}) {
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
              if (docID == null) {
                firestoreService.addSub(
                    firstname: firstnameController.text,
                    lastname: lastnameController.text,
                    email: emailController.text,
                    phoneNumber: phoneNumberController.text);
              }
              // update an existing sub
              else {
                firestoreService.updateSub(docID, firstnameController.text);
              }
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
      //backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        title: const Text("Manage Subscriptions"),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getAllSubsStream(),
        builder: (context, snapshot) {
          // if there s data, get all subs
          if (snapshot.hasData) {
            List subsList = snapshot.data!.docs;

            // display as a List
            return ListView.builder(
              itemCount: subsList.length,
              itemBuilder: (context, index) {
                // get each individual doc
                DocumentSnapshot document = subsList[index];
                String docID = document.id;

                // get sub fron each doc
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String firstnameText = data['first name'];
                String lastnameText = data["last name"];

                // display as a list  tile
                return ListTile(
                  title: Text(firstnameText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //update button
                      IconButton(
                          onPressed: () => openSubBox(docID: docID),
                          icon: const Icon(Icons.settings)),

                      // delete button
                      IconButton(
                        onPressed: () => firestoreService.deleteSub(docID),
                        icon: const Icon(Icons.delete),
                      )
                    ],
                  ),
                );
              },
            );
          }
          // if no data return no Subs
          else {
            return Center(child: Text("No Subbscribors yet!"));
          }
        },
      ),
    );
  }
}
