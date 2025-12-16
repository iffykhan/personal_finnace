import 'package:flutter/material.dart';
import '../screens/account_detail_screen.dart';
import '../screens/dashboard_screen.dart';

// Class in Dashboard
// To Do : Add Router with account class passing through widget

class DashboardAccountContainer extends StatelessWidget {
  final Account account;

  const DashboardAccountContainer({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AccountDetailScreen(account: account),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white.withOpacity(0.18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                account.name,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
              Text(
                '\$ ${account.balance.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

