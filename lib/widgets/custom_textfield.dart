import 'package:flutter/material.dart';

import '../constanse.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final IconData? icon;
  late Function(String?) onClick;

  CustomTextField(
      {@required this.hint, @required this.icon, required this.onClick});

  String _errorMessage(String str) {
    switch (str) {
      case 'Enter your name ':
        return 'name is empty !';
      case 'Enter your email':
        return 'email is empty !';
      case 'Enter your Password':
        return 'password is empty !';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return _errorMessage(hint!);
          }
        },
        onSaved: onClick,
        obscureText: hint == 'Enter your Password' ? true : false,
        cursorColor: KSecondColor,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: KMainColor,
          ),
          filled: true,
          fillColor: KSecondColor,
          hintText: hint,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(40),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(40),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
    );
  }
}
