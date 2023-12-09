import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MainButtonWidget extends HookWidget {
  MainButtonWidget({Key? key, required this.onPressed, required this.text, this.isLoading}) : super(key: key);
  String text;
  var isLoading;
  void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: 180,
      height: 50,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
      color: const Color(0xFF2B2A27),
      child: isLoading.value // true ? x= 0 : x = 1
          ? const CircularProgressIndicator()
          : Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Careem'),
            ),
    );
  }
}
