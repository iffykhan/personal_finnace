import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/routes/screen_routes.dart';
import 'package:personal_finance/ui/widgets/dashboard_account_container.dart';


class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(title: Text(
          'Welcome ${auth.currentUser?.displayName}', style: TextStyle(color: Colors.deepPurple), ),
        actions: [IconButton(onPressed: () => logout(context),
            icon: Icon(Icons.logout,color: Colors.deepPurple,))],),
      body: Column(
        children: [
          Card(
            elevation: 5,
            child: Container(
              height: 260,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(colors: [Colors.deepPurple,Colors.deepPurple.withOpacity(0.5)],
                begin: Alignment.topCenter , end: Alignment.bottomCenter)
              ),
              child: Column(children: [
                SizedBox(height: 10,),
                Row(
                  children: [
                    SizedBox(width: 10),
                    Text('Total Balance',style: TextStyle(color: Colors.white,
                    fontSize: 20),),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    SizedBox(width: 10,),
                    Text('\$ 2,469.50', style: TextStyle(color: Colors.white,
                    fontSize: 30),
                    ),
                  ],
                ),
                SizedBox(height: 21,),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      DashboardAccountContainer(account: dummyAccounts[0]),
                      SizedBox(
                        width: 6,
                      ),
                      DashboardAccountContainer(account: dummyAccounts[1]),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      DashboardAccountContainer(account: dummyAccounts[2]),
                      SizedBox(
                        width: 6,
                      ),
                      DashboardAccountContainer(account: dummyAccounts[3]),
                    ],
                  ),
                )
              ],
              ),
            ),
          ),
          // TransactionList(transactions: mockTransactions),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, RouteName.addTransactionScreen);
        },
        tooltip: 'Increment',
        backgroundColor: Colors.deepPurple, // Customizes the button's background color
        foregroundColor: Colors.white,
        child: const Icon(Icons.add), // Customizes the icon's color
      ),
      // Optional: You can change the FAB's location
      //floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if(!context.mounted) return;
    Navigator.pushReplacementNamed(context, RouteName.loginScreen);
  }
}

class Account {
  final String id;
  final String name;
  final double balance;

  const Account({
    required this.id,
    required this.name,
    required this.balance,
  });
}

const dummyAccounts = [
  Account(id: 'a1', name: 'Cash', balance: 1240.50),
  Account(id: 'a2', name: 'Bank', balance: 2469.50),
  Account(id: 'a3', name: 'Savings', balance: 8900.00),
  Account(id: 'a4', name: 'Business', balance: 64495.00),
];

const dummyTransactions = [
  {
    'accountId': 'a2',
    'title': 'Groceries',
    'amount': -120.0,
  },
  {
    'accountId': 'a2',
    'title': 'Salary',
    'amount': 2500.0,
  },
  {
    'accountId': 'a2',
    'title': 'Transport',
    'amount': -80.5,
  },
];
