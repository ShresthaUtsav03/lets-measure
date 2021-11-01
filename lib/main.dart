import 'package:flutter/material.dart';
import 'package:lets_measure/views/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LetsMeasure());
}

class LetsMeasure extends StatelessWidget {
  const LetsMeasure({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Lets Measure', initialRoute: '/home', routes: {
      '/home': (context) => const Home(),
    });
  }
}
