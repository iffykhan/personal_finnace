import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/models/dashboard_page/account_model.dart';


addTransferTransaction(Account senderAccount, Account receieverAccount,
    int amount, BuildContext context) async {


    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) throw Exception('User not logged in');

    final senderRef = firestore
        .collection('users')
        .doc(user.uid)
        .collection('accounts')
        .doc(senderAccount.id);

    final receiverRef = firestore
        .collection('users')
        .doc(user.uid)
        .collection('accounts')
        .doc(receieverAccount.id);

    await firestore.runTransaction((transaction) async {
      final senderSnapshot = await transaction.get(senderRef);
      final receiverSnapshot = await transaction.get(receiverRef);

      final senderBalance = await senderSnapshot['balance'] as int;
      final receiverBalance = await receiverSnapshot['balance'] as int;

      if (senderBalance < amount) {
        throw Exception('Sender account balance is less then amount');
      }

      transaction.update(senderRef, {'balance': senderBalance - amount});
      transaction.update(receiverRef, {'balance': receiverBalance + amount});
    });

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .add({
      'senderAccount': senderAccount.name,
      'receiverAccount': receieverAccount.name,
      'amount': amount,
      'createdAt': FieldValue.serverTimestamp(),
      'type': 'transfer'
    });


}
