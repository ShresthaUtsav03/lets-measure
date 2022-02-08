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
  int noOfObjects = 1;
  Widget imageOutput = const FlutterLogo();

  @override
  void initState() {
    super.initState();
    uploadImage();
  }

  uploadImage() async {
    switch (widget.title) {
      case 'Circle: Dimensions':
        route = "object_measurement_circle";
        break;
      case 'Polygon: Area and Perimeter':
        route = "area_estimation_polygon";
        break;
      case 'Circle: Area and Perimeter':
        route = "area_estimation_circle";
        break;
      case 'Polygon: Dimensions':
        route = "object_measurement_rectangle";
        break;
      default:
        route = "area_estimation_irregular";
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(kApiUrl + route),
      );
      //print("Connecting to " + kApiUrl);
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
      final response =
          await request.send().timeout(const Duration(seconds: 90));
      loading = false;
      http.Response res = await http.Response.fromStream(response)
          .timeout(const Duration(seconds: 100));
      final resJson = jsonDecode(res.body);

      message = resJson['message'];
      resultImage = resJson['image'];
      noOfObjects = resJson['no of object'];
      print(noOfObjects);

      switch (message) {
        case "success":
          switch (noOfObjects) {
            case -1:
              showErrorDialog(context, "Aruco marker could not be detected!");
              print("Aruco marker could not be detected!");
              break;
            case 0:
              showErrorDialog(context, "No stated object could be detected!");
              print("No object could be detected!");
              break;
            default:
              print("Objects detected!");
              displayResponseImage();
          }

          break;
        default:
          showErrorDialog(context, message);
      }
    } catch (e) {
      loading = false;

      showErrorDialog(context,
          'Ooops..there seems to be a problem connecting with the server!\n\nPlease try again!');
    }

    //setState(() {});
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
      setState(() {
        imageOutput = Image.memory(
          convertedBytes,
          fit: BoxFit.cover,
        );
      });
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepOrangeAccent,
        shadowColor: Colors.white,
      ),
      body: SafeArea(
          child: loading
              ? const Loading()
              : InteractiveViewer(
                  panEnabled: true, child: Center(child: imageOutput))),
    );
  }
}
