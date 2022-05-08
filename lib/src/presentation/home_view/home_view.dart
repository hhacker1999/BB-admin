import 'package:bb_admin/src/presentation/home_view/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (_, model, __) {
      return const Scaffold(
        body: Center(
          child: Text('Home View'),
        ),
      );
    });
  }
}
