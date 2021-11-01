import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_measure/widgets/build_button.dart';
import 'package:http/http.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? image;
  String? message = "";

  // uploadImage(){
  //   final request = http.MultipartRequest("POST", Uri.parse("google.com"))
  // }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) {
        return;
      }
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick Image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        image != null
            ? Image.file(
                image!,
                width: 160,
                height: 160,
                fit: BoxFit.cover,
              )
            : const FlutterLogo(size: 160),
        const Text('Selected Image'),
        BuildButton(
          title: 'Pick Image',
          icon: Icons.image_outlined,
          onClicked: () => pickImage(ImageSource.gallery),
        ),
        const SizedBox(height: 24),
        BuildButton(
          title: 'Camera',
          icon: Icons.camera_alt_outlined,
          onClicked: () => pickImage(ImageSource.camera),
        ),
        const Spacer(),
        BuildButton(title: 'Next', icon: Icons.chevron_right, onClicked: () {})
      ],
    );
  }
}
