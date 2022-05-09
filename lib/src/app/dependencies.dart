import 'package:appwrite/appwrite.dart';
import 'package:bb_admin/src/data/online_database_implementation.dart';
import 'package:bb_admin/src/domain/online_database_facade.dart';
import 'package:bb_admin/src/domain/usecases/authenticate_user_usecase.dart';
import 'package:bb_admin/src/domain/usecases/get_all_users_usecase.dart';
import 'package:bb_admin/src/domain/usecases/is_logged_in_usecase.dart';
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

  AppDependencies(this._sharedPreferences) {
    // Plugins
    _client = Client();

    // Facade
    _onlineDatabaseFacade =
        MockOnlineDatabaseImplementation();

    // Usecases
    _getAllUsersUsecase = GetAllUsersUsecase(_onlineDatabaseFacade);
    _authenticateUserUsecase = AuthenticateUserUsecase(_onlineDatabaseFacade);
    _isLoggedInUsecase = IsLoggedInUsecase(_onlineDatabaseFacade);
  }

  // Getters
  GetAllUsersUsecase get getAllUsersUsecase => _getAllUsersUsecase;
  AuthenticateUserUsecase get authenticateUserUsecase =>
      _authenticateUserUsecase;
  IsLoggedInUsecase get isLoggedInUsecase => _isLoggedInUsecase;
}
