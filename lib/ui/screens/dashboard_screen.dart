import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance/providers/dashboard_providers.dart';
import 'package:personal_finance/routes/screen_routes.dart';
import 'package:personal_finance/services/dashboard_page/add_account_method.dart';
import 'package:personal_finance/ui/widgets/custom_textformfeild.dart';
import 'package:personal_finance/ui/widgets/dashboard_account_container.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final account = ref.watch(accountStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome ${auth.currentUser?.displayName}',
          style: TextStyle(color: Colors.deepPurple),
        ),
        actions: [
          IconButton(
              onPressed: () => logout(context),
              icon: Icon(
                Icons.logout,
                color: Colors.deepPurple,
              ))
        ],
      ),
      body: Column(
        children: [
          Card(
            elevation: 5,
            child: Container(
              height: 270,
              width: 420,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(colors: [
                    Colors.deepPurple,
                    Colors.deepPurple.withValues(alpha: 0.5)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Text(
                        'Total Balance',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '\$ 2,469.50',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ],
                  ),
                  Expanded(
                    child: account.when(
                      data: (accountList) => GridView.builder(
                        padding: const EdgeInsets.all(10),
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 2.6,
                        ),
                        itemCount: accountList.length < 4
                            ? accountList.length + 1
                            : accountList.length,
                        itemBuilder: (context, index) {
                          if (index < accountList.length) {
                            return DashboardAccountContainer(
                                account: accountList[index]);
                          } else {
                            return InkWell(
                              onTap: () => openDialogueToAddAccount(context,ref),
                              child: Container(
                                  padding: EdgeInsets.all(8),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white.withValues(alpha:0.18),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Add account  ',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Icon(color: Colors.white, Icons.add)
                                    ],
                                  )),
                            );
                          }
                        },
                      ),
                      loading: () => Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Center(child: Text('Error loading accounts')),
                    ),
                  )
                  
                ],
              ),
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteName.addTransactionScreen);
        },
        tooltip: 'Increment',
        backgroundColor:
            Colors.deepPurple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add), 
      ),

    );
  }

  logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, RouteName.loginScreen);
  }

  
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
}

