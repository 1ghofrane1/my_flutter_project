import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_project/components/drop_list.dart';
import 'package:my_flutter_project/components/my_button.dart';
import 'package:my_flutter_project/components/my_textfield.dart';
import 'package:my_flutter_project/components/phone.dart';
import 'package:my_flutter_project/pages/manager_pages/m_home_page.dart';
import 'package:my_flutter_project/pages/verif.dart';

class RegisterScreen extends StatefulWidget {
  final Function()? onTap;
  const RegisterScreen({super.key, required this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int? _selectedRole;
  // text editing controllers
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                // logo
                Image.asset(
                  'lib/pics/logo.png',
                  height: 90,
                ),
                const SizedBox(height: 20),

                // create account
                const Text(
                  'Let\'s create an account!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // name txt field
                MyTextFlield(
                  controller: fnameController,
                  hintText: 'First Name',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                MyTextFlield(
                  controller: lnameController,
                  hintText: 'Last Name',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                // email txt field
                MyTextFlield(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                // phone
                PhoneField(
                    controller: phoneNumberController,
                    hintText: 'Phone Number'),

                //choose role

                DropDownList(
                  items: const ['Manager', 'Coach', 'Subscriber'],
                  hintText: 'Select Role',
                  value: _selectedRole != null
                      ? ['Manager', 'Coach', 'Subscriber'][_selectedRole!]
                      : null,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedRole = value != null
                          ? ['Manager', 'Coach', 'Subscriber'].indexOf(value)
                          : null;
                    });
                  },
                ),
                const SizedBox(height: 10),
                // pwd
                MyTextFlield(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // confirm password
                MyTextFlield(
                  controller: confirmpasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                const SizedBox(height: 25),
                // sign in button
                MyButton(
                  text: 'Sign Up',
                  onTap: signUserUp,
                ),

                const SizedBox(height: 10),

                //not a member? Register now

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?',
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
                        style: TextStyle(color: Color(0xFFBEF264)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUserUp() async {
    if (!mounted) return;

    // Validate inputs
    if (fnameController.text.isEmpty ||
        lnameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmpasswordController.text.isEmpty) {
      showErrorMessage('Please fill out all fields.');
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)) {
      showErrorMessage('Please enter a valid email address.');
      return;
    }

    if (passwordController.text != confirmpasswordController.text) {
      showErrorMessage('Passwords do not match.');
      return;
    }

    if (_selectedRole == null) {
      showErrorMessage('Please select a role.');
      return;
    }

    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // create user in Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      String collectionName;
      switch (_selectedRole) {
        case 0:
          collectionName = 'Manager';
          break;
        case 1:
          collectionName = 'Coach';
          break;
        case 2:
          collectionName = 'Subscriber';
          break;
        default:
          throw Exception('Invalid role');
      }

      // Check if the 'Manager' collection exists
      final managerCollectionExists = await FirebaseFirestore.instance
          .collection('Manager')
          .get()
          .then((snapshot) {
        return snapshot.docs.isNotEmpty;
      });

      if (!managerCollectionExists && collectionName == 'Manager') {
        // Add to the 'Manager' collection if it doesn't exist and the role is 'Manager'
        await FirebaseFirestore.instance
            .collection('Manager')
            .doc(userCredential.user!.uid)
            .set({
          'fname': fnameController.text,
          'lname': lnameController.text,
          'email': emailController.text,
          'phone_number': phoneNumberController.text,
        });

        // Navigate to the manager home pagea
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MHomePage(),
          ),
        );
      } else if (managerCollectionExists) {
        // Add to 'Not Verified' collection if 'Manager' collection exists or the role is not 'Manager'
        await FirebaseFirestore.instance
            .collection('Not Verified')
            .doc(userCredential.user!.uid)
            .set({
          'fname': fnameController.text,
          'lname': lnameController.text,
          'email': emailController.text,
          'phone_number': phoneNumberController.text,
          'role': collectionName,
        });

        // Navigate to the verification pending page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Verif(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // handle Firebase Authentication exceptions
      if (e.code == 'invalid-email' || e.code == 'email-already-in-use') {
        showErrorMessage("Invalid Email!");
      } else if (e.code == 'weak-password') {
        showErrorMessage("Weak Password!");
      } else {
        showErrorMessage("Error: ${e.message}");
      }
    } finally {
      // pop the loading circle
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
