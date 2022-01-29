import 'package:flutter/material.dart';
import 'package:lets_measure/views/home.dart';
import 'constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LetsMeasure());
}

class LetsMeasure extends StatelessWidget {
  const LetsMeasure({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lets Measure',
        theme: ThemeData(
            fontFamily: "Cairo",
            scaffoldBackgroundColor: kBackgroundColor,
            textTheme:
                Theme.of(context).textTheme.apply(displayColor: kTextColor)),
        initialRoute: '/home',
        routes: {
          '/home': (context) => const HomeScreen(),
        });
  }
}
