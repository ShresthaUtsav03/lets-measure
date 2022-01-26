import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:lets_measure/helpers/color_converter.dart';
import 'dart:io';

import '../constants.dart';
import '../dropper.dart';

class ColorDetectionScreen extends StatefulWidget {
  File image;
  ColorDetectionScreen({Key? key, required this.image}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ColorDetectionScreenState();
  }
}

class _ColorDetectionScreenState extends State<ColorDetectionScreen> {
  final picker = ImagePicker();
  Positioned dropper = Positioned(
    child: Container(width: 0.0, height: 0.0),
  );
  late Color currentSelection;
  late String colorHex;
  bool colorSelected = false;

  // Future _getImage(camOrGal) async {
  //   ImageSource source;

  //   camOrGal == 'camera'
  //       ? source = ImageSource.camera
  //       : source = ImageSource.gallery;

  //   final pickedFile = await picker.pickImage(source: source);

  //   setState(() {
  //     if (pickedFile != null) {
  //       widget.image = File(pickedFile.path);
  //     } else {
  //       print(
  //           'No image selected - if you\'re seeing this something is really wrong');
  //     }
  //   });
  // }

  void _screenTouched(dynamic details, ImgDetails img, RenderBox box) {
    double widgetScale = box.size.width / img.width!;
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    var x = (localOffset.dx / widgetScale).round();
    var y = (localOffset.dy / widgetScale).round();
    bool flippedX = box.size.width - localOffset.dx < Dropper.totalWidth;
    bool flippedY = localOffset.dy < Dropper.totalHeight;
    if (box.size.height - localOffset.dy > 0 && localOffset.dy > 0) {
      currentSelection = img.pixelColorAt!(x, y);
      colorHex = colourToHex(currentSelection.toString());
      print(colorHex);
      colorSelected = true;
      setState(() {
        _createDropper(localOffset.dx, box.size.height - localOffset.dy,
            img.pixelColorAt!(x, y), flippedX, flippedY);
      });
    }
  }

  void _createDropper(
      left, bottom, Color colour, bool flippedX, bool flippedY) {
    dropper = Positioned(
      left: left,
      bottom: bottom,
      child: Dropper(colour, flippedX, flippedY),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Selection'),
        backgroundColor: Colors.orange,
        shadowColor: Colors.white,
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            ImagePixels(
                imageProvider: FileImage(widget.image),
                builder: (BuildContext context, ImgDetails img) {
                  return GestureDetector(
                    child: Image.file(widget.image),
                    onPanUpdate: (DragUpdateDetails details) {
                      _screenTouched(details, img,
                          context.findRenderObject() as RenderBox);
                    },
                    onTapDown: (TapDownDetails details) {
                      _screenTouched(details, img,
                          context.findRenderObject() as RenderBox);
                    },
                  );
                }),
            dropper
          ],
        ),
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.,

      floatingActionButton:
          //Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // children: <Widget>[
          //   FloatingActionButton(
          //     heroTag: "hiddenButton",
          //     elevation: 0.0,
          //     backgroundColor: Colors.transparent,
          //     child: Container(),
          //     onPressed: () => {},
          //   ),
          // Builder(
          //   builder: (context) =>
          // FloatingActionButton(
          // heroTag: "addPhotoButton",
          // child: Theme.of(context).platform == TargetPlatform.iOS
          //     ? Icon(CupertinoIcons.camera)
          //     : Icon(Icons.add_a_photo),
          // onPressed: () {
          //   showModalBottomSheet(
          //       context: context,
          //       builder: (context) {
          //         return Container(
          //           color: Color(0xFF737373),
          //           child: Container(
          //             height: 120,
          //             decoration: BoxDecoration(
          //               color: Theme.of(context).canvasColor,
          //               borderRadius: BorderRadius.only(
          //                 topLeft: Radius.circular(10),
          //                 topRight: Radius.circular(10),
          //               ),
          //             ),
          //             child: Column(
          //               children: <Widget>[
          //                 ListTile(
          //                   leading: Icon(Icons.photo_library),
          //                   title: Text('Gallery'),
          //                   onTap: () {
          //                     _getImage('gallery');
          //                     Navigator.pop(context);
          //                   },
          //                 ),
          //                 ListTile(
          //                     leading: Icon(Icons.photo_camera),
          //                     title: Text('Camera'),
          //                     onTap: () {
          //                       _getImage('camera');
          //                       Navigator.pop(context);
          //                     }),
          //               ],
          //             ),
          //           ),
          //         );
          //       });
          // }),
          // ),
          FloatingActionButton.extended(
              backgroundColor: kBlueColor,
              label: Row(
                children: const [
                  Text('Done  '),
                  Icon(Icons.verified_outlined),
                ],
              ),
              heroTag: "colorDetailsButton",
              // child: Center(
              //   child: Image.asset(
              //     'assets/images/dropper_white_transparent_background.jpeg',
              //     scale: 8.5,
              //   ),
              // ),
              onPressed: () {
                if (colorSelected) {
                  //("Image value: $widget.image");
                  if (currentSelection != null && widget.image != null) {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            color: const Color(0xFF737373),
                            child: Container(
                              height: 140,
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: currentSelection,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border:
                                                Border.all(color: Colors.black),
                                          ),
                                        ),
                                        Text(
                                          "#$colorHex",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                        ),
                                      ],
                                    ),
                                    Text("R: " +
                                        colourToRGB(colorHex).substring(0, 3) +
                                        ",  G: " +
                                        colourToRGB(colorHex).substring(3, 6) +
                                        ",  B: " +
                                        colourToRGB(colorHex).substring(6, 9)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                    // Navigator.pushNamed(
                    //   context,
                    //   ColorDetailsScreen.routeName,
                    //   arguments: ExtractArguments(
                    //       FileImage(widget.image), currentSelection),
                    // );
                  }
                } else {}
              }),
      //   ],
      // ),
    );
  }
}
