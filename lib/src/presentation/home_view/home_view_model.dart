import 'package:bb_admin/src/domain/entities/auth_entity.dart';
import 'package:bb_admin/src/domain/usecases/authenticate_user_usecase.dart';
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
  final AuthenticateUserUsecase _authenticateUserUsecase;
  final BehaviorSubject<HomeViewState> _stateSubject =
      BehaviorSubject.seeded(HomeViewInitial());

  HomeViewModel(this._getAllUsersUsecase, this._authenticateUserUsecase) {
    _authenticateUserUsecase
        .execute(const AuthEntity(
            url: 'http://192.168.0.161',
            email: 'harsh@test.com',
            password: 'golusadh'))
        .then((_) => _loadItems());
  }

  ValueStream<HomeViewState> get stateStream => _stateSubject;

  Future<void> _loadItems() async {
    _stateSubject.add(HomeViewLoading());
    try {
      final res = await _getAllUsersUsecase.execute();
      print(res);
      res.forEach(
        (element) {
          if (element.isDonor &&
              _isNearExpiration(element.pastDonations.last)) {
            _nearExpireUserList.add(element);
          } else {
            _remainingUserList.add(element);
          }
        },
      );
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

  bool _isNearExpiration(DateTime lastDono) {
    final currentDate = DateTime.now();
    final daysLeft = currentDate.compareTo(lastDono);
    return daysLeft <= 2;
  }

  void dispose() {
    _stateSubject.close();
  }
}
