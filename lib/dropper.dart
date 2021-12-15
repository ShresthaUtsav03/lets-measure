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

  const Dropper(this.colour, this.flippedX, this.flippedY);

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..rotateY((flippedX ? 180 : 0) / 180 * pi)
        ..rotateX((flippedY ? 180 : 0) / 180 * pi),
      child: Transform.translate(
        offset: flippedY ? Offset(0.0, -2 * totalHeight) : Offset(0.0, 0.0),
        child: Container(
          width: totalWidth,
          height: totalHeight,
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  child: Image.asset(
                    'assets/images/dropper_thick.jpeg',
                    scale: 7.0,
                  ),
                ),
              ),
              Positioned(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
