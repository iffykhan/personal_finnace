import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance/models/dashboard_page/account_model.dart';
import 'package:personal_finance/services/add_transaction_page/add_income_transaction_method.dart';
import 'package:personal_finance/state/providers/add_transaction_screen_providers/income_tab_provider.dart';
import 'package:personal_finance/state/providers/dashboard_providers.dart';
import 'package:personal_finance/ui/widgets/add_transaction_screen_dialogue.dart';
import 'package:personal_finance/ui/widgets/custom_textformfeild.dart';

class Incometab extends ConsumerWidget {
  const Incometab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amountController = ref.watch(textEditingControllerProviderOfIncome);
    final formkey = GlobalKey<FormState>();
    final Account? selectedAccount = ref.watch(accountIncomeProvider);
    final String? selectedCategory = ref.watch(categoryIncomeProvider);
    final isLoading = ref.watch(isLoadingIncomeProvider);

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
          final accountList = account.map((account) => account).toList();
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Form(
                  key: formkey,
                  child: CustomTextFormFeild(
                      controller: amountController,
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
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (!formkey.currentState!.validate()) return;
                                if (selectedAccount == null ||
                                    selectedCategory == null ||
                                    selectedAccount.name ==
                                        'Select an account' ||
                                    selectedCategory == 'Select a Category') {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Selection required'),
                                      content: const Text(
                                          'Please select both an account and a category.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                  return;
                                }
                                final parsedAmount =
                                    int.tryParse(amountController.text);
                                if (parsedAmount == null || parsedAmount <= 0) {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Invalid amount'),
                                      content: const Text(
                                          'Please enter a valid amount (> 0).'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                  return;
                                }
                                ref
                                    .read(isLoadingIncomeProvider.notifier)
                                    .state = true;
                                try {
                                  await addIncomeTransaction(
                                    selectedAccount,
                                    selectedCategory,
                                    parsedAmount,
                                    context,
                                  );
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Transaction successfully added')));
                                  Navigator.pop(context);
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Transaction failed: $e')),
                                    );
                                  }
                                } finally {
                                  ref
                                      .read(isLoadingIncomeProvider.notifier)
                                      .state = false;
                                }
                              },
                        child: isLoading
                            ? SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : Text('Add Income'))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Consumer(
                      builder:
                          (BuildContext context, WidgetRef ref, Widget? child) {
                        return TextButton(
                            onPressed: isLoading
                                ? null
                                : () =>
                                    accountClicked(context, accountList, ref),
                            child: Column(
                              children: [
                                Text('Account'),
                                Text(
                                  selectedAccount?.name ?? 'Select account',
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
                            onPressed: isLoading
                                ? null
                                : () =>
                                    categoryClicked(context, categoryList, ref),
                            child: Column(
                              children: [
                                Text('Category'),
                                Text(
                                  selectedCategory ?? 'Select category',
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

  void categoryClicked(
      BuildContext context, List<String> categoryList, WidgetRef ref) {
    showDialog(
        context: context,
        builder: (context) {
          return AddTransactionScreenDialogue<String>(
            list: categoryList,
            label: (category) {
              return category;
            },
            onSelect: (category) {
              ref.read(categoryIncomeProvider.notifier).state = category;
            },
          );
          // return SingleChildScrollView(
          //   child: Dialog(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadiusGeometry.circular(12),
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.all(8),
          //       child: Column(
          //           children: categoryList.map((category) {
          //         return ListTile(
          //           title: Text(category),
          //           onTap: () {
          //             ref.read(categoryIncomeProvider.notifier).state =
          //                 category;
          //             Navigator.pop(context, category);
          //           },
          //         );
          //       }).toList()),
          //     ),
          //   ),
          // );
        });
  }

  void accountClicked(
      BuildContext context, List<Account> accountList, WidgetRef ref) {
    showDialog(
        context: context,
        builder: (context) {
          if (accountList.isEmpty) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('No account available please add account first'),
              ),
            );
          } else {
            return AddTransactionScreenDialogue<Account>(
                list: accountList,
                label: (account) {
                  return account.name;
                },
                onSelect: (account) {
                  ref.read(accountIncomeProvider.notifier).state = account;
                });
          }
          // return SingleChildScrollView(
          //   child: Dialog(
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadiusGeometry.circular(12)),
          //     child: Padding(
          //       padding: const EdgeInsets.all(8),
          //       child: Column(
          //         children: accountList.map((account) {
          //           return ListTile(
          //             title: Text(account.name),
          //             onTap: () {
          //               ref.read(accountIncomeProvider.notifier).state =
          //                   account;
          //               Navigator.pop(context, account);
          //             },
          //           );
          //         }).toList(),
          //       ),
          //     ),
          //   ),
          // );
        });
  }
}
