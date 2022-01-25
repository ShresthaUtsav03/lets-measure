import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:lets_measure/model/coordinates.dart';
import 'package:lets_measure/views/image_output.dart';
import 'package:lets_measure/widgets/error_dialog.dart';

import '../constants.dart';
import '../dropper.dart';

class AnglePointsSelector extends StatefulWidget {
  File image;
  AnglePointsSelector({Key? key, required this.image}) : super(key: key);

  @override
  _AnglePointSelectorState createState() => _AnglePointSelectorState();
}

class _AnglePointSelectorState extends State<AnglePointsSelector> {
  bool pointSelected = false;
  final picker = ImagePicker();
  int nextPoint = 0;
  String title = 'Select point ';
  List<int> intArr = [-1, -1, -1, -1, -1, -1];
  static final CREATE_POST_URL = kApiUrl + 'angledetector';

  Positioned dropper = Positioned(
    child: Container(width: 0.0, height: 0.0),
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
        intArr[nextPoint] = x;
        intArr[nextPoint + 1] = y;
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
        nextPoint = nextPoint + 2;
      });
    } else {
      Post newPost = new Post(
          coordX1: intArr[0].toString(),
          coordY1: intArr[1].toString(),
          coordX2: intArr[2].toString(),
          coordY2: intArr[3].toString(),
          coordX3: intArr[4].toString(),
          coordY3: intArr[5].toString());
      try {
        Post p = await createPost(CREATE_POST_URL, body: newPost.toMap());
      } catch (e) {
        showErrorDialog(context, e.toString());
      }

      setState(() {
        //showErrorDialog(context, 'errorMsg');
        nextPoint = 0;
        intArr = [-1, -1, -1, -1, -1, -1];
      });
    }
  }

  Future createPost(String url, {required Map body}) async {
    print(url);
    return http.post(Uri.parse(url), body: body).then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      final resJson = json.decode(response.body);
      print(resJson['angle_value']);
      return Post.fromJson(resJson);
    });
  }

  @override
  Widget build(BuildContext context) {
    pointSelected = false;
    print("Next point: " + nextPoint.toString());
    print(intArr);
    return Scaffold(
      appBar: AppBar(
        title: Text(title + (nextPoint + 1).toString()),
        backgroundColor: Colors.orange,
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
            _nextPointSelection();
          }),
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
    );
  }
}
