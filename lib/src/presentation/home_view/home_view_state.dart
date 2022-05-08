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
  final List<UserEntity> expiredDonors;
  final List<UserEntity> users;
  const HomeViewLoaded({
    required this.expiredDonors,
    required this.users,
  });
}