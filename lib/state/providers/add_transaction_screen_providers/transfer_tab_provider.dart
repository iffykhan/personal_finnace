import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance/models/dashboard_page/account_model.dart';


final transactionSelectionProviderOfSenderAccount = StateProvider.autoDispose<Account?>((ref) =>
  null
);

final transactionSelectionProviderOfReceiverAccount = StateProvider.autoDispose<Account?>((ref) =>
  null
);

final textEditingControllerProviderOfTransfer = Provider.autoDispose<TextEditingController>((ref){
  return TextEditingController();
});