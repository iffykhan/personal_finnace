import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance/models/dashboard_page/account_model.dart';
import 'package:personal_finance/services/add_transaction_page/add_transfer_transaction_method.dart';
import 'package:personal_finance/state/providers/add_transaction_screen_providers/income_tab_provider.dart';
import 'package:personal_finance/state/providers/add_transaction_screen_providers/transfer_tab_provider.dart';
import 'package:personal_finance/state/providers/dashboard_providers.dart';
import 'package:personal_finance/ui/widgets/custom_textformfeild.dart';

class TransferTab extends ConsumerWidget {
  const TransferTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amount = ref.watch(textEditingControllerProviderOfIncome);
    final formkey = GlobalKey<FormState>();
    final transactionSelectionOfSenderAccount =
        ref.watch(transactionSelectionProviderOfSenderAccount);
    final transactionSelectionOfRecieverAccount =
        ref.watch(transactionSelectionProviderOfReceiverAccount);

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
                          if (!formkey.currentState!.validate()) return;
                          if (transactionSelectionOfRecieverAccount==null||
                              transactionSelectionOfSenderAccount==null
                                ) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Accounts required'),
                                    content: const Text(
                                        'You must select sender and reciever accounts to continue.'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('Ok'))
                                    ],
                                  );
                                });
                  
                          }
                          addTransferTransaction(
                            transactionSelectionOfSenderAccount!,
                            transactionSelectionOfRecieverAccount!,
                            amount.text,
                            context,
                          );
                        },
                        child: Text('Add transaction'))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Consumer(
                      builder:
                          (BuildContext context, WidgetRef ref, Widget? child) {
                        return TextButton(
                            onPressed: () =>
                                senderAccountClicked(context, accountList, ref),
                            child: Column(
                              children: [
                                Text('Sender Account'),
                                Text(
                                  transactionSelectionOfSenderAccount?.name ??
                                      'Select sender Account',
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
                            onPressed: () => recieverAccountClicked(
                                context, accountList, ref),
                            child: Column(
                              children: [
                                Text('Reciever Account'),
                                Text(
                                  transactionSelectionOfRecieverAccount?.name ??
                                      'Select receiever Account',
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

  void recieverAccountClicked(
      BuildContext context, List<Account> accountList, WidgetRef ref) {
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
                    children: accountList.map((account) {
                  return ListTile(
                    title: Text(account.name),
                    onTap: () {
                      ref
                          .read(transactionSelectionProviderOfReceiverAccount
                              .notifier)
                          .state = account;
                      Navigator.pop(context, account);
                    },
                  );
                }).toList()),
              ),
            ),
          );
        });
  }

  void senderAccountClicked(
      BuildContext context, List<Account> accountList, WidgetRef ref) {
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
                      title: Text(account.name),
                      onTap: () {
                        ref
                            .read(transactionSelectionProviderOfSenderAccount
                                .notifier)
                            .state = account;
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
