import 'package:cloud_firestore/cloud_firestore.dart';
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
    _getSub();
  }

  void _fetchGymId() async {
    gymId = await _getGymId();

    print('Gym ID: ${gymId.runtimeType}');
    _fetchMembershipNames(); // Call _fetchMembershipNames after updating gymId
    _getSub();
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
    Stream<QuerySnapshot> subStream = subRef
        .where('gym_id', isEqualTo: gymId)
        .orderBy('timestamp', descending: true)
        .snapshots();

    return subStream;
  }

  /*Stream<QuerySnapshot> subscribersListStream() {
    final CollectionReference subRef =
        FirebaseFirestore.instance.collection('Subscriber');

    final subStream = subRef.orderBy('timestamp', descending: true).snapshots();

    return subStream;
  }*/

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
      ),
      body: SingleChildScrollView(
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
            const Text(
              "Total Subscribers:",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: subscribersListStream(gymId!),
              builder: (context, snapshot) {
                // if data available
                if (snapshot.hasData) {
                  List listSub = snapshot.data!.docs;

                  // display as list
                  return ListView.builder(itemBuilder: (context, index) {
                    // get each individual doc
                    DocumentSnapshot document = listSub[index];
                    String docID = document.id;

                    //get sub from each doc
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    String firstName = data['fname'];
                    String lastName = data['lname'];
                    String fullName = '$firstName $lastName';

                    // display as list tile
                    return ListTile(
                      title: Text(fullName),
                    );
                  });

                  // no sub yet
                } else {
                  return const Text(
                    "No Subscribers Yet :/",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
