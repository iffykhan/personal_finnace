import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:personal_finance/models/account_detail_page/transaction_model.dart';

final authStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

final transactionProvider =
    StreamProvider<List<TransactionModel>>((ref) {

  final auth = ref.watch(authStateProvider).asData?.value;

  if (auth == null) {
    return const Stream<List<TransactionModel>>.empty();
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(auth.uid)
      .collection('transactions')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) =>
              TransactionModel.fromJSon(doc.data()))
          .toList());
});