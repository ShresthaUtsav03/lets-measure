import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lets_measure/widgets/category_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context)
        .size; //this gonna give us total height and with of our device
    return Scaffold(
      //bottomNavigationBar: BottomNavBar(),
      body: Stack(
        children: <Widget>[
          Container(
            // Here the height of the container is 45% of our total height
            height: size.height * .45,
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
                  Text("Let's \nMeasure!",
                      style: Theme.of(context).textTheme.headline3
                      //.copyWith(fontWeight: FontWeight.w900),
                      ),
                  SizedBox(height: 40),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: .85,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: <Widget>[
                        CategoryCard(
                          title: "Measure Dimensions",
                          svgSrc: "assets/icons/Hamburger.svg",
                          selectedOption: 'Dimension',
                        ),
                        CategoryCard(
                          title: "Detect Color",
                          svgSrc: "assets/icons/gym.svg",
                          selectedOption: 'Color',
                        ),
                        CategoryCard(
                          title: "Measure Angle",
                          svgSrc: "assets/icons/Meditation.svg",
                          selectedOption: 'Angle',
                        ),
                        CategoryCard(
                          title: "Compass \nand Level ",
                          svgSrc: "assets/icons/yoga.svg",
                          selectedOption: 'Compass',
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
