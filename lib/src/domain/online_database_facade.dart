import 'entities/auth_entity.dart';
import 'entities/server_info_entity.dart';
import 'entities/user_entity.dart';

abstract class OnlineDatabaseFacade {
  Future<bool> isSignedIn();
  Future<void> authenticateUser(AuthEntity auth);
  Future<void> logOut();
  Future<ServerInfoEntity> getServerInfo();
  Future<List<UserEntity>> getAllUsers();
  Future<void> addUser(UserEntity user);
  Future<void> updateUser(UserEntity user);
  Stream<UserEntity> userUpdates();
}
