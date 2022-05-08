import 'package:flutter/material.dart';

class LoginTextFiels extends StatefulWidget {
  final bool isPassword;
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  const LoginTextFiels(
      {super.key,
      required this.controller,
      required this.isPassword,
      required this.hintText,
      required this.icon});

  @override
  State<LoginTextFiels> createState() => _LoginTextFielsState();
}

class _LoginTextFielsState extends State<LoginTextFiels> {
  bool obscure = false;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      enabled: true,
      cursorColor: const Color(0xFFA32CCA),
      style: TextStyle(color: Colors.grey[500]),
      obscureText: obscure,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: const Icon(Icons.remove_red_eye_outlined),
                onPressed: () {
                  setState(() {
                    obscure = !obscure;
                  });
                },
                color: Colors.grey[500],
              )
            : const SizedBox(),
        prefixIcon: Icon(
          widget.icon,
          color: Colors.grey[500],
        ),
        fillColor: Colors.black,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(
            width: 2,
            color: Color(0xFFA32CCA),
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(17)),
        hintStyle: TextStyle(color: Colors.grey[700], fontSize: 13),
        hintText: widget.hintText,
      ),
    );
  }
}