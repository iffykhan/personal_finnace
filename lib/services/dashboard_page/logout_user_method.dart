import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance/routes/screen_routes.dart';
import 'package:personal_finance/state/providers/dashboard_providers.dart';

logout(BuildContext context, WidgetRef ref) async {
  try {
    await FirebaseAuth.instance.signOut();
    // Dispose the old account stream so it won't be stuck with an old UID after logout
    ref.invalidate(accountStreamProvider);
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, RouteName.loginScreen);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to Logout: $e')),
    );
  }
}
