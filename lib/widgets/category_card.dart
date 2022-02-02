import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lets_measure/views/graphic_input.dart';
import '../constants.dart';

class CategoryCard extends StatefulWidget {
  final String svgSrc;
  final String title;
  const CategoryCard({
    Key? key,
    required this.svgSrc,
    required this.title,
  }) : super(key: key);

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  late String navigation;
  Future showBottomSheet(int count) => showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        )),
        context: context,
        builder: (context) {
          switch (count) {
            case 2:
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text('Polygon'),
                    onTap: () {
                      navigation = 'Polygon: Dimensions';
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Circle'),
                    onTap: () {
                      navigation = 'Circle: Dimensions';
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            default:
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text('Polygon'),
                    onTap: () {
                      navigation = 'Polygon: Area and Perimeter';
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Circle'),
                    onTap: () {
                      navigation = 'Circle: Area and Perimeter';
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Irregular'),
                    onTap: () {
                      navigation = 'Irregular: Area and Perimeter';
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
          }
        },
      );
  Future<String> _getNavigation() async {
    navigation = '';
    switch (widget.title) {
      case 'Measure Dimensions':
        await showBottomSheet(2);
        return navigation;
      case 'Area and Perimeter':
        await showBottomSheet(3);
        return navigation;
      default:
        return widget.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 17),
              blurRadius: 17,
              spreadRadius: -23,
              color: kShadowColor,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              navigation = await _getNavigation();
              navigation != ''
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ImageInputScreen(title: navigation);
                      }),
                    )
                  : () {};
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  const Spacer(),
                  SvgPicture.asset(
                    widget.svgSrc,
                    height: 80,
                  ),
                  const Spacer(),
                  Text(widget.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle2
                      //.copyWith(fontSize: 15),
                      )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
