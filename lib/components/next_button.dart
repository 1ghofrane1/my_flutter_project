import 'package:flutter/material.dart';

class NextButton extends StatefulWidget {
  final VoidCallback? onPressed;

  // ignore: use_super_parameters
  const NextButton({Key? key, this.onPressed}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NextButtonState createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(right: 12.0), // Set right margin
        child: TextButton(
          onPressed: widget.onPressed,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Next',
                style: TextStyle(
                  color: Color(0x9E9E9E9E),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                color: Color(0x9E9E9E9E),
                size: 22,
              )
            ],
          ),
        ),
      ),
    );
  }
}
