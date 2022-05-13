import 'package:bb_admin/src/domain/entities/server_info_entity.dart';
import 'package:bb_admin/src/domain/online_database_facade.dart';

class GetServerInfoUsecase {
  final OnlineDatabaseFacade _onlineDatabaseFacade;

  const GetServerInfoUsecase(this._onlineDatabaseFacade);

  Future<ServerInfoEntity> execute() {
    return _onlineDatabaseFacade.getServerInfo();
  }
}
