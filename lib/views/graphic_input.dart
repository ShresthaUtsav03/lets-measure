import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_measure/constants.dart';
import 'package:lets_measure/error_dialog.dart';
import 'package:lets_measure/views/home.dart';
import 'package:lets_measure/widgets/build_button.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool received = false;
  File? image;
  String errorMsg = "";

  String message = "";
  String resultImage = "";
  late List<dynamic> size;
  Widget imageOutput = const FlutterLogo();

  late String base64;

  void displayResponseImage() async {
    try {
      Uint8List convertedBytes = base64Decode(resultImage);
      //print("The uint8list is:" + resultImage);
      imageOutput = Container(
        width: 120,
        height: 120,
        child: Image.memory(
          convertedBytes,
          fit: BoxFit.cover,
        ),
      );
    } catch (e) {
      errorMsg = e.toString();
      showErrorDialog(context, errorMsg);
    }
  }

  uploadImage() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(kApiUrl + "object_measurement_rectangle"),
      );
      Map<String, String> headers = {"Content-type": "multipart/form-data"};
      request.files.add(
        http.MultipartFile(
          'image',
          image!.readAsBytes().asStream(),
          image!.lengthSync(),
          filename: "filename",
          //contentType: MediaType('image', 'jpeg'),
        ),
      );
      request.headers.addAll(headers);
      //print("request: " + request.toString());
      final response = await request.send();

      http.Response res = await http.Response.fromStream(response);
      final resJson = jsonDecode(res.body);
      received = true;

      message = resJson['message'];
      resultImage = resJson['image'];
      displayResponseImage();
    } catch (e) {
      errorMsg = e.toString();
      showErrorDialog(context, errorMsg);
    }
    print(resultImage);

    //displayResponseImage();
    setState(() {});
    //final decodedBytes = base64Decode(resultImage);
    // base64 = resultImage.toString();
    // try {
    //   print("The code is:" + resultImage);
    // } catch (e) {
    //   print(e.toString());
    // }

    // var file = File("decodedImage.jpg");
    // file.writeAsBytesSync(decodedBytes);
  }

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
      errorMsg = e.toString();
      showErrorDialog(context, errorMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        const Spacer(),
        imageOutput,
        image != null
            ? Image.file(
                image!,
                width: 40,
                height: 40,
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
        BuildButton(
            title: 'Next', icon: Icons.chevron_right, onClicked: uploadImage)
      ],
    );
  }
}
