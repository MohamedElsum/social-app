import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

pickImage(ImageSource source) async {
  XFile? image = await ImagePicker().pickImage(source: source);
  if (image != null) {
    return File(image.path);
  }
  print('No Image is Selected');
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.grey,
      content: Text(
    content,
    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 15),
  )));
}
