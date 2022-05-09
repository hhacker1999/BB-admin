import 'package:bb_admin/src/presentation/home_view/home_view_model.dart';
import 'package:bb_admin/src/presentation/home_view/home_view_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper/value_stream_builder.dart';
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
        backgroundColor: Colors.grey[900],
        body: SafeArea(
          child: LayoutBuilder(
            builder: (_, constr) {
              return ValueStreamBuilder<HomeViewState>(
                stream: model.stateStream,
                builder: (_, state) {
                  if (state is HomeViewLoaded) {
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: state.users.length,
                            separatorBuilder: (_, __) {
                              return const SizedBox(
                                height: 30,
                              );
                            },
                            itemBuilder: (_, index) {
                              return MinimalUserCard(
                                user: state.users[index],
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
