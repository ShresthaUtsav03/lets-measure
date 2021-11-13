import 'package:flutter/material.dart';
import 'package:lets_measure/views/home.dart';

Future<void> showErrorDialog(BuildContext context, String errorMsg) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Alert'),
        content: Text(errorMsg),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
