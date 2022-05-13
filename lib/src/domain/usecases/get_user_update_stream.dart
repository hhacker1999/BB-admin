import 'package:bb_admin/src/domain/entities/user_entity.dart';
import 'package:bb_admin/src/domain/online_database_facade.dart';

class GetUserUpdateStreamUsecase {
  final OnlineDatabaseFacade _onlineDatabaseFacade;

  const GetUserUpdateStreamUsecase(this._onlineDatabaseFacade);

  Stream<UserEntity> execute() {
    return _onlineDatabaseFacade.userUpdates();
  }
}
