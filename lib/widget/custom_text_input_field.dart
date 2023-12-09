import 'package:flutter/material.dart';

class CustomTextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final Function? onChangeFunctionl;
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  const CustomTextInputField({super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onChangeFunctionl
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.80,
      height: 75,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFD9D9D9),
          prefixIcon: prefixIcon != null ? Icon(prefixIcon,  color: Colors.black) : null,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.black,) : null,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          labelText: labelText,
          labelStyle: const TextStyle(
            fontFamily: 'Careem',
          ),
        ),
        validator: validator,
        onChanged: onChangeFunctionl as void Function(String)?, // Cast the function type

      ),
    );
  }
}
