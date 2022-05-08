import '../../domain/usecases/is_logged_in_usecase.dart';

class SplashViewModel {
  final IsLoggedInUsecase _isLoggedInUsecase;

  const SplashViewModel(this._isLoggedInUsecase);
}