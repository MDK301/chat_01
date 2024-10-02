import 'package:chat_01/routes/route_name.dart';
import 'package:flutter/material.dart';
import '../ui/createaccount.dart';
import '../ui/dash_board.dart';
import '../ui/login.dart';
import '../ui/splash/splash_screen.dart';


class Routes {

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case RouteName.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case RouteName.loginView:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RouteName.CreateAccount:
        return MaterialPageRoute(builder: (_) => const CreateAccount());
      case RouteName.DashBoard:
        return MaterialPageRoute(builder: (_) => const DashBoard());


      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}