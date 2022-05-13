import 'package:bb_admin/src/domain/entities/user_entity.dart';
import 'package:bb_admin/src/domain/online_database_facade.dart';

class AddNewUserUsecase {
  final OnlineDatabaseFacade _databaseFacade;

  const AddNewUserUsecase(this._databaseFacade);

  Future<void> execute(UserEntity user) {
    return _databaseFacade.addUser(user);
  }
}
