import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_measure/constants.dart';
import 'package:lets_measure/views/color_selection_screen.dart';
import 'package:lets_measure/widgets/error_dialog.dart';
import 'package:lets_measure/views/image_output.dart';
import 'package:lets_measure/widgets/build_button.dart';
import 'package:image_cropper/image_cropper.dart';
import 'color_detect.dart';

class ImageInputScreen extends StatefulWidget {
  final String title;
  const ImageInputScreen({required this.title});

  @override
  State<ImageInputScreen> createState() => _ImageInputScreenState();
}

class _ImageInputScreenState extends State<ImageInputScreen> {
  bool imageSelected = false;
  File? image;
  String errorMsg = "";

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

  Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: image!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrangeAccent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      image = croppedFile;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: kMeasureDimension,
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: kBlueColor,
          heroTag: 'uniqueTag',
          label: Row(
            children: [
              const Text('Next  '),
              const Icon(Icons.verified_outlined),
            ],
          ),
          onPressed: () {
            imageSelected
                ? Navigator.push(context, MaterialPageRoute(builder: (context) {
                    if (widget.title == 'Detect Color') {
                      return ColorSelectionScreen(image: image!);
                    } else
                      return ImageOutput(
                        image: image,
                        title: widget.title,
                      );
                  }))
                : () {};
          }),
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .4,
            decoration: const BoxDecoration(
              color: kBlueLightColor,
              //image: DecorationImage(
              //image: AssetImage("assets/images/tape_bg.png"),
              // fit: BoxFit.fitWidth,
              // ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(left: 20, top: 10),
                //   child: Text(
                //     widget.title,
                //     style: Theme.of(context).textTheme.headline3,
                //     //.copyWith(fontWeight: FontWeight.w900),
                //   ),
                // ),
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
                    ? GestureDetector(
                        onTap: _cropImage,
                        child: Stack(
                          children: [
                            Image.file(
                              image!,
                              width: size.width * 1,
                              height: size.height * 0.45,
                              //fit: BoxFit.fitHeight,
                            ),
                            SizedBox(
                              height: size.height * 0.45,
                              child: Center(
                                child: Text('Tap to CROP',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: size.height * 0.45,
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
