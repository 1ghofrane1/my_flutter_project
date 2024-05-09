import 'package:flutter/material.dart';

class Membership extends StatefulWidget {
  const Membership({super.key});

  @override
  State<Membership> createState() => _MembershipState();
}

class _MembershipState extends State<Membership> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF171717), // Set the background color to #171717
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
      body: const Placeholder(),
    );
  }
}

// Define your membership form as a separate widget
class MembershipForm extends StatelessWidget {
  const MembershipForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFAF9F6),
          borderRadius: BorderRadius.circular(
              20.0), // Adjust the value to change the roundness of corners
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
              'Define Membership Types',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Membership Name'),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Membership Duration'),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Membership Pricing'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Handle form submission
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
