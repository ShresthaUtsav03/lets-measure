import 'package:flutter/foundation.dart';

Map<String, dynamic> shiftColor(
    {required double a,
    required int r,
    required int g,
    required int b,
    required double shiftValue}) {
  return {'a': a * shiftValue / 100, 'r': r, 'g': g, 'b': b};
}
