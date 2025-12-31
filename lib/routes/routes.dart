import 'package:flutter/material.dart';
import 'package:personal_finance/models/dashboard_page/account_model.dart';
import 'package:personal_finance/routes/screen_routes.dart';
import 'package:personal_finance/ui/screens/account_detail_screen.dart';
import 'package:personal_finance/ui/screens/add_transaction_screen.dart'
    hide Account;
import 'package:personal_finance/ui/screens/dashboard_screen.dart';
import 'package:personal_finance/ui/screens/login_screen.dart';
import 'package:personal_finance/ui/screens/signup_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.loginScreen:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case RouteName.signupScreen:
        return MaterialPageRoute(builder: (context) => SignUpScreen());
      case RouteName.dashboardScreen:
        return MaterialPageRoute(builder: (context) => Dashboard());
      case RouteName.accountDetailScreen:
        final account = settings.arguments as Account; // get the account object
        return MaterialPageRoute(
          builder: (context) =>
              AccountDetailScreen(account: account), // pass it via constructor
        );
      case RouteName.addTransactionScreen:
        return MaterialPageRoute(builder: (context) => AddTransactionScreen());
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
