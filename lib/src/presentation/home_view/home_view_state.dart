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
  const HomeViewLoaded({
    required this.users,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is HomeViewLoaded &&
      listEquals(other.users, users);
  }

  @override
  int get hashCode => users.hashCode;
}
