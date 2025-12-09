import 'package:flutter/material.dart';
import 'package:personal_finance/routes/screen_routes.dart';
import 'package:personal_finance/screens/dashboard.dart';
import 'package:personal_finance/screens/login_screen.dart';
import 'package:personal_finance/screens/signup_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.loginScreen:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case RouteName.signupScreen:
        return MaterialPageRoute(builder: (context) => SignUpScreen());
      case RouteName.dashboard:
        return MaterialPageRoute(builder: (context) => Dashboard(uid: settings.arguments as Map));
      default:
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: Center(
                    child: Text('No route found with this name'),
                  ),
                ));
    }
  }
}
