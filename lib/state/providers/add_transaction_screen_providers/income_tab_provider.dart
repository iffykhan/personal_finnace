import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance/models/add_transaction_page/transaction_selection_model.dart';


final transactionSelectionProviderOfIncome = StateProvider.autoDispose<TransactionSelection>((ref){
  return TransactionSelection(account: 'Select an account', category: 'Select a Category');
});

final textEditingControllerProviderOfIncome = Provider.autoDispose<TextEditingController>((ref){
  return TextEditingController();
});