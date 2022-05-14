import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:bb_admin/src/app/app_constants.dart';
import 'package:bb_admin/src/app/app_routes.dart';
import 'package:bb_admin/src/domain/entities/user_entity.dart';
import 'package:bb_admin/src/presentation/home_view/helper/user_info_text.dart';
import 'package:bb_admin/src/presentation/user_info_view/user_info_view_model.dart';

import 'helper/head_text_with_icon.dart';
import 'helper/notes_widget.dart';
import 'helper/roles_widget.dart';

class UserInfoView extends StatefulWidget {
  final UserEntity user;
  const UserInfoView({super.key, required this.user});

  @override
  State<UserInfoView> createState() => _UserInfoViewState();
}

class _UserInfoViewState extends State<UserInfoView> {
  late DateTime? lastDono;
  late UserEntity updatedEntity;
  final List<String> roles = List.empty(growable: true);
  @override
  void initState() {
    super.initState();
    updatedEntity = widget.user;
  }

  void updateState() {
    if (updatedEntity.isDonor) {
      lastDono = updatedEntity.pastDonations!.last;
    } else {
      lastDono = null;
    }
    roles.clear();
    roles.addAll(updatedEntity.roles);
    if (updatedEntity.isDonor) {
      roles.add(updatedEntity.donorRole!);
    }
    roles.reversed;
  }

  String formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    updateState();
    return Consumer<UserInfoViewModel>(builder: (_, model, __) {
      return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor:
                updatedEntity.isDonor && updatedEntity.validity! <= 2
                    ? AppConstants.expireUserColor.withOpacity(0.8)
                    : AppConstants.bgColor,
            onPressed: () async {
              final newUser = await Navigator.pushNamed(
                  context, AppRoutes.addNewUser,
                  arguments: updatedEntity);
              if (newUser != null) {
                setState(() {
                  updatedEntity = newUser as UserEntity;
                });
              }
            },
            label: const Text('Edit Details')),
        appBar: AppBar(
          backgroundColor: updatedEntity.isDonor && updatedEntity.validity! <= 2
              ? AppConstants.expireUserColor
              : AppConstants.appBarColor,
          title: const Text('User Details'),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                updatedEntity.isDonor && updatedEntity.validity! <= 2
                    ? AppConstants.expireUserColor.withOpacity(0.8)
                    : AppConstants.bgColor,
                Colors.black
              ])),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            HeadTextWithIcon(
                tag: updatedEntity.discordId,
                icon: 'assets/discord.svg',
                text1: 'Name: ${updatedEntity.discordName}',
                text2: 'Id: ${updatedEntity.discordId}'),
            const SizedBox(
              height: 20,
            ),
            HeadTextWithIcon(
                tag: null,
                icon: 'assets/plex.svg',
                text1: 'Id: ${updatedEntity.plexId}',
                text2: 'Email: ${updatedEntity.plexEmail}'),
            const SizedBox(
              height: 20,
            ),
            HeadTextWithIcon(
                tag: null,
                icon: 'assets/server.svg',
                text2: 'Servers: ${updatedEntity.servers}',
                text1: 'Added On: ${formatDate(updatedEntity.dateAdded)}'),
            const SizedBox(
              height: 20,
            ),
            if (updatedEntity.isDonor)
              DonorWidget(
                  user: updatedEntity, dateString: formatDate(lastDono!)),
            const SizedBox(
              height: 20,
            ),
            if (updatedEntity.roles.isNotEmpty) RolesWidget(roles: roles),
            const SizedBox(
              height: 20,
            ),
            if (updatedEntity.note.isNotEmpty)
              NotesWidget(note: updatedEntity.note),
            const SizedBox(
              height: 20,
            ),
          ]),
        ),
      );
    });
  }
}

class DonorWidget extends StatelessWidget {
  final UserEntity user;
  final String dateString;
  const DonorWidget({
    Key? key,
    required this.user,
    required this.dateString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/donation.svg',
              height: 60,
              width: 60,
            ),
            const Text(
              'Donations',
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        UserInfoText(
            text: 'Last Donation: $dateString',
            style: AppConstants.freeUserCardTextStyle),
        UserInfoText(
            text: 'Validity: ${user.validity}',
            style: AppConstants.freeUserCardTextStyle),
        UserInfoText(
            text: user.isRecurring! ? 'Type: Recurring' : 'Type: Non Recurring',
            style: AppConstants.freeUserCardTextStyle),
      ],
    );
  }
}
