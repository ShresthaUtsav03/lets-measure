import 'package:flutter/foundation.dart';

int findMedian({required int r, required int g, required int b}) {
  List<int> rgbList = [r, g, b];

  rgbList.sort((a, b) => a.compareTo(b));

  int median;

  int middle = rgbList.length ~/ 2;

  if (rgbList.length % 2 == 1) {
    median = rgbList[middle];
  } else {
    median = ((rgbList[middle - 1] + rgbList[middle]) / 2.0).round();
  }
  return median;
}

Map<String, dynamic> changeColour(
    {required double a,
    required int r,
    required int g,
    required int b,
    required double currentSlideValue}) {
  int medianRGB = findMedian(r: r, g: g, b: b);

  if (r == medianRGB) {
    return {'a': a, 'r': r + currentSlideValue.toInt(), 'g': g, 'b': b};
  } else if (g == medianRGB) {
    return {'a': a, 'r': r, 'g': g + currentSlideValue.toInt(), 'b': b};
  } else if (b == medianRGB) {
    return {'a': a, 'r': r, 'g': g, 'b': b + currentSlideValue.toInt()};
  }
  return {'a': a, 'r': r, 'g': g, 'b': b};
}
