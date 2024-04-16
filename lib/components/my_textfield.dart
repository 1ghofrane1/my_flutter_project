import 'package:flutter/material.dart';

class MyTextFlield extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextFlield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,

        //because i have a dark bg
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),

        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          fillColor: Colors.grey,
          filled: true,
          hintText: hintText,
          //hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
