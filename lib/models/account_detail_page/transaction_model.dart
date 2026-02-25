
import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { 
  expense,
  income,
  transfer
}

class TransactionModel {
  final String accountName;
  final String category;
  final double amount;
  final DateTime createdAt;
  final TransactionType type;

  final String? accountId;

  final String? senderAccount;
  final String? receieverAccount;

  TransactionModel({
    required this.accountName,
    required this.category,
    required this.amount,
    required this.createdAt,
    required this.type,

    this.accountId,
    this.receieverAccount,
    this.senderAccount
    });
   
   Map<String,dynamic> toJson(){
    return {
      'accountName' : accountName,
      'category' : category,
      'amount' : amount,
      'createdAt' : createdAt,
      'type' : type.name,
      'accountId' : accountId,
      'receieverAccount' : receieverAccount,
      'senderAccount' : senderAccount
    };
   }

   factory TransactionModel.fromJSon(Map<String,dynamic> map){
    return TransactionModel(
      accountName: map['accountName'] ?? '' ,
      // with the safety i was getting the error that null is not the sub type of string
      category: map['category'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      type: TransactionType.values.byName(map['type']),
      accountId: map['accountId'] ,
      receieverAccount: map['receiverAccount'],
      senderAccount: map['senderAccount']
      );
   }


}