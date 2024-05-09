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
    gymId = await _firestoreService.getCurrentGymId();
    print('Gym ID: $gymId');
    setState(() {});
  }

  Future<void> _fetchMembershipNames() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Membership').get();

    for (final membership in snapshot.docs) {
      final membershipGymId = membership['gym id'];
      print('Membership Gym ID: $membershipGymId'); // Add this line
      print('bla bla');

      if (membershipGymId == gymId) {
        final membershipName = membership['Membership Name'];
        setState(() {
          membershipNames.add(membershipName);
        });
      }
    }
    print('list over heeeeeeeeeeeeeere ${membershipNames}');
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
