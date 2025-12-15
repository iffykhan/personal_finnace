import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/routes/screen_routes.dart';


class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(title: Text(
          'Welcome ${auth.currentUser?.displayName}' ),
        actions: [IconButton(onPressed: () => logout(context),
            icon: Icon(Icons.logout))],),
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

                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ubl bank',style: TextStyle(color: Colors.white,fontSize: 15),),
                              Text('\$ 2,000',style: TextStyle(color: Colors.white,fontSize: 15),),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        child: Container(height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                          ),child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ubl bank',style: TextStyle(color: Colors.white,fontSize: 15),),
                              Text('\$ 3,000',style: TextStyle(color: Colors.white,fontSize: 15),),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(7),height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white.withOpacity(0.18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ubl bank',style: TextStyle(color: Colors.white,fontSize: 15),),
                              Text('\$ 6,000',style: TextStyle(color: Colors.white,fontSize: 15),),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        child: Container(height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ubl bank',style: TextStyle(color: Colors.white,fontSize: 15),),
                              Text('\$ 3,000',style: TextStyle(color: Colors.white,fontSize: 15),),
                            ],
                          ),
                        ),
                      )
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
        onPressed: (){},
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






//
// Widget _accountChip(String title) {
//   return Expanded(
//     child: Container(
//       //padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: Text(
//         title,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 20,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     ),
//   );
// }
//
// Widget _addAccountChip() {
//   return Expanded(
//     child: Container(
//       //padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: Center(
//         child: Text(
//           '+',
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     ),
//   );
// }
//
