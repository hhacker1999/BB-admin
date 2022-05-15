import 'dart:developer';
import 'package:bb_admin/src/app/app_constants.dart';
import 'package:bb_admin/src/app/app_routes.dart';
import 'package:bb_admin/src/presentation/home_view/home_view_model.dart';
import 'package:bb_admin/src/presentation/home_view/home_view_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../helper/value_stream_builder.dart';
import 'helper/user_card.dart';

class RevisedHomeView extends StatefulWidget {
  const RevisedHomeView({super.key});

  @override
  State<RevisedHomeView> createState() => _RevisedHomeViewState();
}

class _RevisedHomeViewState extends State<RevisedHomeView>
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _animationController = AnimationController(
        lowerBound: -10,
        upperBound: 100,
        vsync: this,
        duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (_, model, __) {
      return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return await Future.value(false);
        },
        child: Scaffold(
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
                    log(state.users.length.toString());
                    return Stack(
                      children: [
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                DropdownButton<String>(
                                    iconEnabledColor: Colors.white,
                                    dropdownColor: AppConstants.appBarColor,
                                    style: const TextStyle(color: Colors.white),
                                    value: state.currentServer,
                                    items: state.servers
                                        .map((e) => DropdownMenuItem<String>(
                                            value: e, child: Text(e)))
                                        .toList(),
                                    onChanged: (value) {
                                      FocusScope.of(context).unfocus();
                                      _searchController.clear();
                                      model.sortparameter(server: value);
                                    }),
                                DropdownButton<String>(
                                    iconEnabledColor: Colors.white,
                                    dropdownColor: AppConstants.appBarColor,
                                    style: const TextStyle(color: Colors.white),
                                    value: state.currentRole,
                                    items: state.roles
                                        .map((e) => DropdownMenuItem<String>(
                                            value: e, child: Text(e)))
                                        .toList(),
                                    onChanged: (value) {
                                      FocusScope.of(context).unfocus();
                                      _searchController.clear();
                                      model.sortparameter(role: value);
                                    }),
                                DropdownButton<String>(
                                    iconEnabledColor: Colors.white,
                                    dropdownColor: AppConstants.appBarColor,
                                    style: const TextStyle(color: Colors.white),
                                    value: state.currentDRole,
                                    items: state.dRoles
                                        .map((e) => DropdownMenuItem<String>(
                                            value: e, child: Text(e)))
                                        .toList(),
                                    onChanged: (value) {
                                      FocusScope.of(context).unfocus();
                                      _searchController.clear();
                                      model.sortparameter(dRole: value);
                                    }),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: state.users.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'No users',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : AnimationLimiter(
                                      child: NotificationListener(
                                        onNotification:
                                            (UserScrollNotification noti) {
                                          final dire = noti.direction;
                                          if (dire == ScrollDirection.reverse) {
                                            _animationController.forward();
                                          } else if (dire ==
                                              ScrollDirection.forward) {
                                            _animationController.reverse();
                                          }
                                          return true;
                                        },
                                        child: ListView.separated(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30),
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemBuilder: (_, index) {
                                              return AnimationConfiguration
                                                  .staggeredList(
                                                      position: index,
                                                      delay: const Duration(
                                                          milliseconds: 100),
                                                      child: SlideAnimation(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      2500),
                                                          curve: Curves
                                                              .fastLinearToSlowEaseIn,
                                                          horizontalOffset: 30,
                                                          verticalOffset: 300,
                                                          child: FlipAnimation(
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          3000),
                                                              curve: Curves
                                                                  .fastLinearToSlowEaseIn,
                                                              flipAxis:
                                                                  FlipAxis.y,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  FocusScope.of(
                                                                          context)
                                                                      .unfocus();
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      AppRoutes
                                                                          .userInfoRoute,
                                                                      arguments:
                                                                          state.users[
                                                                              index]);
                                                                },
                                                                child: MinimalUserCard(
                                                                    key: Key(state
                                                                        .users[
                                                                            index]
                                                                        .discordName),
                                                                    user: state
                                                                            .users[
                                                                        index]),
                                                              ))));
                                            },
                                            separatorBuilder: (_, __) =>
                                                const SizedBox(height: 30),
                                            itemCount: state.users.length),
                                      ),
                                      // state.users.length + state.expiredDonors.length),
                                    ),
                            ),
                          ],
                        ),
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (_, __) => Positioned(
                            left: 30,
                            bottom: -_animationController.value,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppConstants.bgColor,
                                borderRadius: BorderRadius.circular(17),
                              ),
                              width: constr.maxWidth * 0.7,
                              child: TextField(
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    model.queryList(value);
                                  } else {
                                    model.restoreList();
                                  }
                                },
                                controller: _searchController,
                                cursorColor: AppConstants.appBarColor,
                                style: const TextStyle(color: Colors.white),
                                enabled: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(17)),
                                  fillColor:
                                      AppConstants.appBarColor.withOpacity(0.8),
                                  filled: true,
                                  hintStyle: TextStyle(
                                      color: Colors.grey[500], fontSize: 13),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(17),
                                    borderSide: const BorderSide(
                                      width: 2,
                                      color: AppConstants.freeUserColor,
                                    ),
                                  ),
                                  hintText: 'Search Users',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
        ),
      );
    });
  }
}
