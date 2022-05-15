import 'dart:async';
import 'dart:developer';
import 'package:bb_admin/src/domain/usecases/get_server_info_usecase.dart';
import 'package:bb_admin/src/domain/usecases/get_user_update_stream.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';
import 'package:bb_admin/src/domain/entities/user_entity.dart';
import 'package:bb_admin/src/domain/usecases/get_all_users_usecase.dart';
import 'home_view_state.dart';

class HomeViewModel {
  final List<UserEntity> _baseUserList = List.empty(growable: true);
  final List<UserEntity> _remainingUserList = List.empty(growable: true);
  final GetAllUsersUsecase _getAllUsersUsecase;
  GetServerInfoUsecase _getServerInfoUsecase;
  final GetUserUpdateStreamUsecase _getUserUpdateStreamUsecase;
  final List<String> _servers = ['All Servers'];
  final List<String> _donorRoles = ['All Users'];
  final List<String> _roles = ['All Roles'];
  String serverSort = 'All Servers';
  String donorSort = 'All Users';
  String rolesSort = 'All Roles';

  final BehaviorSubject<HomeViewState> _stateSubject =
      BehaviorSubject.seeded(HomeViewInitial());
  late StreamSubscription<UserEntity> _userSub;

  HomeViewModel(this._getAllUsersUsecase, this._getUserUpdateStreamUsecase,
      this._getServerInfoUsecase) {
    _loadItems().then((value) => _updateUsers());
  }

  ValueStream<HomeViewState> get stateStream => _stateSubject;

  Future<void> _loadItems() async {
    _stateSubject.add(HomeViewLoading());
    try {
      final res = await _getAllUsersUsecase.execute();
      final servDetaisl = await _getServerInfoUsecase.execute();
      _servers.addAll(servDetaisl.servers);
      _roles.addAll(servDetaisl.roles);
      _donorRoles.addAll(servDetaisl.donorRoles);
      _baseUserList.addAll(res);
      _remainingUserList.addAll(res);
      _stateSubject.add(
        HomeViewLoaded(
          currentDRole: donorSort,
          currentRole: rolesSort,
          currentServer: serverSort,
          users: _remainingUserList,
          servers: _servers,
          roles: _roles,
          dRoles: _donorRoles,
        ),
      );
    } catch (e) {
      _stateSubject.add(
        HomeViewError(
          error: e.toString(),
        ),
      );
    }
  }

  void restoreList() {
    _remainingUserList.clear();
    _remainingUserList.addAll(_baseUserList);
    donorSort = 'All Users';
    rolesSort = 'All Roles';
    serverSort = 'All Servers';
    _stateSubject.add(
      HomeViewLoaded(
        currentDRole: donorSort,
        currentRole: rolesSort,
        currentServer: serverSort,
        users: _remainingUserList,
        servers: _servers,
        roles: _roles,
        dRoles: _donorRoles,
      ),
    );
  }

  void queryList(String query) {
    _remainingUserList.clear();
    final length = _baseUserList.length;
    for (int i = 0; i < length; i++) {
      final user = _baseUserList[i];
      if (user.discordName.contains(query) || user.plexId.contains(query)) {
        _remainingUserList.add(user);
      }
    }
    donorSort = 'All Users';
    rolesSort = 'All Roles';
    serverSort = 'All Servers';
    _stateSubject.add(
      HomeViewLoaded(
        currentDRole: donorSort,
        currentRole: rolesSort,
        currentServer: serverSort,
        users: _remainingUserList,
        servers: _servers,
        roles: _roles,
        dRoles: _donorRoles,
      ),
    );
  }

  void sortparameter({
    String? dRole,
    String? role,
    String? server,
  }) {
    if (dRole != null) {
      donorSort = dRole;
    }
    if (role != null) {
      rolesSort = role;
    }
    if (server != null) {
      serverSort = server;
    }
    _sortList();
  }

  void _sortList() {
    _remainingUserList.clear();
    _remainingUserList.addAll(_baseUserList);
    if (serverSort == 'All Servers' &&
        rolesSort == 'All Roles' &&
        donorSort == 'All Users') {
      _stateSubject.add(
        HomeViewLoaded(
          currentDRole: donorSort,
          currentRole: rolesSort,
          currentServer: serverSort,
          users: _remainingUserList,
          servers: _servers,
          roles: _roles,
          dRoles: _donorRoles,
        ),
      );
      return;
    }

    if (serverSort != 'All Servers') {
      for (int i = 0; i < _remainingUserList.length; i++) {
        _remainingUserList
            .removeWhere((element) => !element.servers.contains(serverSort));
      }
    }

    if (donorSort != 'All Users') {
      for (int i = 0; i < _remainingUserList.length; i++) {
        _remainingUserList
            .removeWhere((element) => element.donorRole != donorSort);
      }
    }
    if (rolesSort != 'All Roles') {
      for (int i = 0; i < _remainingUserList.length; i++) {
        _remainingUserList
            .removeWhere((element) => !element.roles.contains(rolesSort));
      }
    }

    _stateSubject.add(
      HomeViewLoaded(
        currentDRole: donorSort,
        currentRole: rolesSort,
        currentServer: serverSort,
        users: _remainingUserList,
        servers: _servers,
        roles: _roles,
        dRoles: _donorRoles,
      ),
    );
    log(_remainingUserList.length.toString());
    _stateSubject.add(
      HomeViewLoaded(
        currentDRole: donorSort,
        currentRole: rolesSort,
        currentServer: serverSort,
        users: _remainingUserList,
        servers: _servers,
        roles: _roles,
        dRoles: _donorRoles,
      ),
    );
  }

  void _updateUsers() {
    _userSub = _getUserUpdateStreamUsecase.execute().listen((event) {
      if (_doesContain(event)) {
        int index = _baseUserList
            .indexWhere((element) => element.discordId == event.discordId);
        _baseUserList.removeAt(index);
        _baseUserList.add(event);
      } else {
        _baseUserList.add(event);
      }
      _remainingUserList.clear();
      _remainingUserList.addAll(_baseUserList);
      _stateSubject.add(
        HomeViewLoaded(
          currentDRole: donorSort,
          currentRole: rolesSort,
          currentServer: serverSort,
          users: _remainingUserList,
          servers: _servers,
          roles: _roles,
          dRoles: _donorRoles,
        ),
      );
    });
  }

  bool _doesContain(UserEntity user) {
    bool contain = false;
    _baseUserList.forEach((element) {
      if (element.discordId == user.discordId) {
        contain = true;
      }
    });
    return contain;
  }

  void dispose() {
    print('called close');
    _userSub.cancel();
    _stateSubject.close();
  }
}
