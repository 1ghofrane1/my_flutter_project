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
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _fetchGymId();
    _fetchMembershipNames();
  }

  void _fetchGymId() async {
    gymId = await _getGymId();

    print('Gym ID: ${gymId.runtimeType}');
    _fetchMembershipNames(); // Call _fetchMembershipNames after updating gymId
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
                              ? const Center(child: CircularProgressIndicator())
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
            const Placeholder(),
          ],
        ),
      ),
    );
  }
}
