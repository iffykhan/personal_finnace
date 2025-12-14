import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/routes/screen_routes.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(title: Text(
          auth.currentUser?.displayName ?? ''),
        actions: [IconButton(onPressed: () => logout(context),
            icon: Icon(Icons.logout))],),
    );
  }

  logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if(!context.mounted) return;
    Navigator.pushReplacementNamed(context, RouteName.loginScreen);
  }
}