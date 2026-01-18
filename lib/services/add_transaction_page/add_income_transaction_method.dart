import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

bool isSubmitted = false;
Future<void> addIncomeTransaction(String selectedAccount,
    String selectedCategory, String amount, BuildContext context) async {
  if (isSubmitted) return;
  isSubmitted = true;

  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw 'User not logged in';
    if(selectedAccount == 'Select an account' || selectedCategory == 'Select a Category') throw 'Category or Account not selected';
    final parsedAmount = int.tryParse(amount);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .add({
      'category': selectedCategory,
      'account': selectedAccount,
      'amount': parsedAmount,
      'createdAt': FieldValue.serverTimestamp(),
      'type': 'income'
    });

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction successfully added')));
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Transaction unsuccessful  $e')));
  } finally {
    isSubmitted = false;
  }
}
