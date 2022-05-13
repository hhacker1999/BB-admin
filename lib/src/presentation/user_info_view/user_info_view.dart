import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bb_admin/src/app/app_constants.dart';
import 'package:bb_admin/src/presentation/user_info_view/user_info_view_model.dart';
import 'package:flutter/material.dart';
import 'package:bb_admin/src/domain/entities/user_entity.dart';
import 'package:provider/provider.dart';
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
  late TextEditingController _validityControler;
  final List<String> roles = List.empty(growable: true);
  @override
  void initState() {
    super.initState();
    _validityControler = TextEditingController();
    updatedEntity = widget.user;
    if (widget.user.isDonor) {
      lastDono = widget.user.pastDonations.last;
    } else {
      lastDono = null;
    }
    roles.addAll(widget.user.otherRoles);
    if (widget.user.isDonor) {
      roles.add(widget.user.donorRole);
    }
    roles.reversed;
  }

  @override
  void dispose() {
    _validityControler.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserInfoViewModel>(builder: (_, model, __) {
      return Scaffold(
        floatingActionButton: !updatedEntity.isDonor
            ? FloatingActionButton.extended(
                label: Row(
                  children: const [
                    Text('Upgrade to Donor'),
                    Icon(
                      Icons.upgrade,
                    ),
                  ],
                ),
                backgroundColor: AppConstants.freeUserColor,
                onPressed: () {
                  final dialog = AwesomeDialog(
                      dialogType: DialogType.QUESTION,
                      animType: AnimType.TOPSLIDE,
                      btnCancelOnPress: () {
                        updatedEntity.pastDonations.add(DateTime.now());
                        updatedEntity = updatedEntity.copyWith(
                          donorRole: 'Silver Tier',
                          isDonor: true,
                          donationDuration: 30,
                        );
                        model.updateUserDetails(updatedEntity);
                        setState(() {
                          lastDono = updatedEntity.pastDonations.last;
                        });
                      },
                      btnOkOnPress: () {
                        updatedEntity.pastDonations.add(DateTime.now());
                        updatedEntity = updatedEntity.copyWith(
                          isDonor: true,
                          donationDuration: 30,
                          donorRole: 'Gold Tier',
                        );
                        model.updateUserDetails(updatedEntity);
                        setState(() {
                          lastDono = updatedEntity.pastDonations.last;
                        });
                      },
                      btnOkText: 'Gold Tier',
                      btnCancelText: 'Silver Tier',
                      context: (context));
                  dialog.show();
                },
              )
            : null,
        appBar: AppBar(
          backgroundColor: updatedEntity.isDonor
              ? AppConstants.paidUserColor
              : AppConstants.freeUserColor,
          title: const Text('User Details'),
        ),
        backgroundColor: Colors.black,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                updatedEntity.isDonor
                    ? AppConstants.paidUserColor.withOpacity(0.3)
                    : AppConstants.freeUserColor.withOpacity(0.3),
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
                icon: 'assets/plex.svg',
                text1: 'Id: ${updatedEntity.plexId}',
                text2: 'Email: ${updatedEntity.plexEmail}'),
            const SizedBox(
              height: 20,
            ),
            if (updatedEntity.isDonor)
              HeadTextWithIcon(
                  icon: 'assets/donation.svg',
                  text1: 'Last Donation: ${formatDate(lastDono!)}',
                  text2: 'Validity: ${updatedEntity.donationDuration}'),
            const SizedBox(
              height: 20,
            ),
            HeadTextWithIcon(
                icon: 'assets/server.svg',
                text2: 'Current Server: ${updatedEntity.server}',
                text1: 'Added On: ${formatDate(updatedEntity.dateAdded)}'),
            const SizedBox(
              height: 20,
            ),
            RolesWidget(roles: roles),
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
