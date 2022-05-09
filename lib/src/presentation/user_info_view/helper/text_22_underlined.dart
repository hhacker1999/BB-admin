import 'package:flutter/material.dart';

class Text22Undelined extends StatelessWidget {
  final String text;
  const Text22Undelined({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 22,
          decoration: TextDecoration.underline,
          color: Colors.white),
    );
  }
}