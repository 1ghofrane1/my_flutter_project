import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Verif extends StatelessWidget {
  const Verif({super.key});

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
              const CircularProgressIndicator(
                color: Color(0xFFBEF264),
              ),
              const SizedBox(height: 50),
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
