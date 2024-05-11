import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_project/forms/membershipTypeForm.dart';
import 'package:my_flutter_project/services/firestore.dart';

class GymMembers extends StatefulWidget {
  const GymMembers({super.key});

  @override
  State<GymMembers> createState() => _GymMembersState();
}

class _GymMembersState extends State<GymMembers> {
  String? gymId;
  final List<String> membershipNames = [];
  List<String> subList = [];
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _fetchGymId();
    _fetchMembershipNames();
    //_getSub();
  }

  void _fetchGymId() async {
    gymId = await _getGymId();

    print('Gym ID: ${gymId.runtimeType}');
    _fetchMembershipNames(); // Call _fetchMembershipNames after updating gymId
    //_getSub();
    setState(() {});
  }

  Future<String?> _getGymId() async {
    return (await _firestoreService.getCurrentGymId())?.trim();
  }

  Future<void> _fetchMembershipNames() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Membership').get();

    for (final membership in snapshot.docs) {
      final String membershipGymId = membership['gym id'].trim();
      print('Membership Gym ID type: ${membershipGymId.runtimeType}');

      if (membershipGymId == gymId) {
        final membershipName = membership['Membership Name'];
        setState(() {
          membershipNames.add(membershipName);
          print('true');
        });
      } else {
        print('maha2ah');
      }

      print(
          'membershipGymId: $membershipGymId, gymId: $gymId'); // Add this line
    }
  }

  Future<void> _getSub() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Subscriber').get();

    setState(() {
      subList.clear(); // Clear the list before updating with new data
    });

    for (final sub in snapshot.docs) {
      final String subGymId = sub['gym id'].trim();
      print('Subscription Gym ID type: ${subGymId.runtimeType}');

      if (subGymId == gymId) {
        final String id = sub.id;
        final String firstName = sub['fname'];
        final String lastName = sub['lname'];
        final String fullName = '$firstName $lastName';
        setState(() {
          subList.add(fullName);
          print('trueeeeeeeeeeeeeeee');
        });
      } else {
        print('maha2ah subbbb');
      }
    }
  }

  Stream<QuerySnapshot> subscribersListStream(String gymId) {
    final CollectionReference subRef =
        FirebaseFirestore.instance.collection('Subscriber');

    // Query for documents
    Stream<QuerySnapshot> subStream =
        subRef.where('gym id', isEqualTo: gymId).snapshots();

    return subStream;
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
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  content: MembershipForm(),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.add),
                          color: Colors.white,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 100,
                            child: membershipNames.isEmpty
                                ? const SizedBox
                                    .shrink() // If membershipNames is empty, don't show anything
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: membershipNames.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Chip(
                                          label: Text(membershipNames[index]),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const Positioned(
                      top: 0,
                      child: Text(
                        'Membership Type',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
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
                    stream: subscribersListStream(gymId!),
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
                stream: subscribersListStream(gymId!),
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

                        // display as list tile
                        return Card(
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
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.visibility,
                                color: Color(0xFFBEF264),
                              ),
                              onPressed: () {
                                // Handle view functionality
                              },
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
    );
  }
}
