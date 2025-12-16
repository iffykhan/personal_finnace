import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_screen.dart';

// Account Class in dashboard

class AccountDetailScreen extends ConsumerWidget {
  final Account account;

  const AccountDetailScreen({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = dummyTransactions
        .where((t) => t['accountId'] == account.id)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
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

          const SizedBox(height: 10),

          Expanded(
            child: transactions.isEmpty
                ? const Center(child: Text('No transactions'))
                : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (_, index) {
                final tx = transactions[index];
                final amount = tx['amount'] as double;

                return ListTile(
                  title: Text(tx['title'].toString()),
                  trailing: Text(
                    amount > 0
                        ? '+\$${amount.toStringAsFixed(2)}'
                        : '-\$${amount.abs().toStringAsFixed(2)}',
                    style: TextStyle(
                      color: amount > 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

