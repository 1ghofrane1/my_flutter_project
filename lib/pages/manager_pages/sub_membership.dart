import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_project/services/firestore.dart';

class Membership extends StatefulWidget {
  const Membership({super.key});

  @override
  State<Membership> createState() => _MembershipState();
}

class _MembershipState extends State<Membership> {
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
          'Membership',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return const MembershipForm();
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Builder(builder: (BuildContext context) {
                return const SubscriptionForm(); // Display the SubscriptionForm
              });
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.grey[900],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
              child: membershipNames.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: membershipNames.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Chip(
                            label: Text(membershipNames[index]),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  void addSubscrition() {}
}

class SubscriptionForm extends StatefulWidget {
  const SubscriptionForm({Key? key}) : super(key: key);

  @override
  _SubscriptionFormState createState() => _SubscriptionFormState();
}

class _SubscriptionFormState extends State<SubscriptionForm> {
  final FirestoreService firestoreService = FirestoreService();
  List<String> subsList = [];
  String? gymId;

  @override
  void initState() {
    super.initState();
    _fetchGymId();
  }

  Future<void> _fetchGymId() async {
    gymId = await firestoreService.getCurrentGymId();
    _getSub();
  }

  Future<void> _getSub() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Subscriber').get();

    setState(() {
      subsList.clear(); // Clear the list before updating with new data
    });

    for (final sub in snapshot.docs) {
      final String subGymId = sub['gym id'].trim();
      print('Subscription Gym ID type: ${subGymId.runtimeType}');

      if (subGymId == gymId) {
        final String firstName = sub['first name'];
        final String lastName = sub['last name'];
        final String fullName = '$firstName $lastName';
        setState(() {
          subsList.add(fullName);
          print('trueeeeeeeeeeeeeeee');
        });
      } else {
        print('maha2ah subbbb');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select a Subscriber"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 100,
            child: subsList.isEmpty
                ? const Center(
                    child:
                        CircularProgressIndicator()) // Show a loading indicator if data is still loading
                : SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: subsList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Chip(
                            label: Text(subsList[index]),
                          ),
                        );
                      },
                    ),
                  ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {},
          child: const Text('Add'),
        ),
      ],
    );
  }
}

// Membership form
class MembershipForm extends StatefulWidget {
  const MembershipForm({super.key});

  @override
  State<MembershipForm> createState() => _MembershipFormState();
}

class _MembershipFormState extends State<MembershipForm> {
  final TextEditingController _membershipNameController =
      TextEditingController();
  final TextEditingController _membershipPricingController =
      TextEditingController();
  String? _selectedDuration;

  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFAF9F6),
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: EdgeInsets.fromLTRB(
          20.0,
          20.0,
          20.0,
          MediaQuery.of(context).viewInsets.bottom + 20.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Define a Membership Type',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _membershipNameController,
              decoration: const InputDecoration(labelText: 'Membership Name'),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
              value: _selectedDuration,
              onChanged: (newValue) {
                setState(() {
                  _selectedDuration = newValue;
                });
              },
              decoration:
                  const InputDecoration(labelText: 'Membership Duration'),
              items: <String?>['Monthly', 'Quarterly', 'Semi-annual', 'Annual']
                  .map<DropdownMenuItem<String>>((String? value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value ?? ''),
                );
              }).toList(),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _membershipPricingController,
              decoration:
                  const InputDecoration(labelText: 'Membership Pricing'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                final membershipPricing =
                    double.tryParse(_membershipPricingController.text) ?? 0;
                final membershipName = _membershipNameController.text;

                try {
                  await _firestoreService.addMembership(
                    membershipName: membershipName,
                    selectedDuration: _selectedDuration,
                    membershipPricing: membershipPricing,
                  );

                  _membershipNameController.clear();
                  _membershipPricingController.clear();
                  setState(() {
                    _selectedDuration = null;
                  });
                } catch (e) {
                  print('Error adding membership: $e');
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
