import 'package:flutter/material.dart';
import 'package:todo/components/dialogbox.dart';

class Button extends StatelessWidget {
  const Button(
      {Key? key,
      required this.size,
      required this.onPressed,
      required this.title,
      this.content = ''})
      : super(key: key);
  final String title;
  final String content;
  final Function onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red, size: size),
      onPressed: () => showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            title: title,
            content: content,
            onPressed: () => onPressed(),
          );
        },
      ),
    );
  }
}
