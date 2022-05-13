import 'package:rxdart/rxdart.dart';

import '../../domain/usecases/is_logged_in_usecase.dart';

class SplashViewModel {
  final IsLoggedInUsecase _isLoggedInUsecase;
  final BehaviorSubject<SplashViewState> _stateSubject =
      BehaviorSubject.seeded(SplashViewLoading());

  SplashViewModel(this._isLoggedInUsecase);

  ValueStream<SplashViewState> get state => _stateSubject;

  Future<void> checkLoginState() async {
    final isLoggedIn = await _isLoggedInUsecase.execute();
    await Future.delayed(const Duration(milliseconds: 2000));
    if (isLoggedIn) {
      _stateSubject.add(SplashViewLoggedIn());
    } else {
      _stateSubject.add(SplashViewLoggedOut());
    }
  }

  void dispose() {
    _stateSubject.close();
  }
}

abstract class SplashViewState {}

class SplashViewLoading implements SplashViewState {}

class SplashViewLoggedIn implements SplashViewState {}

class SplashViewLoggedOut implements SplashViewState {}
