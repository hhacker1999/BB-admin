import 'package:bb_admin/src/domain/entities/user_entity.dart';
import 'package:bb_admin/src/domain/online_database_facade.dart';

class UpdateUserUsecase {
  final OnlineDatabaseFacade _onlineDatabaseFacade;

  const UpdateUserUsecase(this._onlineDatabaseFacade);

  Future<void> execute(UserEntity user) {
    return _onlineDatabaseFacade.updateUser(user);
  }
}
