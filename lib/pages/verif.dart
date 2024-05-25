import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Verif extends StatefulWidget {
  const Verif({super.key});

  @override
  _VerifState createState() => _VerifState();
}

class _VerifState extends State<Verif> {
  String status = 'Checking...';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null && userId.isNotEmpty) {
      try {
        bool userFound = false;

        // Check "Not Verified" collection
        DocumentSnapshot notVerifiedDoc = await FirebaseFirestore.instance
            .collection('Not Verified')
            .doc(userId)
            .get();
        print(userId);
        if (notVerifiedDoc.exists) {
          setState(() {
            status = 'Pending';
          });
          userFound = true;
        } else {
          // Check "Subscriber" collection
          DocumentSnapshot subscriberDoc = await FirebaseFirestore.instance
              .collection('Subscriber')
              .doc(userId)
              .get();
          if (subscriberDoc.exists) {
            setState(() {
              status = 'Approved';
            });
            userFound = true;
          } else {
            // Check "Coach" collection
            DocumentSnapshot coachDoc = await FirebaseFirestore.instance
                .collection('Coach')
                .doc(userId)
                .get();
            if (coachDoc.exists) {
              setState(() {
                status = 'Approved';
              });
              userFound = true;
            }
          }
        }

        if (!userFound) {
          setState(() {
            status = 'Declined';
          });
        }
      } catch (e) {
        setState(() {
          status = 'Error fetching status';
        });
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        status = 'User not logged in';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.hourglass_empty,
                size: 100,
                color: Color(0xFFBEF264),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your request is being processed by your gym manager.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please wait while your account is being verified.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),
              isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFBEF264),
                      ),
                    )
                  : Text(
                      'Status: $status',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBEF264),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF171717),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
