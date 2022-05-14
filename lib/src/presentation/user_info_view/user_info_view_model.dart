import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

class UserInfoViewModel {
  final BehaviorSubject<UserInfoState> _stateSubject =
      BehaviorSubject.seeded(UserInfoState.initial);

  UserInfoViewModel();

  ValueStream<UserInfoState> get stateStream => _stateSubject;


  void dispose() {
    _stateSubject.close();
  }
}

enum UserInfoState {
  initial,
  loading,
  updated,
}
