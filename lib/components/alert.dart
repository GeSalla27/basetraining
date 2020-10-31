import 'package:flutter/material.dart';

Future<AlertDialog> showAlertDialog(BuildContext context, title, content) {
  return showDialog<AlertDialog>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK")),
        ],
      );
    },
  );
}
