// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_pixels/image_pixels.dart';
// import 'package:lets_measure/constants.dart';
// import 'package:lets_measure/widgets/error_dialog.dart';
// import 'package:lets_measure/widgets/loading.dart';

// class ColorDetectionOutput extends StatefulWidget {
//   File? image;
//   ColorDetectionOutput({this.image});

//   @override
//   State<ColorDetectionOutput> createState() => _ColorDetectionOutputState();
// }

// class _ColorDetectionOutputState extends State<ColorDetectionOutput> {
//   bool loading = true;
//   String message = "";
//   String resultImage = "";
//   String errorMsg = "";
//   Widget ColorDetectionOutput = const FlutterLogo();

//   @override
//   void initState() {
//     super.initState();
//     uploadImage();
//   }

//   uploadImage() async {
//     try {
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse(kApiUrl + "object_measurement_rectangle"),
//       );
//       print("Connecting to " + kApiUrl);
//       Map<String, String> headers = {"Content-type": "multipart/form-data"};
//       request.files.add(
//         http.MultipartFile(
//           'image',
//           widget.image!.readAsBytes().asStream(),
//           widget.image!.lengthSync(),
//           filename: "filename",
//           //contentType: MediaType('image', 'jpeg'),
//         ),
//       );
//       request.headers.addAll(headers);
//       //print("request: " + request.toString());
//       final response = await request.send();

//       http.Response res = await http.Response.fromStream(response);
//       final resJson = jsonDecode(res.body);
//       loading = false;

//       message = resJson['message'];
//       resultImage = resJson['image'];
//       displayResponseImage();
//     } catch (e) {
//       errorMsg = e.toString();
//       showErrorDialog(context, errorMsg);
//     }

//     print(resultImage);

//     //displayResponseImage();
//     setState(() {});
//     //final decodedBytes = base64Decode(resultImage);
//     // base64 = resultImage.toString();
//     // try {
//     //   print("The code is:" + resultImage);
//     // } catch (e) {
//     //   print(e.toString());
//     // }

//     // var file = File("decodedImage.jpg");
//     // file.writeAsBytesSync(decodedBytes);
//   }

//   void displayResponseImage() async {
//     try {
//       Uint8List convertedBytes = base64Decode(resultImage);
//       //print("The uint8list is:" + resultImage);
//       ColorDetectionOutput = Container(
//         //width: 120,
//         //height: 120,

//         child: Image.memory(
//           convertedBytes,
//           fit: BoxFit.cover,
//         ),
//       );
//     } catch (e) {
//       errorMsg = e.toString();
//       showErrorDialog(context, errorMsg);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;

//     //uploadImage();
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('Output Image'),
//         backgroundColor: kBlueLightColor,
//         foregroundColor: kTextColor,
//       ),
//       body: SafeArea(
//           child: loading
//               ? Loading()
//               : Center(child: Column(
//                 children: [
//                   Flexible(child: ColorDetectionOutput),
//                   Flexible(child: ImagePixels(
//               imageProvider: widget.image as AssetImage,
//               builder: (context, img) =>
//                   Text(
//                      "Img size is: ${img.width} × ${img.height}.\n"
//                      "Pixel color is: ${img.pixelColorAt!(x, y)}.");
//               );)
//                 ],
//               ))),
//     );
//   }
// }