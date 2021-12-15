import 'dart:math';

List<dynamic> convertToCmyk(int r, int g, int b) {
  double r_new = r / 255;
  double g_new = g / 255;
  double b_new = b / 255;

  double k = 1 - [r_new, g_new, b_new].reduce(max);
  double c = (1 - r_new - k) / (1 - k);
  double m = (1 - g_new - k) / (1 - k);
  double y = (1 - b_new - k) / (1 - k);

  return [
    (c * 100).round(),
    (m * 100).round(),
    (y * 100).round(),
    (k * 100).round()
  ];
}
