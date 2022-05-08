import 'dart:convert';
import 'package:flutter/foundation.dart';

class ServerInfoEntity {
  final List<String> roles;
  final List<String> servers;
  final List<String> donorRoles;
  const ServerInfoEntity({
    required this.roles,
    required this.servers,
    required this.donorRoles,
  });

  ServerInfoEntity copyWith({
    List<String>? roles,
    List<String>? servers,
    List<String>? donorRoles,
  }) {
    return ServerInfoEntity(
      roles: roles ?? this.roles,
      servers: servers ?? this.servers,
      donorRoles: donorRoles ?? this.donorRoles,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'roles': roles});
    result.addAll({'servers': servers});
    result.addAll({'donorRoles': donorRoles});

    return result;
  }

  factory ServerInfoEntity.fromMap(Map<String, dynamic> map) {
    return ServerInfoEntity(
      roles: List<String>.from(map['roles']),
      servers: List<String>.from(map['servers']),
      donorRoles: List<String>.from(map['donorRoles']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ServerInfoEntity.fromJson(String source) =>
      ServerInfoEntity.fromMap(json.decode(source));

  @override
  String toString() =>
      'ServerInfo(roles: $roles, servers: $servers, donorRoles: $donorRoles)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ServerInfoEntity &&
        listEquals(other.roles, roles) &&
        listEquals(other.servers, servers) &&
        listEquals(other.donorRoles, donorRoles);
  }

  @override
  int get hashCode => roles.hashCode ^ servers.hashCode ^ donorRoles.hashCode;
}
