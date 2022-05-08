import 'package:flutter/material.dart';
import 'login_text_field.dart';

class AnimatingCard extends StatelessWidget {
  final TextEditingController urlController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const AnimatingCard(
      {super.key,
      required this.emailController,
      required this.passwordController,
      required this.urlController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFF282C35),
      ),
      height: 380,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      child: Column(
        children: [
          LoginTextFiels(
            controller: urlController,
            isPassword: false,
            hintText: 'Enter url',
            icon: Icons.computer,
          ),
          const Spacer(),
          LoginTextFiels(
            controller: emailController,
            isPassword: false,
            hintText: 'Enter email',
            icon: Icons.email,
          ),
          const Spacer(),
          LoginTextFiels(
            controller: passwordController,
            isPassword: true,
            hintText: 'Enter password',
            icon: Icons.password,
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(const Color(0xFFA32CCA)),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
            ),
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
