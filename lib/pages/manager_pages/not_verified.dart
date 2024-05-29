import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_project/services/firestore.dart';

class NotVerified extends StatefulWidget {
  const NotVerified({super.key});

  @override
  State<NotVerified> createState() => _NotVerifiedState();
}

class _NotVerifiedState extends State<NotVerified> {
  final FirestoreService firestoreService = FirestoreService();
  List<DocumentSnapshot> listNV = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
          title: const Text(
            'Not Verified List',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Color(0xFFBEF264),
          )),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.notVerifListStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            List<DocumentSnapshot> listNV = snapshot.data!.docs;

            return ListView.builder(
              itemCount: listNV.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = listNV[index];
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                return Card(
                  color: const Color.fromARGB(255, 39, 38, 38),
                  margin: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 8.0,
                  ),
                  child: ListTile(
                    title: Text(
                      '${data['fname']} ${data['lname']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    subtitle: Text(
                      'Email: ${data['email']}\n'
                      'Phone Number: ${data['phone_number']}\n'
                      'Role: ${data['role']}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            firestoreService.addNewUser(
                                email: data['email'],
                                fname: data['fname'],
                                lname: data['lname'],
                                phone: data['phone_number'],
                                role: data['role']);
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Color(0xFFBEF264),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Call the deleteNotVerifiedUser function with the email parameter
                            firestoreService
                                .deleteNotVerifiedUser(data['email']);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                'No not verified users available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }

  int getNotVerifiedCount() {
    return listNV.length;
  }
}
