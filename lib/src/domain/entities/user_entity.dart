import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserEntity {
  final String discordId;
  final String plexId;
  final bool isDonor;
  final String discordName;
  final String plexEmail;
  final int donationDuration;
  final List<String> otherRoles;
  final String donorRole;
  final String note;
  final DateTime dateAdded;
  final List<DateTime> pastDonations;
  final String documentId;
  const UserEntity({
    required this.discordId,
    required this.plexId,
    required this.isDonor,
    required this.discordName,
    required this.plexEmail,
    required this.donationDuration,
    required this.otherRoles,
    required this.donorRole,
    required this.note,
    required this.dateAdded,
    required this.pastDonations,
    required this.documentId,
  });

  UserEntity copyWith({
    String? discordId,
    String? plexId,
    bool? isDonor,
    String? discordName,
    String? plexEmail,
    int? donationDuration,
    List<String>? otherRoles,
    String? donorRole,
    String? note,
    DateTime? dateAdded,
    List<DateTime>? pastDonations,
    String? documentId,
  }) {
    return UserEntity(
      discordId: discordId ?? this.discordId,
      plexId: plexId ?? this.plexId,
      isDonor: isDonor ?? this.isDonor,
      discordName: discordName ?? this.discordName,
      plexEmail: plexEmail ?? this.plexEmail,
      donationDuration: donationDuration ?? this.donationDuration,
      otherRoles: otherRoles ?? this.otherRoles,
      donorRole: donorRole ?? this.donorRole,
      note: note ?? this.note,
      dateAdded: dateAdded ?? this.dateAdded,
      pastDonations: pastDonations ?? this.pastDonations,
      documentId: documentId ?? this.documentId,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'discordId': discordId});
    result.addAll({'plexId': plexId});
    result.addAll({'isDonor': isDonor});
    result.addAll({'discordName': discordName});
    result.addAll({'plexEmail': plexEmail});
    result.addAll({'donationDuration': donationDuration});
    result.addAll({'otherRoles': otherRoles});
    result.addAll({'donorRole': donorRole});
    result.addAll({'note': note});
    result.addAll({'dateAdded': dateAdded.millisecondsSinceEpoch});
    result.addAll({
      'pastDonations':
          pastDonations.map((x) => x.millisecondsSinceEpoch).toList()
    });
    result.addAll({'documentId': documentId});

    return result;
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    final List<DateTime> list = List.empty(growable: true);
    map['pastDonations'].forEach((e) {
      list.add(DateTime.fromMillisecondsSinceEpoch(e));
    });
    return UserEntity(
      discordId: map['discordId'] ?? '',
      plexId: map['plexId'] ?? '',
      isDonor: map['isDonor'] ?? false,
      discordName: map['discordName'] ?? '',
      plexEmail: map['plexEmail'] ?? '',
      donationDuration: map['donationDuration']?.toInt() ?? 0,
      otherRoles: List<String>.from(map['otherRoles']),
      donorRole: map['donorRole'] ?? '',
      note: map['note'] ?? '',
      dateAdded: DateTime.fromMillisecondsSinceEpoch(map['dateAdded']),
      pastDonations: list,
      documentId: map['documentId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserEntity.fromJson(String source) =>
      UserEntity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserEntity(discordId: $discordId, plexId: $plexId, isDonor: $isDonor, discordName: $discordName, plexEmail: $plexEmail, donationDuration: $donationDuration, otherRoles: $otherRoles, donorRole: $donorRole, note: $note, dateAdded: $dateAdded, pastDonations: $pastDonations, documentId: $documentId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserEntity &&
        other.discordId == discordId &&
        other.plexId == plexId &&
        other.isDonor == isDonor &&
        other.discordName == discordName &&
        other.plexEmail == plexEmail &&
        other.donationDuration == donationDuration &&
        listEquals(other.otherRoles, otherRoles) &&
        other.donorRole == donorRole &&
        other.note == note &&
        other.dateAdded == dateAdded &&
        listEquals(other.pastDonations, pastDonations) &&
        other.documentId == documentId;
  }

  @override
  int get hashCode {
    return discordId.hashCode ^
        plexId.hashCode ^
        isDonor.hashCode ^
        discordName.hashCode ^
        plexEmail.hashCode ^
        donationDuration.hashCode ^
        otherRoles.hashCode ^
        donorRole.hashCode ^
        note.hashCode ^
        dateAdded.hashCode ^
        pastDonations.hashCode ^
        documentId.hashCode;
  }
}
