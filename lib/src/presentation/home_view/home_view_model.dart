import 'package:bb_admin/src/domain/entities/auth_entity.dart';
import 'package:bb_admin/src/domain/usecases/authenticate_user_usecase.dart';
import 'package:bb_admin/src/domain/usecases/get_all_users_usecase.dart';

class HomeViewModel {
  final GetAllUsersUsecase _getAllUsersUsecase;
  final AuthenticateUserUsecase _authenticateUserUsecase;

  HomeViewModel(
    this._getAllUsersUsecase,
    this._authenticateUserUsecase,
  ) {
    test();
  }

  Future<void> test() async {
    await _getAllUsersUsecase.execute();
  }
}
