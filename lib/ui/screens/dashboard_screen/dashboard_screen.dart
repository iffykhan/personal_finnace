import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance/services/dashboard_page/logout_user_method.dart';
import 'package:personal_finance/state/providers/dashboard_providers.dart';
import 'package:personal_finance/routes/screen_routes.dart';
import 'package:personal_finance/ui/screens/dashboard_screen/open_dialogue_to_add_account.dart';
import 'package:personal_finance/ui/widgets/dashboard_account_container.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final account = ref.watch(accountStreamProvider);
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width >= 600; // tablet / laptop
    final isWideScreen = size.width / size.height > 1.2; // landscape or laptop-ish

    final double cardHeight = (isLargeScreen || isWideScreen)
        ? size.height * 0.60
        : size.height * 0.35;

    final double gridAspectRatio = (isLargeScreen || isWideScreen) ? 7 : 2.6;

    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome ${auth.currentUser?.displayName}',
          style: TextStyle(color: Colors.deepPurple),
        ),
        actions: [
          IconButton(
              onPressed: () => logout(context,ref),
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
             height: cardHeight,
              width: double.infinity,
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
                        //physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: gridAspectRatio,
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



  
}

