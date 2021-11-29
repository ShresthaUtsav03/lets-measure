import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_measure/constants.dart';
import 'package:lets_measure/widgets/error_dialog.dart';
import 'package:lets_measure/views/image_output.dart';
import 'package:lets_measure/widgets/build_button.dart';

class ImageInputScreen extends StatefulWidget {
  const ImageInputScreen({Key? key}) : super(key: key);

  @override
  State<ImageInputScreen> createState() => _ImageInputScreenState();
}

class _ImageInputScreenState extends State<ImageInputScreen> {
  bool imageSelected = false;
  File? image;
  String errorMsg = "";
  Widget next = SizedBox();

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
              const Text('Next'),
              const Icon(Icons.verified_outlined),
            ],
          ),
          onPressed: () {
            imageSelected
                ? Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ImageOutput(image: image);
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
                image: AssetImage("assets/images/tape_bg.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Measure Dimensions",
                    style: Theme.of(context).textTheme.headline3,
                    //.copyWith(fontWeight: FontWeight.w900),
                  ),
                ),
                // const SizedBox(height: 24),
                BuildButton(
                  title: 'Pick Image',
                  icon: Icons.image_outlined,
                  onClicked: () => pickImage(ImageSource.gallery),
                ),
                const SizedBox(height: 14),
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
                        height: size.height * 0.45,

                        //fit: BoxFit.fitHeight,
                      )
                    : const SizedBox(
                        child: Center(
                          child: Text('Image selected will be shown here'),
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
