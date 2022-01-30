import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {

  final TextEditingController controller;
  final bool isPass;
  final String hintText;
  final TextInputType textInput;

  TextFieldInput({required this.controller,this.isPass = false,required this.hintText,required this.textInput});

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(10.0),
      ),
      keyboardType: textInput,
      obscureText: isPass,
    );
  }
}
