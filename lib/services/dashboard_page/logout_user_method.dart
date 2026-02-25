import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance/routes/screen_routes.dart';
import 'package:personal_finance/state/providers/account_detail_screen_provider.dart';
import 'package:personal_finance/state/providers/dashboard_providers.dart';

Future<void> logout(BuildContext context, WidgetRef ref) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text(
            'Logout',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );

  if (confirm != true) return;
  final authStateProvider = StreamProvider<User?>(
    (ref) => FirebaseAuth.instance.authStateChanges(),
  );
  await FirebaseAuth.instance.signOut();
  // Clear Riverpod auth cache after logout 
  ref.invalidate(authStateProvider);
  ref.invalidate(transactionProvider);
  ref.invalidate(accountStreamProvider);

  if (!context.mounted) return;

  Navigator.of(context).pushNamedAndRemoveUntil(
    RouteName.loginScreen,
    (route) => false,
  );
}
