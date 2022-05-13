import 'dart:async';
import 'dart:developer';
import 'package:bb_admin/src/domain/usecases/get_user_update_stream.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';
import 'package:bb_admin/src/domain/entities/user_entity.dart';
import 'package:bb_admin/src/domain/usecases/get_all_users_usecase.dart';
import 'home_view_state.dart';

class HomeViewModel {
  final List<UserEntity> _baseUserList = List.empty(growable: true);
  final List<UserEntity> _nearExpireUserList = List.empty(growable: true);
  final List<UserEntity> _remainingUserList = List.empty(growable: true);
  final GetAllUsersUsecase _getAllUsersUsecase;
  final GetUserUpdateStreamUsecase _getUserUpdateStreamUsecase;
  final BehaviorSubject<HomeViewState> _stateSubject =
      BehaviorSubject.seeded(HomeViewInitial());
  late StreamSubscription<UserEntity> _userSub;

  HomeViewModel(this._getAllUsersUsecase, this._getUserUpdateStreamUsecase) {
    _loadItems().then((value) => _updateUsers());
  }

  ValueStream<HomeViewState> get stateStream => _stateSubject;

  Future<void> _loadItems() async {
    _stateSubject.add(HomeViewLoading());
    try {
      final res = await _getAllUsersUsecase.execute();
      _baseUserList.addAll(res);
      _segregateUsersOnDifferentLists();
      _stateSubject.add(
        HomeViewLoaded(
            expiredDonors: _nearExpireUserList, users: _remainingUserList),
      );
    } catch (e) {
      _stateSubject.add(
        HomeViewError(
          error: e.toString(),
        ),
      );
    }
  }

  void _segregateUsersOnDifferentLists() {
    if (_nearExpireUserList.isNotEmpty) {
      _nearExpireUserList.removeRange(0, _nearExpireUserList.length);
    }
    if (_remainingUserList.isNotEmpty) {
      _remainingUserList.removeRange(0, _remainingUserList.length);
      log(_remainingUserList.length.toString());
    }
    _baseUserList.forEach((element) {
      // if (element.isDonor && element.validity <= 2) {
      _remainingUserList.add(element);
      // log('element added here');
      // } else {
      // _remainingUserList.add(element);
      // log(_remainingUserList.toString());
      // }
    });
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
      _segregateUsersOnDifferentLists();
      _stateSubject.add(
        HomeViewLoaded(
            expiredDonors: _nearExpireUserList, users: _remainingUserList),
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
