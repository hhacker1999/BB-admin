import 'package:flutter/material.dart';
import 'package:bb_admin/src/app/app_constants.dart';

class LoginTextFiels extends StatefulWidget {
  final bool isPassword;
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  const LoginTextFiels({
    Key? key,
    required this.isPassword,
    required this.controller,
    required this.hintText,
    required this.icon,
  }) : super(key: key);

  @override
  State<LoginTextFiels> createState() => _LoginTextFielsState();
}

class _LoginTextFielsState extends State<LoginTextFiels> {
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      enabled: true,
      cursorColor: AppConstants.appBarColor,
      obscureText: widget.isPassword ? obscure : false,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: const Icon(Icons.remove_red_eye_outlined),
                onPressed: () {
                  setState(() {
                    obscure = !obscure;
                  });
                },
                color: Colors.black,
              )
            : const SizedBox(),
        prefixIcon: Icon(
          widget.icon,
          color: Colors.black,
        ),
        fillColor: AppConstants.textFieldFillColor,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(
            width: 2,
            color: AppConstants.appBarColor,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(17)),
        hintStyle: TextStyle(color: Colors.grey[700], fontSize: 13),
        hintText: widget.hintText,
      ),
    );
  }
}
