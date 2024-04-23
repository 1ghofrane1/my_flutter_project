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
        // for the password only
        obscureText: obscureText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF9E9E9E)),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(158, 158, 158, 0.62)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0x62BEF264)),
          ),
          fillColor: Colors.transparent,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
