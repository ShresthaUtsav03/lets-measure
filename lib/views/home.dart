import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lets_measure/constants.dart';
import 'package:lets_measure/widgets/category_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF5CEB8),
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .40,
            decoration: const BoxDecoration(
              color: Color(0xFFF5CEB8),
              image: DecorationImage(
                alignment: Alignment.centerLeft,
                image: AssetImage("assets/images/undraw_pilates_gpdb.png"),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      alignment: Alignment.center,
                      height: 52,
                      width: 52,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF2BEA1),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset("assets/icons/menu.svg"),
                    ),
                  ),
                  Text("Let's \n  Measure!",
                      style: Theme.of(context).textTheme.headline3),
                  //const SizedBox(height: 50),
                  TextField(
                    onChanged: (value) => kApiUrl = value + '/',
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Enter Server url'),
                  ),
                  Expanded(
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: .85,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: const <Widget>[
                        CategoryCard(
                          title: "Measure Dimensions",
                          svgSrc: "assets/icons/Scales.svg",
                        ),
                        CategoryCard(
                          title: "Area and Perimeter",
                          svgSrc: "assets/icons/AreaPeri.svg",
                        ),
                        CategoryCard(
                          title: "Detect Color",
                          svgSrc: "assets/icons/Color.svg",
                        ),
                        CategoryCard(
                          title: "Measure Angle",
                          svgSrc: "assets/icons/Angle.svg",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
