import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

Future getColour({required String colourHex}) async {
  String url = "https://www.thecolorapi.com/id?hex=$colourHex";
  print(url);
  try {
    http.Response res = await http.get(Uri.parse(url));
    final jsonResponse = json.decode(res.body);

    return {
      'rgb': {
        'r': jsonResponse['rgb']['r'],
        'g': jsonResponse['rgb']['g'],
        'b': jsonResponse['rgb']['b']
      },
      'cmyk': {
        'c': jsonResponse['cmyk']['c'],
        'm': jsonResponse['cmyk']['m'],
        'y': jsonResponse['cmyk']['y'],
        'k': jsonResponse['cmyk']['k']
      },
      'name': jsonResponse['name']['value']
    };

    print(res);
    print(jsonResponse);
  } catch (e) {
    print(e.toString());
  }
}
