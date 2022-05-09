import 'package:flutter/material.dart';
import '../../home_view/helper/user_info_text.dart';

class UserDetailsText extends StatelessWidget {
  final String text1;
  final String text2;
  const UserDetailsText({super.key, required this.text1, required this.text2});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserInfoText(text: text1, fontSize: 20, weight: FontWeight.w400),
        UserInfoText(text: text2, fontSize: 20, weight: FontWeight.w400),
      ],
    );
  }
}