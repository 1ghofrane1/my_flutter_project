import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_project/components/my_button.dart';
import 'package:my_flutter_project/components/my_textfield.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key, required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Method to sign user in
  void signUserIn() async {
    // Check if email and password fields are empty
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showErrorMessage("Please enter both email and password.");
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Sign in with email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Close loading indicator
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Close loading indicator
      Navigator.pop(context);
      // Show error message based on exception code
      if (e.code == 'user-not-found') {
        showErrorMessage("Invalid Email!");
      } else if (e.code == 'wrong-password') {
        showErrorMessage("Invalid Password!");
      } else {
        // Show error message for other FirebaseAuthException codes
        showErrorMessage("Error: ${e.message}");
      }
    } catch (e) {
      // Close loading indicator
      Navigator.pop(context);
      // Show error message for other types of exceptions (e.g., network issues)
      showErrorMessage("Error: ${e.toString()}");
    }
  }

  // Method to show error message dialog
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
        );
      },
    );
  }

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
                // Logo
                Image.asset(
                  'lib/pics/logo.png',
                  height: 100,
                ),
                const SizedBox(height: 50),
                // Welcome back
                const Text(
                  'Welcome Back, Sign in now!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                // Email text field
                MyTextFlield(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                const SizedBox(height: 20),
                // Password text field
                MyTextFlield(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                // Forgot password
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forget Password?',
                        style: TextStyle(color: Colors.white38),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                // Sign in button
                MyButton(
                  text: 'Sign In',
                  onTap: signUserIn,
                ),
                const SizedBox(height: 10),
                // Not a member? Register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not a member?',
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register now',
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
}
