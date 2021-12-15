import 'package:flutter/material.dart';
import 'package:lets_measure/views/home.dart';

Future<void> showErrorDialog(BuildContext context, String errorMsg) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Alert'),
        content: Text(errorMsg),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
