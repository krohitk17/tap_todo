import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  final String title;
  final String content;
  final Function onPressed;
  const DialogBox(
      {Key? key,
      required this.title,
      required this.onPressed,
      this.content = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () => onPressed(),
          child: const Text("Yes"),
        ),
        ElevatedButton(
          child: const Text("No"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
