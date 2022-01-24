import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lets_measure/constants.dart';
import 'package:lets_measure/widgets/error_dialog.dart';
import 'package:lets_measure/widgets/loading.dart';

class ImageOutput extends StatefulWidget {
  File? image;
  final String title;
  ImageOutput({Key? key, required this.image, required this.title})
      : super(key: key);

  @override
  State<ImageOutput> createState() => _ImageOutputState();
}

class _ImageOutputState extends State<ImageOutput> {
  bool loading = true;
  String message = "";
  String resultImage = "";
  String errorMsg = "";
  String route = "";
  Widget imageOutput = const FlutterLogo();

  @override
  void initState() {
    super.initState();
    uploadImage();
  }

  uploadImage() async {
    if (widget.title == "Measure Dimensions") {
      route = "object_measurement_rectangle";
    } else if (widget.title == "Circle Measurement") {
      route = "object_measurement_circle";
    } else {
      route = "angledetector";
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(kApiUrl + route),
      );
      print("Connecting to " + kApiUrl);
      Map<String, String> headers = {"Content-type": "multipart/form-data"};
      request.files.add(
        http.MultipartFile(
          'image',
          widget.image!.readAsBytes().asStream(),
          widget.image!.lengthSync(),
          filename: "filename",
          //contentType: MediaType('image', 'jpeg'),
        ),
      );
      request.headers.addAll(headers);
      //print("request: " + request.toString());
      final response = await request.send();

      http.Response res = await http.Response.fromStream(response);
      final resJson = jsonDecode(res.body);
      loading = false;

      message = resJson['message'];
      resultImage = resJson['image'];
      if (widget.title == 'Circle Measure') {
        print(resJson['no_of_circles']);
      }
      displayResponseImage();
    } catch (e) {
      errorMsg = e.toString();
      showErrorDialog(context, errorMsg);
    }

    // ignore: avoid_print
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

  void displayResponseImage() async {
    try {
      Uint8List convertedBytes = base64Decode(resultImage);
      //print("The uint8list is:" + resultImage);
      imageOutput = Image.memory(
        convertedBytes,
        fit: BoxFit.cover,
      );
    } catch (e) {
      errorMsg = e.toString();
      showErrorDialog(context, errorMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    //uploadImage();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Output Image'),
        backgroundColor: kBlueLightColor,
        foregroundColor: kTextColor,
      ),
      body: SafeArea(
          child: loading
              ? const Loading()
              : InteractiveViewer(
                  panEnabled: true, child: Center(child: imageOutput))),
    );
  }
}
