import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance/models/add_transaction_page/transaction_selection_model.dart';
import 'package:personal_finance/services/add_transaction_page/add_income_transaction_method.dart';
import 'package:personal_finance/state/providers/add_transaction_screen_providers/income_tab_provider.dart';
import 'package:personal_finance/state/providers/dashboard_providers.dart';
import 'package:personal_finance/ui/widgets/custom_textformfeild.dart';

class Incometab extends ConsumerWidget {
  const Incometab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amount = ref.watch(textEditingControllerProviderOfIncome);
    final formkey = GlobalKey<FormState>();
    final transactionSelection = ref.watch(transactionSelectionProviderOfIncome);
    final List<String> categoryList = [
      'Salary',
      'Business',
      'Freelance',
      'Bonus',
      'Investment',
      'Rental Income',
      'Interest',
      'Commission',
      'Gift',
      'Refund',
      'Other',
    ];
    final account = ref.watch(accountStreamProvider);
    return account.when(
        data: (account) {
          final accountList = account.map((account) => account.name).toList();

          return Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Form(
                  key:formkey,
                  child: CustomTextFormFeild(
                      controller: amount,
                      autofocus: true,
                      inputformatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(8)
                      ],
                      hint: 'Add amount',
                      isPassword: false,
                      keyboardType: TextInputType.number,
                      validator: amountValidator),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                Colors.deepPurple),
                            foregroundColor:
                                WidgetStateProperty.all<Color>(Colors.white)),
                        onPressed: () {
                          if(!formkey.currentState!.validate()) return;
                          final selection= ref.read(transactionSelectionProviderOfIncome);
                          addIncomeTransaction(selection.account, selection.category, amount.text, context);
                        },
                        child: Text('Add transaction'))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Consumer(
                      builder:
                          (BuildContext context, WidgetRef ref, Widget? child) {
                        return TextButton(
                            onPressed: () => accountClicked(context,
                                accountList, transactionSelection, ref),
                            child: Column(
                              children: [
                                Text('Account'),
                                Text(
                                  transactionSelection.account,
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            ));
                      },
                    ),
                    Consumer(
                      builder:
                          (BuildContext context, WidgetRef ref, Widget? child) {
                        return TextButton(
                            onPressed: () => categoryClicked(context,
                                categoryList, transactionSelection, ref),
                            child: Column(
                              children: [
                                Text('Category'),
                                Text(
                                  transactionSelection.category,
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            ));
                      },
                    ),
                  ],
                )
              ],
            ),
          ));
        },
        error: (error, stack) => Center(
              child: Text('Error loading accounts list'),
            ),
        loading: () => Center(
              child: CircularProgressIndicator(),
            ));
  }

  String? amountValidator(String? input) {
    if (input == null || input.isEmpty) {
      return 'Enter amount';
    }
    return null;
  }

  void categoryClicked(BuildContext context, List categoryList,
      TransactionSelection transactionSelection, WidgetRef ref) {
    showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                    children: categoryList.map((category) {
                  return ListTile(
                    title: Text(category),
                    onTap: () {
                      ref.read(transactionSelectionProviderOfIncome.notifier).state =
                          transactionSelection.copyWith(category: category);
                      Navigator.pop(context, category);
                    },
                  );
                }).toList()),
              ),
            ),
          );
        });
  }

  void accountClicked(BuildContext context, List<String> accountList,
      TransactionSelection transactionSelection, WidgetRef ref) {
    showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: accountList.map((account) {
                    return ListTile(
                      title: Text(account),
                      onTap: () {
                        ref.read(transactionSelectionProviderOfIncome.notifier).state =
                            transactionSelection.copyWith(account: account);
                        Navigator.pop(context, account);
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        });
  }
}
