import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_flutter_project/forms/membershipTypeForm.dart';
import 'package:my_flutter_project/forms/subForm.dart';
import 'package:my_flutter_project/pages/manager_pages/bottom_navbar.dart';
import 'package:my_flutter_project/pages/manager_pages/controllers/gym_members_controller.dart';
import 'package:my_flutter_project/pages/manager_pages/m_home_page.dart';
import 'package:my_flutter_project/services/firestore.dart';
import 'package:my_flutter_project/pages/manager_pages/classes.dart';
import 'package:my_flutter_project/components/expandable_fab.dart';
import 'package:url_launcher/url_launcher.dart';

class GymMembers extends StatefulWidget {
  const GymMembers({Key? key}) : super(key: key);

  @override
  State<GymMembers> createState() => _GymMembersState();
}

class _GymMembersState extends State<GymMembers> {
  int _selectedIndex = 1;
  final controller = Get.put(GymMemberController());
  final FirestoreService firestoreService = FirestoreService();

  String? _selectedMembership;
  late TextEditingController startDate = TextEditingController();
  late String endDate = "";
  String? membershipDuration = '';

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MHomePage()),
        );
      } else if (index == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Classes()),
        );
      }
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Icon(icon, color: Colors.black),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Membership Type',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Tooltip(
                          message: 'Add a membership type',
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const AlertDialog(
                                    title: Text(
                                      'Add Membership Type',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    content: MembershipForm(),
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.add),
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: firestoreService.membershipsListStream(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (snapshot.hasData &&
                                  snapshot.data!.docs.isNotEmpty) {
                                List<DocumentSnapshot> listMembership =
                                    snapshot.data!.docs;

                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: listMembership.map((document) {
                                      Map<String, dynamic> data = document
                                          .data() as Map<String, dynamic>;
                                      String membershipDuration =
                                          data['Membership Duration'] ?? '';

                                      return Card(
                                        color: Colors.white,
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 4.0,
                                          horizontal: 8.0,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            membershipDuration,
                                            style: const TextStyle(
                                              color: Color(0xFF171717),
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: Text(
                                    'Add your membership types here',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Total Subscribers: ",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: firestoreService.subscribersListStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      return Text(
                        "${snapshot.data!.docs.length}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      );
                    } else {
                      return const Text(
                        "0",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: firestoreService.subscribersListStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  List<DocumentSnapshot> listSub = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listSub.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = listSub[index];

                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      String firstName = data['fname'] ?? '';
                      String lastName = data['lname'] ?? '';
                      String fullName = '$firstName $lastName';
                      final String email = data['email'] ?? '';
                      final String phone = data['phone_number'] ?? '';
                      final String endDate = data['end_date'] != null
                          ? (data['end_date'] as Timestamp).toDate().toString()
                          : 'N/A';

                      return GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Subscriber Details'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    _buildDetailRow(
                                        Icons.person, 'Full Name', fullName),
                                    _buildDetailRow(
                                        Icons.email, 'Email', email),
                                    _buildDetailRow(
                                        Icons.phone, 'Phone', phone),
                                    _buildDetailRow(
                                        Icons.card_membership,
                                        'Membership',
                                        data['selected_duration'] ??
                                            'N/A'), // Display membership type
                                    _buildDetailRow(
                                        Icons.date_range,
                                        'Start Date',
                                        data['start_date'] != null
                                            ? (data['start_date'] as Timestamp)
                                                .toDate()
                                                .toString()
                                            : 'N/A'),
                                    _buildDetailRow(
                                        Icons.date_range, 'End Date', endDate),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    // Action to perform when generating invoice
                                  },
                                  child: const Text('Generate Invoice'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Edit Subscriber'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                controller:
                                                    TextEditingController(
                                                        text: firstName),
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            'First Name'),
                                              ),
                                              TextField(
                                                controller:
                                                    TextEditingController(
                                                        text: lastName),
                                                decoration:
                                                    const InputDecoration(
                                                        labelText: 'Last Name'),
                                              ),
                                              TextField(
                                                controller:
                                                    TextEditingController(
                                                        text: email),
                                                decoration:
                                                    const InputDecoration(
                                                        labelText: 'Email'),
                                              ),
                                              TextField(
                                                controller:
                                                    TextEditingController(
                                                        text: phone),
                                                decoration:
                                                    const InputDecoration(
                                                        labelText: 'Phone'),
                                              ),
                                              TextField(
                                                controller: TextEditingController(
                                                    text: data[
                                                            'selected_duration'] ??
                                                        ''),
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            'Selected Duration'),
                                              ),
                                              TextField(
                                                controller: TextEditingController(
                                                    text: data['start_date'] !=
                                                            null
                                                        ? (data['start_date']
                                                                as Timestamp)
                                                            .toDate()
                                                            .toString()
                                                        : 'N/A'),
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            'Start Date'),
                                              ),
                                              TextField(
                                                controller:
                                                    TextEditingController(
                                                        text: endDate),
                                                decoration:
                                                    const InputDecoration(
                                                        labelText: 'End Date'),
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            ElevatedButton(
                                              onPressed: () {
                                                // edit
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Save'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text('Edit'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                          },
                        ),
                        child: Card(
                          color: const Color.fromARGB(255, 39, 38, 38),
                          margin: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          child: ListTile(
                            title: Text(
                              fullName,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    final Uri _emailLaunchUri =
                                        Uri(scheme: 'mailto', path: email);
                                    if (await canLaunch(
                                        _emailLaunchUri.toString())) {
                                      await launch(_emailLaunchUri.toString());
                                    } else {
                                      throw 'Could not launch $_emailLaunchUri';
                                    }
                                  },
                                  icon: const Icon(Icons.email,
                                      color: Color(0xFFBEF264)),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final text = 'sms:$phone';
                                    if (await canLaunch(text)) {
                                      await launch(text);
                                    } else {
                                      throw 'Could not launch $text';
                                    }
                                  },
                                  icon: const Icon(Icons.message,
                                      color: Color(0xFFBEF264)),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final text = 'tel:$phone';
                                    if (await canLaunch(text)) {
                                      await launch(text);
                                    } else {
                                      throw 'Could not launch $text';
                                    }
                                  },
                                  icon: const Icon(Icons.phone,
                                      color: Color(0xFFBEF264)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text(
                      "No Subscribers Yet :/",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text('Add New Subscriber'),
                content: SubForm(),
              );
            },
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFFBEF264),
        //shape: const CircleBorder(),
      ),
      bottomNavigationBar: MyBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
