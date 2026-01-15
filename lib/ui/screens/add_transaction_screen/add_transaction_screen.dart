import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance/state/providers/add_transaction_screen_providers/expense_tab_provider.dart';
import 'package:personal_finance/ui/screens/add_transaction_screen/tabs/expensetab.dart';

class AddTransactionScreen extends ConsumerWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          ref.read(transactionSelectionProvider.notifier).state = ref
              .read(transactionSelectionProvider.notifier)
              .state
              .copyWith(
                  account: 'Select an account', category: 'Select a Category');

          Navigator.pop(context);
        },
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
              Center(child: Text('Transfer Tab')),
              ExpenseTab(),
              Center(child: Text('Income Tab')),
            ],
          ),
        ),
      ),
    );
  }
}
