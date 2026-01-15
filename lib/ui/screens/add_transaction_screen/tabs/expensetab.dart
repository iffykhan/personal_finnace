import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance/models/add_transaction_page/transaction_selection_model.dart';
import 'package:personal_finance/state/providers/dashboard_providers.dart';
import 'package:personal_finance/ui/widgets/custom_textformfeild.dart';
import 'package:personal_finance/state/providers/add_transaction_screen_providers/expense_tab_provider.dart';

class ExpenseTab extends ConsumerWidget {
  const ExpenseTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amount = TextEditingController();
    final formkey = GlobalKey();
    final transactionSelection = ref.watch(transactionSelectionProvider);
    final List<String> categoryList = [
      'Grocery',
      'Food',
      'Entertainment',
      'Bills',
      'Investments',
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
                CustomTextFormFeild(
                    key: formkey,
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
                        onPressed: () {},
                        child: Text('Add transaction'))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () => accountClicked(
                            context, accountList, transactionSelection, ref),
                        child: Column(
                          children: [
                            Text('Account'),
                            Text(
                              transactionSelection.account,
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        )),
                    TextButton(
                        onPressed: () => categoryClicked(
                            context, categoryList, transactionSelection, ref),
                        child: Column(
                          children: [
                            Text('Category'),
                            Text(
                              transactionSelection.category,
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        )),
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
    if (input == null) {
      return 'Enter amount';
    }
    return null;
  }

  void categoryClicked(BuildContext context, List categoryList,
      TransactionSelection transactionSelection, WidgetRef ref) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
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
                    Navigator.pop(context, category);
                    ref.read(transactionSelectionProvider.notifier).state =
                        transactionSelection.copyWith(category: category);
                  },
                );
              }).toList()),
            ),
          );
        });
  }

  void accountClicked(BuildContext context, List<dynamic> accountList,
      TransactionSelection transactionSelection, WidgetRef ref) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: accountList.map((account) {
                  return ListTile(
                    title: Text(account),
                    onTap: () {
                      Navigator.pop(context, account);
                      ref.read(transactionSelectionProvider.notifier).state =
                          transactionSelection.copyWith(account: account);
                    },
                  );
                }).toList(),
              ),
            ),
          );
        });
  }
}
