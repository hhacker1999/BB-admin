import 'package:flutter/material.dart';
import 'role_tag.dart';
import 'text_22_underlined.dart';

class RolesWidget extends StatelessWidget {
  final List<String> roles;
  const RolesWidget({super.key, required this.roles});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text22Undelined(text: 'Roles'),
        const SizedBox(
          height: 13,
        ),
        Wrap(
          spacing: 10,
          runSpacing: 12,
          children: roles.reversed.map((e) => RoleTag(tag: e)).toList(),
        ),
      ],
    );
  }
}