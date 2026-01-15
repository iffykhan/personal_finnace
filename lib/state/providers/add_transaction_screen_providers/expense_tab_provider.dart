import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance/models/add_transaction_page/transaction_selection_model.dart';


final transactionSelectionProvider = StateProvider<TransactionSelection>((ref){
  return TransactionSelection(account: 'Select an account', category: 'Select a Category');
});