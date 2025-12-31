import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance/routes/screen_routes.dart';
import '../../models/dashboard_page/account_model.dart';



class AccountDetailScreen extends ConsumerWidget {
  final Account account;

  const AccountDetailScreen({
    super.key,required this.account
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
        actions: [
          IconButton( onPressed:()=> deleteAccount(context), icon: Icon(Icons.delete))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          /// Balance
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Total Balance',
              style: TextStyle(
                color: Colors.deepPurple.shade400,
                fontSize: 18,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '\$ ${account.balance.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.deepPurple,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// Transactions
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
  
   deleteAccount(BuildContext context) {
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
  
}

