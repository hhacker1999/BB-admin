import 'package:bb_admin/src/domain/entities/user_entity.dart';
import 'package:bb_admin/src/domain/usecases/add_new_user_usecase.dart';
import 'package:bb_admin/src/domain/usecases/get_server_info_usecase.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bb_admin/src/domain/entities/server_info_entity.dart';

class AddUserViewModel {
  final AddNewUserUsecase _addNewUserUsecase;
  final GetServerInfoUsecase _getServerInfoUsecase;
  final BehaviorSubject<AddUserViewState> _stateSubject =
      BehaviorSubject.seeded(AddUserViewInitial());

  AddUserViewModel(this._addNewUserUsecase, this._getServerInfoUsecase);

  ValueStream<AddUserViewState> get stateStream => _stateSubject;

  Future<void> submitUserDetails(UserEntity user) async {
    _stateSubject.add(AddUserViewLoading());
    await _addNewUserUsecase.execute(user);
    _stateSubject.add(AddUserViewAdded());
  }

  Future<void> getServerInfo() async {
    _stateSubject.add(AddUserViewLoading());
    final entity = await _getServerInfoUsecase.execute();
    _stateSubject.add(AddUserViewLoaded(entity: entity));
  }

  void dispose() {}
}

abstract class AddUserViewState {}

class AddUserViewLoading implements AddUserViewState {}

class AddUserViewInitial implements AddUserViewState {}

class AddUserViewAdded implements AddUserViewState {}

class AddUserViewLoaded implements AddUserViewState {
  final ServerInfoEntity entity;
  const AddUserViewLoaded({
    required this.entity,
  });
}
