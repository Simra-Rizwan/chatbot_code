import 'package:flutter/material.dart';
import 'auth_text_field.dart';

class PasswordTextField extends StatefulWidget {
  PasswordTextField(
      {super.key, required this.hintText , this.controller, this.validator});

  final String hintText;
  TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool obscureText = true;
  void _toggleObscureText(){
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      hintText: widget.hintText,
      obscureText: obscureText,
      controller: widget.controller,
      validator: widget.validator,
      suffixIcon: IconButton(
        onPressed: _toggleObscureText,
        icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
      ),
    );
  }
}
