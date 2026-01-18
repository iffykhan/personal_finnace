import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/models/dashboard_page/account_model.dart';

bool isSubmitted=false;
addTransferTransaction(Account senderAccount, Account receieverAccount,
    String amount, BuildContext context) async {
      if(isSubmitted) return;
      isSubmitted = true;
      try {
        final user = FirebaseAuth.instance.currentUser;
        if(user==null) throw 'User not logged in';
        // await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('accounts').doc(senderAccount.name).set({
        //   'balance':
        // });
        print(senderAccount.balance);
      } catch (e) {
        
      }
      finally{
        isSubmitted = false;
      }
    }
