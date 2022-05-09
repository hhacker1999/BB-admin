import 'package:flutter/material.dart';
import 'package:bb_admin/src/domain/entities/user_entity.dart';
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
  final List<String> roles = List.empty(growable: true);
  @override
  void initState() {
    super.initState();
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

  String formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !widget.user.isDonor
          ? FloatingActionButton.extended(
              label: Row(
                children: const [
                  Text('Upgrade to Donor'),
                  Icon(
                    Icons.upgrade,
                  ),
                ],
              ),
              backgroundColor: Colors.deepPurple,
              onPressed: () {},
            )
          : null,
      appBar: AppBar(
        backgroundColor: Colors.purple.withOpacity(0.5),
        title: const Text('User Details'),
      ),
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.purple.withOpacity(0.3), Colors.black])),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          HeadTextWithIcon(
              icon: 'assets/discord.svg',
              text1: 'Name: ${widget.user.discordName}',
              text2: 'Id: ${widget.user.discordId}'),
          const SizedBox(
            height: 20,
          ),
          HeadTextWithIcon(
              icon: 'assets/plex.svg',
              text1: 'Id: ${widget.user.plexId}',
              text2: 'Email: ${widget.user.plexEmail}'),
          const SizedBox(
            height: 20,
          ),
          if (widget.user.isDonor)
            HeadTextWithIcon(
                icon: 'assets/donation.svg',
                text1: 'Last Donation: ${formatDate(lastDono!)}',
                text2: 'Validity: ${widget.user.donationDuration}'),
          const SizedBox(
            height: 20,
          ),
          HeadTextWithIcon(
              icon: 'assets/server.svg',
              text2: 'Current Server: ${widget.user.server}',
              text1: 'Added On: ${formatDate(widget.user.dateAdded)}'),
          const SizedBox(
            height: 20,
          ),
          RolesWidget(roles: roles),
          const SizedBox(
            height: 20,
          ),
          if (widget.user.note.isNotEmpty) NotesWidget(note: widget.user.note),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }
}