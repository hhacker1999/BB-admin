import 'package:bb_admin/src/domain/online_database_facade.dart';

class IsLoggedInUsecase {
  final OnlineDatabaseFacade _onlineDatabaseFacade;

  const IsLoggedInUsecase(this._onlineDatabaseFacade);
  Future<bool> execute() {
    return _onlineDatabaseFacade.isSignedIn();
  }
}
