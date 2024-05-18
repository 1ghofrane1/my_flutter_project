import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_flutter_project/forms/membershipTypeForm.dart';
import 'package:my_flutter_project/forms/subForm.dart';
import 'package:my_flutter_project/pages/manager_pages/controllers/gym_members_controller.dart';
import 'package:my_flutter_project/services/firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_flutter_project/pages/manager_pages/classes.dart';
import 'package:my_flutter_project/components/expandable_fab.dart';

class GymMembers extends StatefulWidget {
  const GymMembers({Key? key}) : super(key: key);

  @override
  State<GymMembers> createState() => _GymMembersState();
}

class _GymMembersState extends State<GymMembers> {
  final controller = Get.put(GymMemberController());

  final List<String> membershipNames = [];
  List<String> subList = [];
  final FirestoreService firestoreService = FirestoreService();

  String? _selectedMembership;
  late TextEditingController startDate = TextEditingController();

  late String endDate = "";
  String? membershipDuration = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Subscribers',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Expanded(
        child: SingleChildScrollView(
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
                            message: 'add a membership type',
                            child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const AlertDialog(
                                      title: const Text(
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
                                        String membershipName =
                                            data['Membership Name'];

                                        return Card(
                                          color: Colors.white,
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                            horizontal: 8.0,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              membershipName,
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
                  // if connection state is waiting, show a loading indicator
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // if data available
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    List listSub = snapshot.data!.docs;

                    // display as list
                    return ListView.builder(
                      shrinkWrap: true, // Add this line
                      itemCount: listSub.length,
                      itemBuilder: (context, index) {
                        // get each individual doc
                        DocumentSnapshot document = listSub[index];

                        //get sub from each doc
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        String firstName = data['fname'];
                        String lastName = data['lname'];
                        String fullName = '$firstName $lastName';
                        final String email = data['email'];

                        // display as list tile
                        return GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Subscriber Details'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(
                                        'Full Name: $fullName',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        'Email: $email',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        'Membership: $_selectedMembership',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        'Start Date: ${startDate.text}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        'End Date: $endDate',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
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
                                            title:
                                                const Text('Edit Subscriber'),
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
                                                          labelText:
                                                              'Last Name'),
                                                ),
                                                TextField(
                                                  controller:
                                                      TextEditingController(
                                                          text: email),
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText: 'Email'),
                                                ),
                                                // Add more fields as needed
                                              ],
                                            ),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Action to perform when saving edited details
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
                              vertical: 4.0,
                              horizontal: 8.0,
                            ),
                            child: ListTile(
                              title: Text(
                                fullName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),

                              // tO DO: UPDATE SUBSCRIBER'S INFO : optional

                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color(0xFFBEF264),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const AlertDialog(
                                        title: Text('Edit Subscriber'),
                                        content: SubForm(),
                                        actions: [], // You can add actions if needed
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    // no subscribers
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
      ),
      floatingActionButton: ExpandableFab(
        firstSecondaryIcon: Icons.event,
        secondSecondaryIcon: Icons.person_add,
        firstSecondaryOnPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Classes(),
            ),
          );
          // First secondary fab onPressed function
        },
        secondSecondaryOnPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  title: Text('Add Subscriber'),
                  content: SubForm(),
                  actions: <Widget>[],
                );
              });
          // Second secondary fab onPressed function
        },
      ),
    );
  }
}
