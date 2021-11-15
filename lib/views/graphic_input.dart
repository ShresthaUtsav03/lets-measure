import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_measure/constants.dart';
import 'package:lets_measure/error_dialog.dart';
import 'package:lets_measure/views/home.dart';
import 'package:lets_measure/views/image_output.dart';
import 'package:lets_measure/widgets/build_button.dart';
import 'package:http/http.dart' as http;
import 'package:lets_measure/widgets/loading.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool imageSelected = false;
  bool received = false;
  File? image;
  String errorMsg = "";
  Widget next = SizedBox();

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
        imageSelected = true;
      });
    } on PlatformException catch (e) {
      errorMsg = e.toString();
      showErrorDialog(context, errorMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: kBlueColor,
          heroTag: 'uniqueTag',
          label: Row(
            children: [
              Text('Next'),
              Icon(Icons.verified_outlined),
            ],
          ),
          onPressed: () {
            imageSelected
                ? Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ImageOutput();
                  }))
                : () {};
          }),
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .45,
            decoration: BoxDecoration(
              color: kBlueLightColor,
              image: DecorationImage(
                image: AssetImage("assets/images/meditation_bg.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Text(
                  "Measure Dimensions",
                  style: Theme.of(context).textTheme.headline3,
                  //.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 24),
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
                const SizedBox(height: 14),
                image != null
                    ? Image.file(
                        image!,
                        width: size.width * 0.97,
                        height: size.height * 0.55,

                        //fit: BoxFit.fitHeight,
                      )
                    : const SizedBox(
                        child: Center(
                          child: Text('Image selected will be show here'),
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
