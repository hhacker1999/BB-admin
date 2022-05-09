import 'package:flutter/material.dart';

class RoleTag extends StatelessWidget {
  final String tag;
  const RoleTag({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Text(
        tag,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}