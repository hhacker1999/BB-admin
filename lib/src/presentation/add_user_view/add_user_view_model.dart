import 'dart:developer';

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
    _stateSubject.add(AddUserViewLoading());
    try {
      if (shouldUpdate) {
        await _updateUserUsecase.execute(user);
      } else {
        await _addNewUserUsecase.execute(user);
      }
      _stateSubject.add(AddUserViewAdded());
    } catch (e) {
      log(e.toString());
      _stateSubject.add(AddUserViewError(e.toString()));
    }
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

class AddUserViewError implements AddUserViewState {
  final String error;

  const AddUserViewError(this.error);
}

class AddUserViewLoaded implements AddUserViewState {
  final ServerInfoEntity entity;
  const AddUserViewLoaded({
    required this.entity,
  });
}
