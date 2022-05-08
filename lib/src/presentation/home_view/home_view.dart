import 'package:bb_admin/src/presentation/home_view/home_view_model.dart';
import 'package:bb_admin/src/presentation/home_view/home_view_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper/value_stream_builder.dart';
import 'helper/donot_expired_card.dart';
import 'helper/user_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (_, model, __) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (_, constr) {
              return ValueStreamBuilder<HomeViewState>(
                stream: model.stateStream,
                builder: (_, state) {
                  if (state is HomeViewLoaded) {
                    return Column(
                      children: [
                        state.expiredDonors.isNotEmpty
                            ? SizedBox(
                                height: constr.maxHeight * 0.2,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: 50,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (_, index) {
                                    return Row(
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        DonorExpiredCard(
                                          user: state.expiredDonors[0],
                                          height: constr.maxHeight * 0.3,
                                          width: constr.maxWidth * 0.7,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )
                            : const SizedBox(),
                        SizedBox(
                          height: state.expiredDonors.isEmpty ? 0 : 50,
                        ),
                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: 50,
                            separatorBuilder: (_, __) {
                              return const SizedBox(
                                height: 30,
                              );
                            },
                            itemBuilder: (_, index) {
                              return UserCard(
                                user: state.users[0],
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  if (state is HomeViewError) {
                    return Center(
                      child: Text(state.error),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            },
          ),
        ),
      );
    });
  }
}


