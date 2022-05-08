import 'package:bb_admin/src/domain/usecases/authenticate_user_usecase.dart';

class LoginViewModel {
  final AuthenticateUserUsecase _authenticateUserUsecase;

  const LoginViewModel(this._authenticateUserUsecase);
}
