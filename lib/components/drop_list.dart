import 'package:flutter/material.dart';

class DropDownList extends StatelessWidget {
  final List<String> items;
  final String? hintText;
  final String? value;
  final void Function(String?)? onChanged;

  const DropDownList({
    super.key,
    required this.items,
    this.hintText,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: DropdownButtonFormField<String>(
        value: value,
        hint: hintText != null
            ? Text(hintText!, style: const TextStyle(color: Colors.grey))
            : null,
        dropdownColor: const Color(0xFF171717),
        focusColor: Colors.transparent,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(158, 158, 158, 0.62)),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(158, 158, 158, 0.62)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Color(0x62BEF264)), // Change color here
          ),
        ),
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(color: Colors.white), // Set color to white
            ),
          );
        }).toList(),
      ),
    );
  }
}
