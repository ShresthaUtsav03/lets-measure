import 'dart:math';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Dropper extends StatelessWidget {
  static double totalWidth = 60.0;
  static double totalHeight = 85.0;
  final double boxSize = 40.0;

  final Color colour;
  final bool flippedX;
  final bool flippedY;
  final String calledBy;

  // ignore: use_key_in_widget_constructors
  const Dropper(this.colour, this.flippedX, this.flippedY, this.calledBy);

  @override
  Widget build(BuildContext context) {
    String imgAddress = 'assets/images/dropper_gradient.png';
    double scale = 7.0;
    if (calledBy == 'angle') {
      imgAddress = 'assets/images/pointer.png';
      scale = 17.0;
    }
    return Transform(
      transform: Matrix4.identity()
        ..rotateY((flippedX ? 180 : 0) / 180 * pi)
        ..rotateX((flippedY ? 180 : 0) / 180 * pi),
      child: Transform.translate(
        offset:
            flippedY ? Offset(0.0, -2 * totalHeight) : const Offset(0.0, 0.0),
        child: SizedBox(
          width: totalWidth,
          height: totalHeight,
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 0,
                left: 0,
                child: Image.asset(
                  imgAddress,
                  scale: scale,
                ),
              ),
              calledBy == 'color'
                  ? Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: boxSize,
                        height: boxSize,
                        decoration: BoxDecoration(
                          color: colour,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
