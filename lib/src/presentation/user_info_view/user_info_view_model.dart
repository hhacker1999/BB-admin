import 'package:bb_admin/src/domain/entities/user_entity.dart';
import 'package:bb_admin/src/domain/usecases/update_user_usecase.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

class UserInfoViewModel {
  final UpdateUserUsecase _updateUserUsecase;
  final BehaviorSubject<UserInfoState> _stateSubject =
      BehaviorSubject.seeded(UserInfoState.initial);

  UserInfoViewModel(this._updateUserUsecase);

  ValueStream<UserInfoState> get stateStream => _stateSubject;

  Future<void> updateUserDetails(UserEntity entity) async {
    _stateSubject.add(UserInfoState.loading);
    try {
      await _updateUserUsecase.execute(entity);
      _stateSubject.add(UserInfoState.updated);
    } catch (e) {
      print(e.toString());
    }
  }

  void dispose() {
    _stateSubject.close();
  }
}

enum UserInfoState {
  initial,
  loading,
  updated,
}
