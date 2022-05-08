import 'package:flutter/material.dart';
import '../../../domain/entities/user_entity.dart';
import 'user_info_text.dart';

class UserCard extends StatefulWidget {
  final UserEntity user;
  const UserCard({
    super.key,
    required this.user,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool isOpen = false;
  late Color color;
  late int difference;
  late DateTime lastDono;

  @override
  void initState() {
    super.initState();
    color =
        widget.user.isDonor ? const Color(0xff6F12E8) : const Color(0xff39FF14);
    difference = widget.user.isDonor
        ? DateTime.now().compareTo(widget.user.pastDonations.last)
        : 0;

    lastDono =
        widget.user.isDonor ? widget.user.pastDonations.last : DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: isOpen
          ? const EdgeInsets.symmetric(horizontal: 0)
          : const EdgeInsets.symmetric(horizontal: 20),
      curve: Curves.fastLinearToSlowEaseIn,
      height: isOpen ? 330 : 100,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      duration: const Duration(milliseconds: 1500),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isOpen ? 0 : 15),
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(5, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserInfoText(
                  text: widget.user.discordName,
                  fontSize: 22,
                  weight: FontWeight.w400),
              IconButton(
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      isOpen = !isOpen;
                    });
                  },
                  icon: isOpen
                      ? const Icon(Icons.keyboard_arrow_up)
                      : const Icon(Icons.keyboard_arrow_down)),
            ],
          ),
          Flexible(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 1500),
              opacity: isOpen ? 1 : 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: UserInfoText(
                      text: widget.user.discordName,
                      fontSize: 20,
                      weight: FontWeight.normal,
                    ),
                  ),
                  Expanded(
                    child: UserInfoText(
                      text: widget.user.plexId,
                      fontSize: 20,
                      weight: FontWeight.normal,
                    ),
                  ),
                  Expanded(
                    child: UserInfoText(
                      text: widget.user.plexEmail,
                      fontSize: 20,
                      weight: FontWeight.normal,
                    ),
                  ),
                  if (widget.user.isDonor)
                    Expanded(
                      child: UserInfoText(
                        fontSize: 20,
                        weight: FontWeight.normal,
                        text:
                            'Last Donation: ${lastDono.year}/${lastDono.month}/${lastDono.day}',
                      ),
                    ),
                  if (widget.user.isDonor)
                    Expanded(
                      child: UserInfoText(
                        fontSize: 20,
                        weight: FontWeight.normal,
                        text: 'Validity: $difference days',
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}