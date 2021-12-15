import 'package:flutter/material.dart';

import '../helpers/color_converter.dart';
import '../helpers/color_shift.dart';
import '../helpers/color_retriever.dart';
import '../helpers/color_converter.dart';
import '../color_compliment.dart';
import '../extract_arguments.dart';
import '../helpers/rgb_calc.dart';
import '../helpers/cmyk_calc.dart';

class ColorDetailsScreen extends StatefulWidget {
  static const routeName = '/color/details';

  @override
  _ColorDetailsScreenState createState() => _ColorDetailsScreenState();
}

class _ColorDetailsScreenState extends State<ColorDetailsScreen> {
  late Color _currentColour;
  late Color _similarColour;
  late Color _changingColour;
  var imageColorInfo;

  late double _currentSliderValue;
  late double _currentSliderSimilarValue;
  late Map<String, dynamic> _updatedColour;
  late List<dynamic> _updatedColourCMYK;

  var _colour;
  var count = 0;

  @override
  Widget build(BuildContext context) {
    final ExtractArguments args =
        ModalRoute.of(context)!.settings.arguments as ExtractArguments;

    if (count < 1) {
      getColour(colourHex: colourToHex(args.userColor.toString()))
          .then((colour) {
        _currentColour = Color.fromRGBO(
            colour['rgb']['r'], colour['rgb']['g'], colour['rgb']['b'], 1);
        _changingColour = Color.fromRGBO(
            colour['rgb']['r'], colour['rgb']['g'], colour['rgb']['b'], 1);
        _updatedColour = {'r': 0, 'g': 0, 'b': 255, 'a': 1.0};
        _currentSliderValue = 100;
        _currentSliderSimilarValue = 0;
        _updatedColourCMYK = [
          colour['cmyk']['c'],
          colour['cmyk']['m'],
          colour['cmyk']['y'],
          colour['cmyk']['k']
        ];
        _similarColour = Color.fromRGBO(
            colour['rgb']['r'], colour['rgb']['g'], colour['rgb']['b'], 1);

        if (_colour != colour) {
          setState(() {
            _colour = colour;
            count++;
          });
        }
      });
    }
    if (_colour == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/images/LAETUS_LOGO.png',
            width: 120,
          ),
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_sharp),
            color: Colors.black,
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: Text(colourToHex(args.userColor.toString()))
        // SingleChildScrollView(
        //   child: Container(
        //     color: Colors.white,
        //     child: Padding(
        //       padding: const EdgeInsets.all(20.0),
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: <Widget>[
        //           Container(
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: <Widget>[
        //                 Text(
        //                   'AND YOUR COLOUR IS:',
        //                   style: TextStyle(
        //                     fontWeight: FontWeight.w100,
        //                     fontSize: 18,
        //                   ),
        //                 ),
        //                 SizedBox(
        //                   height: 10,
        //                 ),
        //                 Text(
        //                   _colour['name'].toUpperCase(),
        //                   style: TextStyle(
        //                     color: _currentColour,
        //                     fontWeight: FontWeight.w900,
        //                     fontSize: 22,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //           SizedBox(
        //             height: 25,
        //           ),
        //           Row(
        //             children: <Widget>[
        //               Container(
        //                 child: SizedBox(
        //                   width: 170,
        //                   height: 170,
        //                   child: DecoratedBox(
        //                     decoration: BoxDecoration(
        //                       color: _changingColour,
        //                       borderRadius: BorderRadius.all(
        //                         Radius.circular(22),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //               SizedBox(
        //                 width: 20,
        //                 height: 20,
        //               ),
        //               Column(
        //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: <Widget>[
        //                   IntrinsicHeight(
        //                     child: Row(
        //                       children: <Widget>[
        //                         Column(
        //                           children: <Widget>[
        //                             Text(
        //                               'C',
        //                               style: TextStyle(
        //                                 fontWeight: FontWeight.bold,
        //                                 fontSize: 18,
        //                                 color: Color(0xFF666666),
        //                               ),
        //                             ),
        //                             Text(
        //                               'M',
        //                               style: TextStyle(
        //                                 fontWeight: FontWeight.bold,
        //                                 fontSize: 18,
        //                                 color: Color(0xFF666666),
        //                               ),
        //                             ),
        //                             Text(
        //                               'Y',
        //                               style: TextStyle(
        //                                 fontWeight: FontWeight.bold,
        //                                 fontSize: 18,
        //                                 color: Color(0xFF666666),
        //                               ),
        //                             ),
        //                             Text(
        //                               'K',
        //                               style: TextStyle(
        //                                 fontWeight: FontWeight.bold,
        //                                 fontSize: 18,
        //                                 color: Color(0xFF666666),
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                         VerticalDivider(
        //                           thickness: 1,
        //                           width: 20,
        //                           color: Colors.black,
        //                         ),
        //                         Column(
        //                           children: <Widget>[
        //                             Text(
        //                               _updatedColourCMYK[0].toString(),
        //                               style: TextStyle(
        //                                 fontSize: 18,
        //                               ),
        //                             ),
        //                             Text(
        //                               _updatedColourCMYK[1].toString(),
        //                               style: TextStyle(
        //                                 fontSize: 18,
        //                               ),
        //                             ),
        //                             Text(
        //                               _updatedColourCMYK[2].toString(),
        //                               style: TextStyle(
        //                                 fontSize: 18,
        //                               ),
        //                             ),
        //                             Text(
        //                               _updatedColourCMYK[3].toString(),
        //                               style: TextStyle(
        //                                 fontSize: 18,
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                   SizedBox(
        //                     width: 20,
        //                     height: 20,
        //                   ),
        //                   IntrinsicHeight(
        //                     child: Row(
        //                       children: <Widget>[
        //                         Column(
        //                           children: [
        //                             Text(
        //                               'R',
        //                               style: TextStyle(
        //                                 fontWeight: FontWeight.bold,
        //                                 fontSize: 18,
        //                                 color: Color(0xFF666666),
        //                               ),
        //                             ),
        //                             Text(
        //                               'G',
        //                               style: TextStyle(
        //                                 fontWeight: FontWeight.bold,
        //                                 fontSize: 18,
        //                                 color: Color(0xFF666666),
        //                               ),
        //                             ),
        //                             Text(
        //                               'B',
        //                               style: TextStyle(
        //                                 fontWeight: FontWeight.bold,
        //                                 fontSize: 18,
        //                                 color: Color(0xFF666666),
        //                               ),
        //                             ),
        //                             Text(
        //                               'O',
        //                               style: TextStyle(
        //                                 fontWeight: FontWeight.bold,
        //                                 fontSize: 18,
        //                                 color: Color(0xFF666666),
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                         VerticalDivider(
        //                           thickness: 1,
        //                           width: 20,
        //                           color: Colors.black,
        //                         ),
        //                         Column(
        //                           children: <Widget>[
        //                             Text(
        //                               _updatedColour['r'].toString(),
        //                               style: TextStyle(
        //                                 fontSize: 18,
        //                               ),
        //                             ),
        //                             Text(
        //                               _updatedColour['g'].toString(),
        //                               style: TextStyle(
        //                                 fontSize: 18,
        //                               ),
        //                             ),
        //                             Text(
        //                               // _colour['rgb']['b'].toString(),
        //                               _updatedColour['b'].toString(),
        //                               style: TextStyle(
        //                                 fontSize: 18,
        //                               ),
        //                             ),
        //                             Text(
        //                               _updatedColour['a'].toStringAsFixed(2),
        //                               style: TextStyle(
        //                                 fontSize: 18,
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ],
        //           ),
        //           SizedBox(height: 30),
        //           Container(
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: <Widget>[
        //                 Text(
        //                   'VARIANT OPACITY',
        //                   style: TextStyle(
        //                     fontWeight: FontWeight.w100,
        //                     fontSize: 15,
        //                   ),
        //                 ),
        //                 Container(
        //                   height: 65,
        //                   child: Theme(
        //                     child: Slider(
        //                       value: _currentSliderValue,
        //                       min: 1,
        //                       max: 100,
        //                       divisions: 1000,
        //                       label:
        //                           '#${_changingColour.value.toRadixString(16)}',
        //                       activeColor: _changingColour,
        //                       onChanged: (double value) {
        //                         setState(() {
        //                           _currentSliderValue = value;
        //                           _updatedColour = shiftColor(
        //                               a: 1.0,
        //                               r: _colour['rgb']['r'],
        //                               g: _colour['rgb']['g'],
        //                               b: _colour['rgb']['b'],
        //                               shiftValue: _currentSliderValue);
        //                           _changingColour = Color.fromRGBO(
        //                               _updatedColour['r'],
        //                               _updatedColour['g'],
        //                               _updatedColour['b'],
        //                               _updatedColour['a']);
        //                         });
        //                       },
        //                     ),
        //                     data: Theme.of(context).copyWith(
        //                       accentTextTheme: TextTheme(
        //                           bodyText2: TextStyle(color: Colors.black)),
        //                     ),
        //                   ),
        //                 ),
        //                 Text(
        //                   'SIMILAR COLOUR TONES',
        //                   style: TextStyle(
        //                     fontWeight: FontWeight.w100,
        //                     fontSize: 15,
        //                   ),
        //                 ),
        //                 Container(
        //                   height: 65,
        //                   child: Theme(
        //                     child: Slider(
        //                       value: _currentSliderSimilarValue,
        //                       min: -60,
        //                       max: 60,
        //                       divisions: 82,
        //                       label: _changingColour.toString(),
        //                       activeColor: _changingColour,
        //                       onChanged: (double value) {
        //                         setState(() {
        //                           _currentSliderSimilarValue = value;
        //                           _updatedColour = changeColour(
        //                               a: 1.0,
        //                               r: _colour['rgb']['r'],
        //                               g: _colour['rgb']['g'],
        //                               b: _colour['rgb']['b'],
        //                               currentSlideValue:
        //                                   _currentSliderSimilarValue);
        //                           _changingColour = Color.fromRGBO(
        //                               _updatedColour['r'],
        //                               _updatedColour['g'],
        //                               _updatedColour['b'],
        //                               _updatedColour['a']);
        //                           _updatedColourCMYK = convertToCmyk(
        //                               _updatedColour['r'],
        //                               _updatedColour['g'],
        //                               _updatedColour['b']);
        //                         });
        //                       },
        //                     ),
        //                     data: Theme.of(context).copyWith(
        //                       accentTextTheme: TextTheme(
        //                           bodyText2: TextStyle(color: Colors.black)),
        //                     ),
        //                   ),
        //                 ),
        //                 Row(
        //                   mainAxisAlignment: MainAxisAlignment.end,
        //                   children: [
        //                     FlatButton(
        //                       onPressed: () {
        //                         setState(() {
        //                           _changingColour = _currentColour;
        //                           _currentSliderValue = 100;
        //                           _currentSliderSimilarValue = 0;
        //                           _currentColour = Color.fromRGBO(
        //                               _colour['rgb']['r'],
        //                               _colour['rgb']['g'],
        //                               _colour['rgb']['b'],
        //                               1);
        //                           _changingColour = Color.fromRGBO(
        //                               _colour['rgb']['r'],
        //                               _colour['rgb']['g'],
        //                               _colour['rgb']['b'],
        //                               1);
        //                           _updatedColour = {
        //                             'r': 0,
        //                             'g': 0,
        //                             'b': 255,
        //                             'a': 1.0
        //                           };
        //                         });
        //                       },
        //                       child: Text('RESET'),
        //                     ),
        //                   ],
        //                 ),
        //               ],
        //             ),
        //           ),
        //           SizedBox(
        //             height: 10,
        //           ),
        //           ColourComplimentScreen(
        //             oriColor: _changingColour,
        //             assetImage: args.userImage,
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        );
  }
}
