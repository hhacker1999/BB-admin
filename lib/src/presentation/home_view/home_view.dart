import 'package:bb_admin/src/app/app_constants.dart';
import 'package:bb_admin/src/presentation/home_view/home_view_model.dart';
import 'package:bb_admin/src/presentation/home_view/home_view_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper/value_stream_builder.dart';
import 'helper/user_card.dart';

// class HomeView extends StatelessWidget {
//   const HomeView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<HomeViewModel>(builder: (_, model, __) {
//       return Scaffold(
//         appBar: AppBar(
//           backgroundColor: AppConstants.appBarColor,
//         ),
//         backgroundColor: AppConstants.bgColor,
//         body: SafeArea(
//           child: LayoutBuilder(
//             builder: (_, constr) {
//               return ValueStreamBuilder<HomeViewState>(
//                 stream: model.stateStream,
//                 builder: (_, state) {
//                   if (state is HomeViewLoaded) {
//                     return Column(
//                       children: [
//                         Expanded(
//                           child: ListView.separated(
//                             physics: const BouncingScrollPhysics(),
//                             itemCount: state.users.length,
//                             separatorBuilder: (_, __) {
//                               return const SizedBox(
//                                 height: 30,
//                               );
//                             },
//                             itemBuilder: (_, index) {
//                               return MinimalUserCard(
//                                 user: state.users[index],
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     );
//                   }
//                   if (state is HomeViewError) {
//                     return Center(
//                       child: Text(state.error),
//                     );
//                   } else {
//                     return Container();
//                   }
//                 },
//               );
//             },
//           ),
//         ),
//       );
//     });
//   }
// }

class RevisedHomeView extends StatelessWidget {
  const RevisedHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (_, model, __) {
      return Scaffold(
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
                  return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (_, index) {
                        return MinimalUserCard(user: state.users[index]);
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 30),
                      itemCount: state.users.length);
                } else {
                  return const SizedBox();
                }
              },
              stream: model.stateStream);
        }),
      );
    });
  }
}
