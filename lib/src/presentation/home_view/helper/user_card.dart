import 'package:bb_admin/src/app/app_constants.dart';
import 'package:bb_admin/src/app/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../domain/entities/user_entity.dart';
import 'user_info_text.dart';

class MinimalUserCard extends StatelessWidget {
  final UserEntity user;
  const MinimalUserCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.userInfoRoute, arguments: user);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: user.isDonor
              ? AppConstants.paidUserColor
              : AppConstants.freeUserColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 2,
                  child: Hero(
                      tag: user.discordId,
                      child: SvgPicture.asset('assets/discord.svg'))),
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    UserInfoText(
                      text: 'Name: ' + user.discordName,
                      style: user.isDonor
                          ? AppConstants.paidUserCardTextStyle
                          : AppConstants.freeUserCardTextStyle,
                    ),
                    UserInfoText(
                      text: 'Id: ' + user.discordId,
                      style: user.isDonor
                          ? AppConstants.paidUserCardTextStyle
                          : AppConstants.freeUserCardTextStyle,
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
