import 'package:flutter/material.dart';
import 'package:personal_finance/services/account_detail_page/delete_account.dart';
import '../../models/dashboard_page/account_model.dart';



class AccountDetailScreen extends StatelessWidget {
  final Account account;

  const AccountDetailScreen({
    super.key,required this.account
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
        actions: [
          IconButton( onPressed:()=> deleteAccount(context,account), icon: Icon(Icons.delete))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          /// Balance
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Total Balance',
              style: TextStyle(
                color: Colors.deepPurple.shade400,
                fontSize: 18,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '\$ ${account.balance.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.deepPurple,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// Transactions
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
  

}

