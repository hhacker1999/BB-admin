import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animator/animator.dart';
import 'package:bb_admin/src/app/app_constants.dart';
import 'package:bb_admin/src/app/app_routes.dart';
import 'package:bb_admin/src/presentation/helper/value_stream_consumer.dart';
import 'package:bb_admin/src/presentation/splash_view/splash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Consumer<SplashViewModel>(
      builder: (_, model, __) => Scaffold(
          backgroundColor: AppConstants.bgColor,
          body: Center(
            child: ValueStreamConsumer<SplashViewState>(
                stream: model.state,
                listener: (_, state) {
                  if (state is SplashViewLoggedIn) {
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.homeRoute);
                  } else if (state is SplashViewLoggedOut) {
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.loginRoute);
                  }
                },
                builder: (_, __) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Animator<double>(
                          duration: const Duration(milliseconds: 2000),
                          curve: Curves.easeInOut,
                          tween: Tween<double>(begin: 1, end: 1.1),
                          cycles: 0,
                          builder: (_, value, __) => Animator<double>(
                                cycles: 0,
                                duration: const Duration(milliseconds: 2000),
                                curve: Curves.easeInOut,
                                tween: Tween<double>(begin: 0, end: 20),
                                builder: (_, nextValue, __) =>
                                    Transform.translate(
                                  offset: Offset(
                                    0,
                                    nextValue.value,
                                  ),
                                  child: Image.asset(
                                    'assets/icon.png',
                                    height: width * 0.6 * value.value,
                                    width: width * 0.6 * value.value,
                                  ),
                                ),
                              )),
                      const SizedBox(
                        height: 30,
                      ),
                      AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Black Beard Media',
                            speed: const Duration(
                              milliseconds: 100,
                            ),
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                        repeatForever: true,
                        isRepeatingAnimation: true,
                      )
                    ],
                  );
                }),
          )),
    );
  }
}
