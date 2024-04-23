import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_project/firebase_options.dart';
import 'package:my_flutter_project/pages/auth_page.dart';
import 'package:my_flutter_project/pages/role_screen.dart';
import 'package:my_flutter_project/pages/admin_page.dart';
import 'package:my_flutter_project/pages/coach_page.dart';
import 'package:my_flutter_project/pages/sub_page.dart';

/*void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/preAuth',
      routes: {
        '/preAuth': (context) => PreAuthScreen(),
        '/admin': (context) => AdminPage(),
        '/coach': (context) => CoachPage(),
        '/sub': (context) => SubPage(),
      },
    );
  }
}*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
