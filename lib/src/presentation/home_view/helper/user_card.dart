import 'package:bb_admin/src/app/app_constants.dart';
import 'package:bb_admin/src/app/app_routes.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/user_entity.dart';
import 'user_info_text.dart';

class MinimalUserCard extends StatefulWidget {
  final UserEntity user;
  const MinimalUserCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<MinimalUserCard> createState() => _MinimalUserCardState();
}

class _MinimalUserCardState extends State<MinimalUserCard> {
  late Color _color;
  late TextStyle _style;
  @override
  void initState() {
    super.initState();
    if (widget.user.isDonor) {
      if (widget.user.validity! <= 2) {
        _style = AppConstants.freeUserCardTextStyle;
        _color = AppConstants.expireUserColor;
      } else {
        _color = AppConstants.paidUserColor;
        _style = AppConstants.paidUserCardTextStyle;
      }
    } else {
      _style = AppConstants.paidUserCardTextStyle;
      _color = AppConstants.freeUserColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 2,
                child: Image.asset(
                  'assets/icon.png',
                  height: 60,
                  width: 60,
                )),
            Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  UserInfoText(
                      text: 'Discord Name: ' + widget.user.discordName,
                      style: _style),
                  UserInfoText(
                    text: 'Plex Name: ' + widget.user.plexId,
                    style: _style,
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}
