import 'package:bb_admin/src/domain/entities/auth_entity.dart';
import 'package:bb_admin/src/domain/usecases/authenticate_user_usecase.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

class LoginViewModel {
  final AuthenticateUserUsecase _authenticateUserUsecase;
  final BehaviorSubject<LoginViewState> _stateSubject =
      BehaviorSubject.seeded(LoginViewInitial());

  LoginViewModel(this._authenticateUserUsecase);
  ValueStream<LoginViewState> get stateStream => _stateSubject;

  Future<void> logIn(AuthEntity entity) async {
    _stateSubject.add(LoginViewLoading());
    try {
      await _authenticateUserUsecase.execute(entity);
      _stateSubject.add(LoginViewLoggedIn());
    } catch (e) {
      _stateSubject.add(LoginViewError(error: e.toString()));
    }
  }

  void dispose() {
    _stateSubject.close();
  }
}

abstract class LoginViewState {}

class LoginViewLoading implements LoginViewState {}

class LoginViewError implements LoginViewState {
  final String error;
  const LoginViewError({
    required this.error,
  });
}

class LoginViewLoggedIn implements LoginViewState {}

class LoginViewInitial implements LoginViewState {}
