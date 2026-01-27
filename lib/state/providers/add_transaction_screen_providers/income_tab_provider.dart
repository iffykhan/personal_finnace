import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance/models/dashboard_page/account_model.dart';

final isLoadingIncomeProvider = StateProvider<bool>((ref){
  return false;
});


final categoryIncomeProvider = StateProvider.autoDispose<String>((ref){
  return 'Select a Category';
});

final accountIncomeProvider =
    StateProvider.autoDispose<Account?>((ref) => null);

final textEditingControllerProviderOfIncome = Provider.autoDispose<TextEditingController>((ref){
  return TextEditingController();
});