import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/models/account_detail_page/transaction_model.dart';
import 'package:personal_finance/services/account_detail_page/delete_account.dart';
import 'package:personal_finance/state/providers/account_detail_screen_provider.dart';
import '../../models/dashboard_page/account_model.dart';

class AccountDetailScreen extends ConsumerWidget {
  final Account account;

  const AccountDetailScreen({super.key, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
        actions: [
          IconButton(
              onPressed: () => deleteAccount(context, account),
              icon: Icon(Icons.delete))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
         Expanded(
  child: ref.watch(transactionProvider).when(
    data: (transactions) {

      final filteredTransactions = transactions
          .where((t) =>
              t.accountName == account.name ||
              t.senderAccount == account.name ||
              t.receieverAccount == account.name)
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return ListView.builder(
        itemCount: filteredTransactions.length,
        itemBuilder: (_, i) {
          final transaction = filteredTransactions[i];
return Card(
  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(
    padding: const EdgeInsets.all(14),
    child: Column(
      children: [

        /// TOP ROW
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// LEFT SIDE (Title + Subtitle)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  if (transaction.type == TransactionType.transfer)
                    Text(
                      "${transaction.senderAccount ?? ''} → ${transaction.receieverAccount ?? ''}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else
                    Text(
                      transaction.category,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                  const SizedBox(height: 4),

                  Text(
                    transaction.type.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            /// RIGHT SIDE (Amount)
            Text(
              transaction.amount.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: transaction.type == TransactionType.income
                    ? Colors.green
                    : transaction.type == TransactionType.expense
                        ? Colors.red
                        : Colors.blue,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        /// BOTTOM ROW (Date)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('dd MMM yyyy • HH:mm')
                  .format(transaction.createdAt),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    ),
  ),
);
        },
      );
    },
    loading: () =>
        const Center(child: CircularProgressIndicator()),
    error: (e, _) =>
        Center(child: Text(e.toString())),
  ),
)
        ],
      ),
    );
  }
}
