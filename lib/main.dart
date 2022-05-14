import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bb_admin/src/app/app_routes.dart';
import 'package:bb_admin/src/app/dependencies.dart';
import 'package:bb_admin/src/domain/entities/user_entity.dart';
import 'package:bb_admin/src/presentation/add_user_view/add_user_view.dart';
import 'package:bb_admin/src/presentation/add_user_view/add_user_view_model.dart';
import 'package:bb_admin/src/presentation/home_view/home_view_model.dart';
import 'package:bb_admin/src/presentation/login_view/login_view.dart';
import 'package:bb_admin/src/presentation/login_view/login_view_model.dart';
import 'package:bb_admin/src/presentation/splash_view/splash_view.dart';
import 'package:bb_admin/src/presentation/splash_view/splash_view_model.dart';
import 'package:bb_admin/src/presentation/user_info_view/user_info_view.dart';
import 'package:bb_admin/src/presentation/user_info_view/user_info_view_model.dart';

import 'src/presentation/home_view/home_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(BbAdmin(
    prefs: prefs,
  ));
}

class BbAdmin extends StatefulWidget {
  final SharedPreferences prefs;
  const BbAdmin({super.key, required this.prefs});

  @override
  State<BbAdmin> createState() => _BbAdminState();
}

class _BbAdminState extends State<BbAdmin> {
  late AppDependencies _appDependencies;

  @override
  void initState() {
    super.initState();
    _appDependencies = AppDependencies(widget.prefs);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      initialRoute: AppRoutes.splashRoute,
      onGenerateRoute: (route) {
        switch (route.name) {
          case AppRoutes.loginRoute:
            return MaterialPageRoute(
              builder: (context) => Provider<LoginViewModel>(
                create: (_) =>
                    LoginViewModel(_appDependencies.authenticateUserUsecase),
                child: const LoginView(),
              ),
            );
          case AppRoutes.homeRoute:
            return MaterialPageRoute(
              builder: (context) => Provider<HomeViewModel>(
                create: (_) => HomeViewModel(
                    _appDependencies.getAllUsersUsecase,
                    _appDependencies.getUserUpdateStreamUsecase),
                // dispose: (_, model) => model.dispose(),
                child: const RevisedHomeView(),
              ),
            );
          case AppRoutes.addNewUser:
            UserEntity? user;
            if (route.arguments != null) {
              user = route.arguments as UserEntity;
            }
            return CustomScaleTransition(
              page: Builder(builder: (context) {
                return Provider<AddUserViewModel>(
                  create: (_) => AddUserViewModel(
                      _appDependencies.addNewUserUsecase,
                      _appDependencies.getServerInfoUsecase,
                      _appDependencies.updateUserUsecase)
                    ..getServerInfo(),
                  dispose: (_, model) => model.dispose(),
                  child: AddUserView(
                    enitity: user,
                  ),
                );
              }),
            );
          case AppRoutes.userInfoRoute:
            final user = route.arguments as UserEntity;
            return MaterialPageRoute(
              builder: (context) => Provider<UserInfoViewModel>(
                  create: (_) => UserInfoViewModel(),
                  dispose: (_, model) => model.dispose(),
                  child: UserInfoView(user: user)),
            );
          case AppRoutes.splashRoute:
          default:
            return MaterialPageRoute(
              builder: (context) => Provider<SplashViewModel>(
                dispose: (_, model) => model.dispose(),
                create: (_) =>
                    SplashViewModel(_appDependencies.isLoggedInUsecase)
                      ..checkLoginState(),
                child: const SplashView(),
              ),
            );
        }
      },
    );
  }
}

class CustomScaleTransition extends PageRouteBuilder {
  final Widget page;
  CustomScaleTransition({
    required this.page,
  }) : super(
            pageBuilder: (_, __, ___) => page,
            transitionDuration: const Duration(milliseconds: 1500),
            reverseTransitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (_, animation, __, child) {
              animation = CurvedAnimation(
                  parent: animation,
                  curve: Curves.fastLinearToSlowEaseIn,
                  reverseCurve: Curves.fastOutSlowIn);
              return ScaleTransition(
                alignment: Alignment.centerRight,
                scale: animation,
                child: child,
              );
            });
}
