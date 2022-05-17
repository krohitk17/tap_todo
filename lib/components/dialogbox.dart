import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  final String title;
  final Function onPressed;
  const DialogBox({Key? key, required this.title, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(title: Text(title), actions: <Widget>[
      ElevatedButton(
        onPressed: () => onPressed(),
        child: const Text("Yes"),
      ),
      ElevatedButton(
        child: const Text("No"),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ]);
  }
}
