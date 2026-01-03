import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/models/dashboard_page/account_model.dart';
import 'package:personal_finance/routes/screen_routes.dart';

deleteAccount(BuildContext context,Account account) {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'User not logged in';
      
     FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('accounts').doc(account.id).delete();

      Navigator.pushReplacementNamed(context, RouteName.dashboardScreen);
      

    } catch (e) {
      if(!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to add account: $e')),
    );
    }
   }