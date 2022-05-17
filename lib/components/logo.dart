import 'package:flutter/material.dart';

Widget Logo(double size) {
  return Image.asset(
    'images/logo.png',
    alignment: Alignment.center,
    scale: size,
  );
}

Widget AppName(double size) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Center(
        child: Text(
          'Tap ToDo',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      const SizedBox(width: 30),
      Logo(size),
    ],
  );
}
