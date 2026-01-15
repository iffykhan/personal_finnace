import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance/models/dashboard_page/account_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final accountStreamProvider = StreamProvider<List<Account>>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  //(if condition) is used because when logout is pressed and then try to login the uid is empty
  if(uid == null){
    return const Stream<List<Account>>.empty();
  }
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('accounts')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) =>
           Account.fromMap(doc.data(), id: doc.id)).toList());
});



