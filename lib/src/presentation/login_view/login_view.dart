import 'package:bb_admin/src/app/app_routes.dart';
import 'package:bb_admin/src/domain/entities/auth_entity.dart';
import 'package:bb_admin/src/presentation/helper/value_stream_consumer.dart';
import 'package:bb_admin/src/presentation/login_view/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/app_constants.dart';
import 'helper/animated_card.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  late TextEditingController _urlController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: 'http://138.68.74.201');
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (_, model, __) => Scaffold(
        // backgroundColor: Colors.black,
        backgroundColor: AppConstants.appBarColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: LayoutBuilder(builder: (context, constr) {
              return ValueStreamConsumer<LoginViewState>(
                  listener: (_, state) {
                    if (state is LoginViewLoggedIn) {
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.homeRoute);
                    }
                  },
                  stream: model.stateStream,
                  builder: (context, snapshot) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        height: constr.maxHeight,
                        width: constr.maxWidth,
                        child: Column(
                          children: [
                            const Spacer(),
                            TweenAnimationBuilder(
                                curve: Curves.fastLinearToSlowEaseIn,
                                duration: const Duration(milliseconds: 1500),
                                tween: Tween<double>(begin: 1.25, end: 1),
                                builder: (_, double value, __) {
                                  return Transform.scale(
                                    scale: value,
                                    child: FadeTransition(
                                      opacity: _fadeAnimation,
                                      child: AnimatingCard(
                                        error: snapshot is LoginViewError
                                            ? (snapshot as LoginViewError).error
                                            : '',
                                        isLoading: snapshot is LoginViewLoading,
                                        onPressed: () {
                                          final AuthEntity entity = AuthEntity(
                                              url: _urlController.text,
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text);
                                          model.logIn(entity);
                                        },
                                        emailController: _emailController,
                                        passwordController: _passwordController,
                                        urlController: _urlController,
                                      ),
                                    ),
                                  );
                                }),
                            const Spacer(),
                          ],
                        ),
                      ),
                    );
                  });
            }),
          ),
        ),
      ),
    );
  }
}
