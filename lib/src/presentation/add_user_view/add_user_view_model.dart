import 'package:bb_admin/src/domain/entities/user_entity.dart';
import 'package:bb_admin/src/domain/usecases/add_new_user_usecase.dart';
import 'package:bb_admin/src/domain/usecases/get_server_info_usecase.dart';
import 'package:bb_admin/src/domain/usecases/update_user_usecase.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bb_admin/src/domain/entities/server_info_entity.dart';

class AddUserViewModel {
  final AddNewUserUsecase _addNewUserUsecase;
  final UpdateUserUsecase _updateUserUsecase;
  final GetServerInfoUsecase _getServerInfoUsecase;
  final BehaviorSubject<AddUserViewState> _stateSubject =
      BehaviorSubject.seeded(AddUserViewInitial());

  AddUserViewModel(this._addNewUserUsecase, this._getServerInfoUsecase,
      this._updateUserUsecase);

  ValueStream<AddUserViewState> get stateStream => _stateSubject;

  Future<void> submitUserDetails(UserEntity user,
      {required bool shouldUpdate}) async {
    final serverInfo = (_stateSubject.value as AddUserViewLoaded).entity;
    _stateSubject.add(AddUserViewLoaded(entity: serverInfo, isLoading: true));
    try {
      if (shouldUpdate) {
        await _updateUserUsecase.execute(user);
      } else {
        await _addNewUserUsecase.execute(user);
      }
      _stateSubject.add(AddUserViewAdded());
    } catch (e) {
      _stateSubject.add(AddUserViewError(e.toString()));
    }
  }

  Future<void> getServerInfo() async {
    try {
      final entity = await _getServerInfoUsecase.execute();
      _stateSubject.add(AddUserViewLoaded(entity: entity, isLoading: false));
    } catch (e) {
      _stateSubject.add(AddUserViewError(e.toString()));
    }
  }

  void dispose() {}
}

abstract class AddUserViewState {}

class AddUserViewInitial implements AddUserViewState {}

class AddUserViewAdded implements AddUserViewState {}

class AddUserViewError implements AddUserViewState {
  final String error;

  const AddUserViewError(this.error);
}

class AddUserViewLoaded implements AddUserViewState {
  final bool isLoading;
  final ServerInfoEntity entity;
  const AddUserViewLoaded({
    required this.isLoading,
    required this.entity,
  });
}
