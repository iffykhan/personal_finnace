import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_finance/models/dashboard_page/account_model.dart';

Future<void> addExpenseTransaction(Account selectedAccount,
    String selectedCategory, int amount) async {

  
  
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


            if (accountBlanace < amount) {
        throw 'Insufficient balance';
      }

      transaction.update(accountRef, {
        'balance': accountBlanace-amount
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

