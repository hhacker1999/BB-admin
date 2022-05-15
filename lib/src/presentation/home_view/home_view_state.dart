import 'package:flutter/foundation.dart';

import '../../domain/entities/user_entity.dart';

abstract class HomeViewState {}

class HomeViewInitial implements HomeViewState {}

class HomeViewLoading implements HomeViewState {}

class HomeViewError implements HomeViewState {
  final String error;
  const HomeViewError({
    required this.error,
  });
}

class HomeViewLoaded implements HomeViewState {
  final List<UserEntity> users;
  final List<String> servers;
  final List<String> roles;
  final List<String> dRoles;
  final String currentServer;
  final String currentRole;
  final String currentDRole;

  const HomeViewLoaded({
    required this.users,
    required this.servers,
    required this.roles,
    required this.dRoles,
    required this.currentServer,
    required this.currentRole,
    required this.currentDRole,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HomeViewLoaded && listEquals(other.users, users);
  }

  @override
  int get hashCode => users.hashCode;
}
