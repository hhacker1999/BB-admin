import 'package:flutter/material.dart';
import '../../../domain/entities/user_entity.dart';
import 'user_info_text.dart';

// class DonorExpiredCard extends StatelessWidget {
//   final double height;
//   final double width;
//   final UserEntity user;
//   const DonorExpiredCard(
//       {super.key,
//       required this.user,
//       required this.height,
//       required this.width});

//   @override
//   Widget build(BuildContext context) {
//     final DateTime lastDono = user.pastDonations.last;
//     final DateTime todayDate = DateTime.now();
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//       height: height,
//       width: width,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         color: const Color(0xffFF5050),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xffFF5050).withOpacity(0.5),
//             blurRadius: 20,
//             offset: const Offset(5, 20),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           UserInfoText(
//             text: user.discordName,
//             fontSize: 22,
//             weight: FontWeight.w400,
//           ),
//           UserInfoText(
//             fontSize: 20,
//             weight: FontWeight.normal,
//             text: user.plexId,
//           ),
//           UserInfoText(
//             fontSize: 20,
//             weight: FontWeight.normal,
//             text:
//                 'Last Donation: ${lastDono.year}/${lastDono.month}/${lastDono.day}',
//           ),
//           UserInfoText(
//             fontSize: 20,
//             weight: FontWeight.normal,
//             text: 'Validity: ${todayDate.compareTo(lastDono)} days',
//           ),
//         ],
//       ),
//     );
//   }
// }
