import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_project/components/my_button.dart';
import 'package:my_flutter_project/components/my_textfield.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  LoginScreen({super.key, required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // print the error code and msg

      print(
          "HAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWIIIIIIIIIIIIIIIIIIIINIIIIIIIIIIIIIIIIIIIIIIIIIIII LEEEEEEEENAAAAAAAAAAAAAAAAAAAAAA WEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");
      print("Error code: ${e.code}");
      print("Error message: ${e.message}");
      print("exception: ${e.toString()}");
      print(
          "HAAAAAAAAAAAAAAAAAAAAAAAAAAAAAWIIIIIIIIIIIIIIIIIIIINIIIIIIIIIIIIIIIIIIIIIIIIIIII LEEEEEEEENAAAAAAAAAAAAAAAAAAAAAA WEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE");

      if (e.code == 'invalid-credential') {
        showErrorMessage("Invalid Email or Password!");
      }

      //Wrong email
      else if (e.code == 'user-not-found') {
        // show error to user
        showErrorMessage("Invalid Email!");
      }
      // Wrong password
      else if (e.code == 'wrong-password') {
        //show error to user
        showErrorMessage("Invalid Password!");
      }
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            message,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF171717),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                // logo
                Image.asset(
                  'lib/pics/logo.png',
                  height: 100,
                ),
                SizedBox(height: 50),

                // wlc back
                Text(
                  'Welcome Back, Sign in now!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                SizedBox(height: 25),

                // email txt field
                MyTextFlield(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                SizedBox(height: 10),
                // pwd
                MyTextFlield(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // forgot pwd?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                // sign in button
                MyButton(
                  text: 'Sign In',
                  onTap: signUserIn,
                ),

                const SizedBox(height: 50),
                //not a member? Register now

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a member?',
                        style: TextStyle(color: Colors.white38)),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Register now',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
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
