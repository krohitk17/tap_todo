import 'package:flutter/material.dart';

Widget logo(double size) {
  return Image.asset(
    'images/logo.png',
    alignment: Alignment.center,
    scale: size,
  );
}

class AppName extends StatelessWidget {
  const AppName({Key? key, this.size = 50, required this.iconsize})
      : super(key: key);
  final double size;
  final double iconsize;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            'Tap ToDo',
            style: TextStyle(
              fontSize: size,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 30),
        logo(iconsize),
      ],
    );
  }
}
