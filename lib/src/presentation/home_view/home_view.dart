import 'package:bb_admin/src/app/app_constants.dart';
import 'package:bb_admin/src/app/app_routes.dart';
import 'package:bb_admin/src/presentation/home_view/home_view_model.dart';
import 'package:bb_admin/src/presentation/home_view/home_view_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../helper/value_stream_builder.dart';
import 'helper/user_card.dart';

class RevisedHomeView extends StatelessWidget {
  const RevisedHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (_, model, __) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppConstants.appBarColor,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.addNewUser);
          },
        ),
        backgroundColor: AppConstants.bgColor,
        appBar: AppBar(
          leading: const SizedBox(),
          backgroundColor: AppConstants.appBarColor,
          title: const Text('Users'),
          centerTitle: true,
        ),
        body: LayoutBuilder(builder: (_, constr) {
          return ValueStreamBuilder(
              builder: (_, state) {
                if (state is HomeViewLoaded) {
                  return AnimationLimiter(
                    child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (_, index) {
                          return AnimationConfiguration.staggeredList(
                              position: index,
                              delay: const Duration(milliseconds: 100),
                              child: SlideAnimation(
                                  duration: const Duration(milliseconds: 2500),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  horizontalOffset: 30,
                                  verticalOffset: 300,
                                  child: FlipAnimation(
                                      duration:
                                          const Duration(milliseconds: 3000),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      flipAxis: FlipAxis.y,
                                      child: MinimalUserCard(
                                          user: state.users[0]))));
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 30),
                        itemCount: 500),
                    // state.users.length + state.expiredDonors.length),
                  );
                } else if (state is HomeViewError) {
                  return Center(
                    child: Text(
                      state.error,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  );
                }
              },
              stream: model.stateStream);
        }),
      );
    });
  }
}
