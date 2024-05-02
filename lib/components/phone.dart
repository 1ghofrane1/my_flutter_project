/*
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Phone extends StatelessWidget {
  final controller;

  const Phone({super.key,
  required this.controller,});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: IntlPhoneField(
        controller: controller,
        keyboardType: TextInputType.phone,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        initialCountryCode: 'TN',
        decoration: _buildInputDecoration('Phone Number'),
        //change country code color

        onChanged: (phone) {
          print(phone.completeNumber);
        },
      ),
    );
  }
}
*/