import 'package:appwrite/models.dart';
import 'package:bb_admin/src/domain/entities/user_entity.dart';
import 'package:bb_admin/src/domain/online_database_facade.dart';

class GetAllUsersUsecase {
  final OnlineDatabaseFacade _onlineDatabaseFacade;

  const GetAllUsersUsecase(this._onlineDatabaseFacade);
  Future<List<UserEntity>> execute() {
    return _onlineDatabaseFacade.getAllUsers();
  }
}
