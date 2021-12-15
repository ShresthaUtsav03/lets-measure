import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';

import './helpers/color_retriever.dart';
import './color_palette.dart';
import './helpers/color_converter.dart';

class ColourComplimentScreen extends StatefulWidget {
  final Color oriColor;
  final dynamic assetImage;

  ColourComplimentScreen({required this.oriColor, this.assetImage});

  @override
  _ColourComplimentScreenState createState() => _ColourComplimentScreenState();
}

class _ColourComplimentScreenState extends State<ColourComplimentScreen> {
  late String complimentHex;
  late String complimentColourName;

  @override
  void initState() {
    super.initState();
    complimentHex = colourToHex(widget.oriColor.compliment.toString());
    getColour(colourHex: complimentHex).then((colour) {
      setState(() {
        complimentColourName = colour['name'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (complimentColourName == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'COMPLEMENT COLOUR:',
                  style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  complimentColourName == null
                      ? ''
                      : complimentColourName.toUpperCase(),
                  style: TextStyle(
                    color: widget.oriColor.compliment,
                    fontWeight: FontWeight.w900,
                    fontSize: 19,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            children: <Widget>[
              Container(
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: widget.oriColor.compliment,
                      borderRadius: BorderRadius.all(
                        Radius.circular(22),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 45.0),
                        child: Text('DOMINANT COLOURS'),
                      ),
                      ColorPalette(
                        assetImage: widget.assetImage,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
