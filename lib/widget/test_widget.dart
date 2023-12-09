import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFelidApp extends StatelessWidget {
  TextFelidApp(
      {required this.lable,
        required this.icon,
        required this.hint,
        required this.controllerFiled,
        this.passwordField = false,
        required this.validation});

  String lable = "";
  Icon icon;
  String hint = "";
  bool passwordField = false;
  String? Function(String?)? validation;
  TextEditingController controllerFiled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: lable,
          // fillColor: backGroundText,
          prefixIcon: icon,
          hintText: hint,
          contentPadding: EdgeInsets.all(17),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          hintStyle: TextStyle(
            height: 1,
          ),
        ),
        obscureText: passwordField,
        controller: controllerFiled,
        validator: validation,
      ),
    );
  }
}
