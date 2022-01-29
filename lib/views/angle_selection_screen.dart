import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:lets_measure/model/coordinates.dart';
import 'package:lets_measure/widgets/error_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants.dart';
import '../widgets/dropper.dart';

class AngleEstimatonScreen extends StatefulWidget {
  File image;
  AngleEstimatonScreen({Key? key, required this.image}) : super(key: key);

  @override
  _AngleEstimationScreenState createState() => _AngleEstimationScreenState();
}

class _AngleEstimationScreenState extends State<AngleEstimatonScreen> {
  bool pointSelected = false;
  final picker = ImagePicker();
  int index = 0;
  List<int> intArr = [-1, -1, -1, -1, -1, -1];
  static final route = kApiUrl + 'angledetector';
  String angleEstimated = "Error, Please try again!";

  Positioned dropper = const Positioned(
    child: SizedBox(width: 0.0, height: 0.0),
  );

  void _screenTouched(dynamic details, ImgDetails img, RenderBox box) {
    double widgetScale = box.size.width / img.width!;
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    var x = (localOffset.dx / widgetScale).round();
    var y = (localOffset.dy / widgetScale).round();
    bool flippedX = box.size.width - localOffset.dx < Dropper.totalWidth;
    bool flippedY = localOffset.dy < Dropper.totalHeight;
    if (box.size.height - localOffset.dy > 0 && localOffset.dy > 0) {
      setState(() {
        intArr[index] = x;
        intArr[index + 1] = y;
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

  Future<void> _nextPointSelection() async {
    if (intArr[5] == -1) {
      setState(() {
        index = index + 2;
      });
    } else {
      Post newPost = Post(
          coordX1: intArr[0].toString(),
          coordY1: intArr[1].toString(),
          coordX2: intArr[2].toString(),
          coordY2: intArr[3].toString(),
          coordX3: intArr[4].toString(),
          coordY3: intArr[5].toString());
      try {
        await createPost(route, body: newPost.toMap());
        setState(() {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  color: const Color(0xFF737373),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Clockwise angle is: " + angleEstimated,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
      } catch (e) {
        setState(() {
          Navigator.pop(context);
          showErrorDialog(context, e.toString());
        });
      }

      setState(() {
        //showErrorDialog(context, 'errorMsg');
        index = 0;
        intArr = [-1, -1, -1, -1, -1, -1];
      });
    }
  }

  Future createPost(String url, {required Map body}) async {
    try {
      //print(url);
      return http
          .post(Uri.parse(url), body: body)
          .then((http.Response response) {
        final int statusCode = response.statusCode;

        if (statusCode < 200 || statusCode > 400 || json == null) {
          throw Exception("Error while fetching data");
        }
        final resJson = json.decode(response.body);
        //print(resJson['angle_value']);
        angleEstimated = resJson['angle_value'].toString();
        return Post.fromJson(resJson);
      });
    } on TimeoutException catch (e) {
      //print(e.toString());
      setState(() {
        Navigator.pop(context);
        showErrorDialog(context,
            'Sorry we are unable to connect with the server\n\nMake sure you are connected with the server');
      });
    } catch (e) {
      setState(() {
        Navigator.pop(context);
        showErrorDialog(context, e.toString());
      });
    }
  }

  Widget _helpText() {
    switch (index) {
      case 0:
        return const Text('Drag the pointer to the mid point in angle');

      case 2:
        return const Text('Now to the first point clockwise');

      case 4:
        return const Text('This time to the next end clockwise');

      default:
        return const Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    pointSelected = false;
    // print("Next point: " + index.toString());
    // print(intArr);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Angle Estimation'),
        backgroundColor: Colors.deepOrangeAccent,
        shadowColor: Colors.white,
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
          onPressed: () async {
            Fluttertoast.showToast(msg: "Point selected");
            _nextPointSelection();
          }),
      body: Column(
        children: [
          _helpText(),
          Expanded(
            child: Center(
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
                            pointSelected = true;
                            _screenTouched(details, img,
                                context.findRenderObject() as RenderBox);
                          },
                        );
                      }),
                  dropper
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
