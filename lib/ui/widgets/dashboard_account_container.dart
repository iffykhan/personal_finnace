import 'package:flutter/material.dart';
import 'package:personal_finance/routes/screen_routes.dart';
import '../../models/dashboard_page/account_model.dart';

class DashboardAccountContainer extends StatelessWidget {
  final Account account;

  const DashboardAccountContainer({
    super.key, required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteName.accountDetailScreen,
           arguments: account
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white.withValues(alpha:0.18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              account.name,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            SizedBox(height: 10,),
            Text(
              '\$ ${account.balance.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

