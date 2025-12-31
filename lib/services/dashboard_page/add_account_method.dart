import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

bool _isSubmitting = false;

Future<void> addAccount({
  required WidgetRef ref,
  required BuildContext context,
  required String name,
  required double balance,
}) async {
  if (_isSubmitting) return; // prevent duplicate taps
  _isSubmitting = true;

  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw 'User not logged in';

    if(!context.mounted) return; 
    Navigator.pop(context);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('accounts')
        .add({
      'name': name,
      'balance': balance,
    });
    
  } catch (e) {
    if(!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to add account: $e')),
    );
  } finally {
    _isSubmitting = false;
  }
}
