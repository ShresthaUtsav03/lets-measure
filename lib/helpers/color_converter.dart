String colourToHex(String colour) {
  return colour.split('(0xff')[1].split(')')[0];
}

String colourToRGB(String hex) {
  String rgb =
      int.parse(hex.substring(0, 2), radix: 16).toString().padLeft(3, '0');
  rgb = rgb +
      int.parse(hex.substring(2, 4), radix: 16).toString().padLeft(3, '0');
  rgb = rgb +
      int.parse(hex.substring(4, 6), radix: 16).toString().padLeft(3, '0');
  return rgb;
}
