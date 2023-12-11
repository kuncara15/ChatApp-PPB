import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final String hintText;
  final bool isObsecureText;
  final TextEditingController controller;

  const MyTextFormField({
    Key? key,
    required this.hintText,
    required this.isObsecureText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          obscureText: isObsecureText,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(Icons.person), // Icon user
            border: InputBorder.none, // Menghilangkan border
            fillColor: Colors.grey.shade300,
            filled: true,
          ),
        ),
        Divider(
          height: 1,
          color: Colors.blue,
          thickness: 2,
        ),
      ],
    );
  }
}
