import 'package:appwrite/appwrite.dart';
import 'package:bb_admin/src/data/online_database_implementation.dart';
import 'package:bb_admin/src/domain/online_database_facade.dart';
import 'package:bb_admin/src/domain/usecases/add_new_user_usecase.dart';
import 'package:bb_admin/src/domain/usecases/authenticate_user_usecase.dart';
import 'package:bb_admin/src/domain/usecases/get_all_users_usecase.dart';
import 'package:bb_admin/src/domain/usecases/get_server_info_usecase.dart';
import 'package:bb_admin/src/domain/usecases/get_user_update_stream.dart';
import 'package:bb_admin/src/domain/usecases/is_logged_in_usecase.dart';
import 'package:bb_admin/src/domain/usecases/update_user_usecase.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDependencies {
  // Plugins
  late Client _client;
  final SharedPreferences _sharedPreferences;

  // Facade
  late OnlineDatabaseFacade _onlineDatabaseFacade;

  // Usecases
  late GetAllUsersUsecase _getAllUsersUsecase;
  late IsLoggedInUsecase _isLoggedInUsecase;
  late AuthenticateUserUsecase _authenticateUserUsecase;
  late AddNewUserUsecase _addNewUserUsecase;
  late GetServerInfoUsecase _getServerInfoUsecase;
  late UpdateUserUsecase _updateUserUsecase;
  late GetUserUpdateStreamUsecase _getUserUpdateStreamUsecase;

  AppDependencies(this._sharedPreferences) {
    // Plugins
    _client = Client();

    // Facade
    _onlineDatabaseFacade =
        OnlineDatabaseImplementation(_client, _sharedPreferences);

    // Usecases
    _getAllUsersUsecase = GetAllUsersUsecase(_onlineDatabaseFacade);
    _authenticateUserUsecase = AuthenticateUserUsecase(_onlineDatabaseFacade);
    _isLoggedInUsecase = IsLoggedInUsecase(_onlineDatabaseFacade);
    _addNewUserUsecase = AddNewUserUsecase(_onlineDatabaseFacade);
    _getServerInfoUsecase = GetServerInfoUsecase(_onlineDatabaseFacade);
    _updateUserUsecase = UpdateUserUsecase(_onlineDatabaseFacade);
    _getUserUpdateStreamUsecase =
        GetUserUpdateStreamUsecase(_onlineDatabaseFacade);
  }

  // Getters
  GetAllUsersUsecase get getAllUsersUsecase => _getAllUsersUsecase;
  AuthenticateUserUsecase get authenticateUserUsecase =>
      _authenticateUserUsecase;
  IsLoggedInUsecase get isLoggedInUsecase => _isLoggedInUsecase;
  AddNewUserUsecase get addNewUserUsecase => _addNewUserUsecase;
  GetServerInfoUsecase get getServerInfoUsecase => _getServerInfoUsecase;
  UpdateUserUsecase get updateUserUsecase => _updateUserUsecase;
  GetUserUpdateStreamUsecase get getUserUpdateStreamUsecase =>
      _getUserUpdateStreamUsecase;
}
