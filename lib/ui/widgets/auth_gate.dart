import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance/state/providers/authgate_provider.dart';
import 'package:personal_finance/ui/screens/dashboard_screen/dashboard_screen.dart';
import 'package:personal_finance/ui/screens/login_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final authGate = ref.watch(authGateProvider);
    return authGate.when(data: (user)
    {
      if(user == null){
      return LoginScreen();
      }
      else {
        return Dashboard();
      }
    }, error: (error,stack)=> Scaffold(
      body: Center(
        child: Text(
            'Error: ${error.toString()}'),),),
        
        loading: ()=> Scaffold(
          body: Center(
            child: CircularProgressIndicator(),),)
    );
  }
}
