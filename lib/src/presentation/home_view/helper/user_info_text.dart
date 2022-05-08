import 'package:flutter/material.dart';

class UserInfoText extends StatelessWidget {
  final String text;
  final FontWeight weight;
  final double fontSize;
  const UserInfoText(
      {super.key,
      required this.text,
      required this.fontSize,
      required this.weight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.white, fontSize: fontSize, fontWeight: weight),
    );
  }
}