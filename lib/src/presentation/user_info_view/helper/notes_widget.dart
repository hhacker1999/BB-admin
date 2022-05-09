import 'package:flutter/material.dart';
import 'text_22_underlined.dart';

class NotesWidget extends StatelessWidget {
  final String note;
  const NotesWidget({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text22Undelined(
          text: 'Note',
        ),
        const SizedBox(
          height: 13,
        ),
        Text(note, style: const TextStyle(fontSize: 19, color: Colors.white)),
      ],
    );
  }
}