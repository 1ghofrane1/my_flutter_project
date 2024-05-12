import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneField extends StatelessWidget {
  final controller;
  final String hintText;

  const PhoneField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
// Custom dialog style
    PickerDialogStyle customDialogStyle = PickerDialogStyle(
      //backgroundColor: Colors.blue, // Change the background color
      //borderRadius: BorderRadius.circular(10), // Apply border radius
      countryCodeStyle: const TextStyle(color: Colors.black),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      //
      child: IntlPhoneField(
        controller: controller,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        dropdownTextStyle: const TextStyle(color: Colors.grey),
        pickerDialogStyle: customDialogStyle,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF9E9E9E)),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0x9E9E9E9E)),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0x62BEF264)),
          ),
          fillColor: Colors.transparent,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
        initialCountryCode: 'TN',
        onChanged: (phone) {
          print(phone.completeNumber);
        },
      ),
    );
  }
}
