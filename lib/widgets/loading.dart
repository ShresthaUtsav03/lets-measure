import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lets_measure/constants.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[750],
      child: Center(
        child: SpinKitWave(
          color: kBlueLightColor,
          size: 100.0,
        ),
      ),
    );
  }
}
