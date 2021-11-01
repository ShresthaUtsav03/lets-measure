import 'package:flutter/material.dart';

class BuildButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onClicked;

  // ignore: use_key_in_widget_constructors
  const BuildButton({
    required this.title,
    required this.icon,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onClicked,
      icon: Icon(icon, size: 28, color: Colors.white),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blue),
      ),
      label: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
    // return ElevatedButton(
    //   style: ElevatedButton.styleFrom(
    //     minimumSize: const Size.fromHeight(56),
    //     primary: Colors.white,
    //     onPrimary: Colors.black,
    //     textStyle: const TextStyle(fontSize: 30, color: Colors.black),
    //   ),
    //   onPressed: onClicked,
    //   child: Row(children: [
    //     Icon(icon, size: 28),
    //     const SizedBox(width: 16),
    //   ]),
    // );
  }
}
