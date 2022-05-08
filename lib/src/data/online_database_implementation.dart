import 'package:appwrite/appwrite.dart';
import 'package:bb_admin/src/app/app_constants.dart';
import 'package:bb_admin/src/domain/entities/user_entity.dart';
import 'package:bb_admin/src/domain/entities/server_info_entity.dart';
import 'package:bb_admin/src/domain/entities/auth_entity.dart';
import 'package:bb_admin/src/domain/online_database_facade.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnlineDatabaseImplementation implements OnlineDatabaseFacade {
  final SharedPreferences _sharedPreferences;
  final Client _client;
  late Account _account;
  late Database _database;

  OnlineDatabaseImplementation(this._client, this._sharedPreferences) {
    _account = Account(_client);
    _database = Database(_client);
  }

  @override
  Future<void> addUser(UserEntity user) async {
    final Map<String, dynamic> map = user.toMap();
    try {
      await _database.createDocument(
          collectionId: AppConstants.usersCollectionId,
          documentId: 'unique()',
          data: map);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> authenticateUser(AuthEntity auth) async {
    final bool isSsl = auth.url.contains('https');
    try {
      _client
          .setEndpoint('${auth.url}/v1')
          .setProject(AppConstants.projectId)
          .setSelfSigned(status: isSsl);
      await Account(_client)
          .createSession(email: auth.email, password: auth.password);
      await _sharedPreferences.setBool('isLoggedIn', true);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<List<UserEntity>> getAllUsers() async {
    try {
      final res = await _database.listDocuments(
          collectionId: AppConstants.usersCollectionId);
      final docList = res.documents;
      final list = docList.map((user) {
        final userMap = user.data;
        userMap['documentId'] = user.$id;
        return UserEntity.fromMap(userMap);
      }).toList();
      print(list.length);
      return list;
    } catch (e) {
      var err = 'error is this' + e.toString();
      print(err);
      rethrow;
    }
  }

  @override
  Future<ServerInfoEntity> getServerInfo() async {
    try {
      final res = await _database.listDocuments(
          collectionId: AppConstants.serverCollectionId);
      final doc = res.documents[0];
      return ServerInfoEntity.fromMap(doc.data);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final map = user.toMap();
    try {
      await _database.updateDocument(
          collectionId: AppConstants.usersCollectionId,
          documentId: user.documentId,
          data: map);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<bool> isSignedIn() async {
    final bool isNew = !_sharedPreferences.containsKey('isLoggedIn');
    if (isNew) {
      return false;
    }

    return _sharedPreferences.getBool('isLoggedIn')!;
  }

  @override
  Future<void> logOut() async {
    try {
      final ses = await _account.getSession(sessionId: 'current');
      await _account.deleteSession(sessionId: ses.$id);
    } catch (e) {
      print(e.toString());
    }
  }
}
