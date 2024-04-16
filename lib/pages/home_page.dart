import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          onPressed: signUserOut,
          icon: Icon(Icons.logout),
        )
      ]),
      body: QrImageView(
        data: '1234567890',
        version: QrVersions.auto,
        size: 200.0,
      ),
    );
    /* Center(child: Text(
          'LOGGED IN AS: '+ user.email!,
          style: TextStyle(fontSize: 20),
          )));
          */
  }
}
