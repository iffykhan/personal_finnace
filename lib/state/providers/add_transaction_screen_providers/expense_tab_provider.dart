import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance/models/dashboard_page/account_model.dart';

final isLoadingExpenseProvider = StateProvider<bool>((ref){
  return false;
});


final categoryExpenseProvider = StateProvider.autoDispose<String>((ref){
  return 'Select a Category';
});

final accountExpenseProvider =
    StateProvider.autoDispose<Account?>((ref) => null);

final textEditingControllerProviderOfExpense = Provider.autoDispose<TextEditingController>((ref){
  return TextEditingController();
});