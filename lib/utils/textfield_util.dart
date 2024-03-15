import 'package:flutter/material.dart';

class TextUtil extends StatelessWidget {
  // final VoidCallback onTap;
  final Widget suffixIcon;
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final VoidCallback onSuffixTap;
  const TextUtil(
      {super.key,
      required this.hintText,
      required this.labelText,
      required this.suffixIcon,
      // required this.onTap,
      required this.controller,
      required this.onSuffixTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: TextFormField(
        // readOnly: true,
        controller: controller,
        decoration: InputDecoration(
            suffixIcon:
                GestureDetector(onTap: onSuffixTap, child: suffixIcon),
            hintText: hintText,
            labelText: labelText),
      ),
    );
  }
}
