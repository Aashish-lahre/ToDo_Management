import 'package:flutter/material.dart';

void scaffoldMessage({required String message, required BuildContext context, required Size screenSize}) {
  final snackBar = SnackBar(
    content:
     Text(message, style: const TextStyle(color: Colors.white),),
    width: screenSize.width * .6,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.grey.shade800,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  );
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}