String colourToHex(String colour) {
  return colour.split('(0xff')[1].split(')')[0];
}
