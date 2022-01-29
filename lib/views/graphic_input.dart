import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_measure/constants.dart';
import 'package:lets_measure/views/angle_selection_screen.dart';
import 'package:lets_measure/views/color_detection_screen.dart';
import 'package:lets_measure/widgets/error_dialog.dart';
import 'package:lets_measure/views/image_output.dart';
import 'package:lets_measure/widgets/build_button.dart';
import 'package:image_cropper/image_cropper.dart';

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

  Future<void> _cropImage() async {
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
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrangeAccent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
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
        shadowColor: Colors.white,
        title: Text(widget.title),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: kBlueColor,
          heroTag: 'uniqueTag',
          label: Row(
            children: const [
              Text('Next  '),
              Icon(Icons.verified_outlined),
            ],
          ),
          onPressed: () {
            imageSelected
                ? Navigator.push(context, MaterialPageRoute(builder: (context) {
                    if (widget.title == 'Detect Color') {
                      return ColorDetectionScreen(image: image!);
                    } else if (widget.title == 'Measure Angle') {
                      return AngleEstimatonScreen(image: image!);
                    } else {
                      return ImageOutput(
                        image: image,
                        title: widget.title,
                      );
                    }
                  }))
                : () {};
          }),
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .4,
            decoration: const BoxDecoration(
              color: Color(0xFFFFCCBC),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 14),
                BuildButton(
                  title: 'Gallery',
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
                              height: size.height * 0.5,
                            ),
                            SizedBox(
                              height: size.height * 0.45,
                              child: const Center(
                                child: Text('Tap to CROP',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: size.height * 0.5,
                        child: const Center(
                          child: Text(
                              'Hint: You may tap on the image after selection\n \t\t\t\t\t\tfor Cropping, Rotating and Resizing..'),
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
