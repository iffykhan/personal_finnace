// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// bool isSubmitted = false;
// Future<void> addIncomeTransaction(String selectedAccount,
//     String selectedCategory, String amount, BuildContext context) async {
//   if (isSubmitted) return;
//   isSubmitted = true;

//   try {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) throw 'User not logged in';
//     if(selectedAccount == 'Select an account' || selectedCategory == 'Select a Category') throw 'Category or Account not selected';
//     final parsedAmount = int.tryParse(amount);
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('transactions')
//         .add({
//       'category': selectedCategory,
//       'account': selectedAccount,
//       'amount': parsedAmount,
//       'createdAt': FieldValue.serverTimestamp(),
//       'type': 'income'
//     });

//     if (!context.mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Transaction successfully added')));
//     Navigator.pop(context);
//   } catch (e) {
//     if (!context.mounted) return;
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text('Transaction unsuccessful  $e')));
//   } finally {
//     isSubmitted = false;
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/models/dashboard_page/account_model.dart';


Future<void> addIncomeTransaction(Account selectedAccount,
    String selectedCategory, int amount, BuildContext context) async {


    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw 'User not logged in';

          if (selectedAccount.name == 'Select an account' ||
          selectedCategory == 'Select a Category') {
        throw 'Category or Account not selected';
      }

    final accountRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('accounts')
        .doc(selectedAccount.id);

    final transactionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .doc();

    final firestore = FirebaseFirestore.instance;

    await firestore.runTransaction((transaction) async {
      final accountSnap = await transaction.get(accountRef);


      if (!accountSnap.exists) {
        throw 'Account not found';
      }

      final accountBlanace = accountSnap['balance'] as int;


      transaction.update(accountRef, {
        'balance': accountBlanace+amount
      });

      transaction.set(transactionRef, {
        'accountId': selectedAccount.id,
        'accountName': selectedAccount.name,
        'category': selectedCategory,
        'amount': amount,
        'createdAt': FieldValue.serverTimestamp(),
        'type': 'expense',
      });
    });


 

}

