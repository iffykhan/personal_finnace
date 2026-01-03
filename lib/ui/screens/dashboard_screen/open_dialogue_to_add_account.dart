
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance/services/dashboard_page/add_account_method.dart';
import 'package:personal_finance/ui/widgets/custom_textformfeild.dart';

openDialogueToAddAccount(BuildContext context,WidgetRef ref) {
  final nameController = TextEditingController();
  final balanceController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add Account'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min, // makes dialog fit content
            children: [
              CustomTextFormFeild(
                hint: 'Account name',
                isPassword: false,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if(value ==null || value.trim().isEmpty) {
                    return 'Enter name';
                    }
                  return null;
                      },
                controller: nameController,
                
              ),
              SizedBox(height: 10),
              CustomTextFormFeild(
                controller: balanceController,

                keyboardType: TextInputType.number,
                 hint: 'Balance',
                  isPassword: false,
                   validator: (value) {
                  if(value ==null || value.trim().isEmpty) {
                    return 'Enter your balance';
                    }
                  return null;
                      },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }

              final name = nameController.text.trim();
              final balance = double.tryParse(balanceController.text.trim()) ?? 0;

              addAccount(
                ref: ref,
                context: context,
                name: name,
                balance: balance,
              );
            },
            child: const Text('Add Account'),
          )

        ],
      );
    },
  );
}