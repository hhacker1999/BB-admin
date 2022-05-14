import 'dart:developer';
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
  late Realtime _realtime;
  late Account _account;
  late Database _database;

  OnlineDatabaseImplementation(this._client, this._sharedPreferences) {
    _account = Account(_client);
    _database = Database(_client);
    _realtime = Realtime(_client);
  }

  @override
  Future<void> addUser(UserEntity user) async {
    final Map<String, dynamic> map = user.toMap();
    map.remove('documentId');
    map.remove('validity');
    try {
      await _database.createDocument(
          collectionId: AppConstants.usersCollectionId,
          documentId: 'unique()',
          data: map);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> authenticateUser(AuthEntity auth) async {
    try {
      _client.setEndpoint('${auth.url}/v1').setProject(AppConstants.projectId);
      await Account(_client)
          .createSession(email: auth.email, password: auth.password);
      await _sharedPreferences.setBool('isLoggedIn', true);
      await _sharedPreferences.setString('url', auth.url);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserEntity>> getAllUsers() async {
    try {
      final url = _sharedPreferences.getString('url');
      _client.setEndpoint('$url/v1').setProject(AppConstants.projectId);
      final res = await _database.listDocuments(
          collectionId: AppConstants.usersCollectionId);
      final docList = res.documents;
      final list = docList.map((user) {
        final userMap = user.data;
        userMap['documentId'] = user.$id;
        final userEntity = UserEntity.fromMap(userMap);
        if (userEntity.isDonor) {
          final endDate = userEntity.pastDonations!.last
              .add(Duration(days: userEntity.donationDuration!));
          final val = endDate.difference(DateTime.now());
          return userEntity.copyWith(validity: val.inDays);
        } else {
          return userEntity;
        }
      }).toList();
      return list;
    } catch (e) {
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
      rethrow;
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final map = user.toMap();
    // try {
    //   map.remove('validity');
    //   map.remove('documentId');
    //   log(map.toString());
    //   await _database.updateDocument(
    //       collectionId: AppConstants.usersCollectionId,
    //       documentId: user.documentId,
    //       data: map);
    // } catch (e) {
    //   rethrow;
    // }

      map.remove('validity');
      map.remove('documentId');
      await _database.updateDocument(
          collectionId: AppConstants.usersCollectionId,
          documentId: user.documentId,
          data: map);
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
    } catch (_) {
      rethrow;
    }
  }

  @override
  Stream<UserEntity> userUpdates() {
    final sub = _realtime
        .subscribe(['collections.${AppConstants.usersCollectionId}.documents']);
    return sub.stream.map((event) {
      final userEntity = UserEntity.fromMap(event.payload);
      if (userEntity.isDonor) {
        final endDate = userEntity.pastDonations!.last
            .add(Duration(days: userEntity.donationDuration!));
        final val = endDate.difference(DateTime.now());
        return userEntity.copyWith(validity: val.inDays);
      } else {
        return userEntity;
      }
    });
  }
}
