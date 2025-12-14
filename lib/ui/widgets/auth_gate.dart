import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance/ui/screens/dashboard_screen.dart';
import 'package:personal_finance/ui/screens/login_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if(!snapshot.hasData){
            return LoginScreen();
          }
          return Dashboard();
        });
  }
}
