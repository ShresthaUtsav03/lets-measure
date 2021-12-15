import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:color_thief_flutter/color_thief_flutter.dart';

class ColorPalette extends StatefulWidget {
  final dynamic assetImage;

  ColorPalette({@required this.assetImage});

  @override
  _ColorPaletteState createState() => _ColorPaletteState();
}

class _ColorPaletteState extends State<ColorPalette> {
  
  List colorRGB = [];
  List colorPaletteRGB = [];
  
  @override
  void initState() {
    super.initState();
    getImageFromProvider(widget.assetImage).then((image) {
      getColorFromImage(image).then((color) {
        setState(() {
          colorRGB = color;
        });
      });
      getPaletteFromImage(image).then((palette) {
        colorPaletteRGB = palette;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 35.0,
          height: 35.0,
          decoration: new BoxDecoration(
            color: Color.fromRGBO(
              colorPaletteRGB[1][0],
              colorPaletteRGB[1][1],
              colorPaletteRGB[1][2],
              1
            ),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 35.0,
          height: 35.0,
          decoration: new BoxDecoration(
            color: Color.fromRGBO(
              colorPaletteRGB[2][0],
              colorPaletteRGB[2][1],
              colorPaletteRGB[2][2],
              1
            ),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 60.0,
          height: 60.0,
          decoration: new BoxDecoration(
            color: Color.fromRGBO(colorRGB[0], colorRGB[1], colorRGB[2], 1),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 35.0,
          height: 35.0,
          decoration: new BoxDecoration(
            color: Color.fromRGBO(
              colorPaletteRGB[4][0],
              colorPaletteRGB[4][1],
              colorPaletteRGB[4][2],
              1
            ),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 35.0,
          height: 35.0,
          decoration: new BoxDecoration(
            color: Color.fromRGBO(
              colorPaletteRGB[5][0],
              colorPaletteRGB[5][1],
              colorPaletteRGB[5][2],
              1
            ),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
