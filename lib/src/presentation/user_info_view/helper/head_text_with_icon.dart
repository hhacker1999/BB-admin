import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'user_details_text.dart';

class HeadTextWithIcon extends StatelessWidget {
  final String icon;
  final String text1;
  final String text2;
  String? tag;
  HeadTextWithIcon({
    Key? key,
    required this.icon,
    this.tag,
    required this.text1,
    required this.text2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: Hero(
            tag: tag ?? '',
            child: SvgPicture.asset(
              icon,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        UserDetailsText(
          text1: text1,
          text2: text2,
        ),
      ],
    );
  }
}
