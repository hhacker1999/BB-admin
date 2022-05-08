import 'package:bb_admin/src/domain/entities/auth_entity.dart';
import 'package:bb_admin/src/domain/online_database_facade.dart';

class AuthenticateUserUsecase {
  final OnlineDatabaseFacade _onlineDatabaseFacade;

  const AuthenticateUserUsecase(this._onlineDatabaseFacade);
  Future<void> execute(AuthEntity auth) {
    return _onlineDatabaseFacade.authenticateUser(auth);
  }
}
