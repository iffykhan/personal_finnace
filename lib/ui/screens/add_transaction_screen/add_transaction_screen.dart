import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance/ui/screens/add_transaction_screen/tabs/expensetab.dart';
import 'package:personal_finance/ui/screens/add_transaction_screen/tabs/incometab.dart';
import 'package:personal_finance/ui/screens/add_transaction_screen/tabs/transfertab.dart';

class AddTransactionScreen extends ConsumerWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple,
                  Colors.deepPurple.withValues(alpha: 0.5),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: const Center(
              child: Text(
                'Add Transaction',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Transfer'),
              Tab(text: 'Expense'),
              Tab(text: 'Income'),
            ],
            unselectedLabelColor: Colors.white,
            labelColor: Colors.black.withValues(alpha: .65),
          ),
        ),
        body: const TabBarView(
          children: [
            TransferTab(),
            ExpenseTab(),
            Incometab(),
          ],
        ),
      ),
    );
  }
}
