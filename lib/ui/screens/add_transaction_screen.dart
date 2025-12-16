import 'package:flutter/material.dart';

// To DO : Add Notes

enum TransactionType { income, transfer, expense }

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          //backgroundColor: Colors.deepPurple,
          title: const Text('Add Transaction',),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Income'),
              Tab(text: 'Transfer'),
              Tab(text: 'Expense'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TransactionTab(type: TransactionType.income),
            TransactionTab(type: TransactionType.transfer),
            TransactionTab(type: TransactionType.expense),
          ],
        ),
      ),
    );
  }
}

class TransactionTab extends StatefulWidget {
  final TransactionType type;

  const TransactionTab({super.key, required this.type});

  @override
  State<TransactionTab> createState() => _TransactionTabState();
}

class _TransactionTabState extends State<TransactionTab> {
  final TextEditingController amountController = TextEditingController();

  Account fromAccount = dummyAccounts.first;
  Account toAccount = dummyAccounts[1];
  Category? selectedCategory;
  Account selectedAccount = dummyAccounts.first;

  // void _selectAccount() async {
  //   final Account? account = await showModalBottomSheet<Account>(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder: (_) {
  //       return ListView(
  //         children: dummyAccounts.map((acc) {
  //           return ListTile(
  //             title: Text(acc.name),
  //             subtitle: Text('Balance: ${acc.balance}'),
  //             onTap: () => Navigator.pop(context, acc),
  //           );
  //         }).toList(),
  //       );
  //     },
  //   );
  //
  //   if (account != null) {
  //     setState(() => selectedAccount = account);
  //   }
  // }

  Future<Account?> _selectAccount({
    required String title,
    required List<Account> accounts,
  })
  {
    return showModalBottomSheet<Account>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(title, style: const TextStyle(fontSize: 18)),
            ),
            ...accounts.map(
                  (acc) => ListTile(
                title: Text(acc.name),
                subtitle: Text('Balance: ${acc.balance}'),
                onTap: () => Navigator.pop(context, acc),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _hasSufficientBalance({
    required Account account,
    required double amount,
  }) {
    // Credit cards can go negative (optional rule)
    if (account.type == 'Credit') return true;

    return account.balance >= amount;
  }


  List<Category> _categoriesByType() {
    switch (widget.type) {
      case TransactionType.income:
        return incomeCategories;
      case TransactionType.expense:
        return expenseCategories;
      case TransactionType.transfer:
        return transferCategories;
    }
  }

  void _selectCategory() async {
    final categories = _categoriesByType();

    final Category? category = await showModalBottomSheet<Category>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return ListView(
          children: categories.map((cat) {
            return ListTile(
              leading: Text(cat.icon, style: const TextStyle(fontSize: 22)),
              title: Text(cat.name),
              onTap: () => Navigator.pop(context, cat),
            );
          }).toList(),
        );
      },
    );

    if (category != null) {
      setState(() => selectedCategory = category);
    }
  }

  void _confirmTransaction() {
    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) return;

    if (widget.type == TransactionType.transfer) {
      // Same account
      if (fromAccount.id == toAccount.id) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('From and To accounts must be different')),
        );
        return;
      }
      // check balance/for credit logic the function allows negative
      if (!_hasSufficientBalance(account: fromAccount, amount: amount)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Insufficient balance in ${fromAccount.name}',)),
        );
        return;
      }


      debugPrint('Type: TRANSFER');
      debugPrint('From: ${fromAccount.name}');
      debugPrint('To: ${toAccount.name}');
    } else {
      debugPrint('Type: ${widget.type}');
      debugPrint('Account: ${selectedAccount.name}');
      debugPrint('Category: ${selectedCategory?.name}');
    }

    debugPrint('Amount: $amount');

    Navigator.pop(context);
  }


  @override
  void initState() {
    super.initState();

    selectedCategory = _categoriesByType().isNotEmpty
        ? _categoriesByType().first
        : Category(id: '', name: 'None', icon: '', isIncome: false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),

        /// Amount input (center)
        TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            hintText: '0',
            border: InputBorder.none,
          ),
        ),

        const Spacer(),

        /// Account & Category row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          // child: Row(
          //   children: [
          //     _SelectorTile(
          //       label: 'Account',
          //       value: selectedAccount.name,
          //       onTap: _selectAccount,
          //     ),
          //     const SizedBox(width: 12),
          //     _SelectorTile(
          //       label: 'Category',
          //       value: selectedCategory.name,
          //       onTap: _selectCategory,
          //     ),
          //   ],
          // )

            child: Row(
              children: [
                /// LEFT
                _SelectorTile(
                  label: widget.type == TransactionType.transfer
                      ? 'From'
                      : 'Account',
                  value: widget.type == TransactionType.transfer
                      ? fromAccount.name
                      : selectedAccount.name,
                  onTap: () async {
                    if (widget.type == TransactionType.transfer) {
                      final acc = await _selectAccount(
                        title: 'From Account',
                        accounts: dummyAccounts,
                      );
                      if (acc != null) setState(() => fromAccount = acc);
                    } else {
                      final acc = await _selectAccount(
                        title: 'Select Account',
                        accounts: dummyAccounts,
                      );
                      if (acc != null) setState(() => selectedAccount = acc);
                    }
                  },
                ),

                const SizedBox(width: 12),

                /// RIGHT
                _SelectorTile(
                  label: widget.type == TransactionType.transfer
                      ? 'To'
                      : 'Category',
                  value: widget.type == TransactionType.transfer
                      ? toAccount.name
                      : selectedCategory?.name ?? 'Select',
                  onTap: () async {
                    if (widget.type == TransactionType.transfer) {
                      final acc = await _selectAccount(
                        title: 'To Account',
                        accounts: dummyAccounts
                            .where((a) => a.id != fromAccount.id)
                            .toList(),
                      );
                      if (acc != null) setState(() => toAccount = acc);
                    } else {
                      _selectCategory();
                    }
                  },
                ),
              ],
            )


        ),

        const SizedBox(height: 20),

        /// Confirm button
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _confirmTransaction();
              },
              child: const Text('Confirm'),
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectorTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _SelectorTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Account {
  final String id;
  final String name;
  final String type;
  final double balance;

  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
  });
}

const List<Account> dummyAccounts = [
  Account(id: 'acc_1', name: 'Cash', type: 'Cash', balance: 1250),
  Account(id: 'acc_2', name: 'Bank Account', type: 'Checking', balance: 18500),
  Account(id: 'acc_3', name: 'Savings', type: 'Savings', balance: 32000),
  Account(id: 'acc_4', name: 'Credit Card', type: 'Credit', balance: -5400),
];

class Category {
  final String id;
  final String name;
  final String icon;
  final bool isIncome;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.isIncome,
  });
}

const List<Category> incomeCategories = [
  Category(id: 'inc_1', name: 'Salary', icon: '💼', isIncome: true),
  Category(id: 'inc_2', name: 'Freelance', icon: '🧑‍💻', isIncome: true),
  Category(id: 'inc_3', name: 'Business', icon: '🏢', isIncome: true),
  Category(id: 'inc_4', name: 'Investment', icon: '📈', isIncome: true),
  Category(id: 'inc_5', name: 'Bonus', icon: '🎁', isIncome: true),
];

const List<Category> transferCategories = [
  Category(id: 'tr_1', name: 'To Savings', icon: '🏦', isIncome: false),
  Category(id: 'tr_2', name: 'To Wallet', icon: '📱', isIncome: false),
];

const List<Category> expenseCategories = [
  Category(id: 'exp_1', name: 'Food', icon: '🍔', isIncome: false),
  Category(id: 'exp_2', name: 'Transport', icon: '🚗', isIncome: false),
  Category(id: 'exp_3', name: 'Shopping', icon: '🛍️', isIncome: false),
  Category(id: 'exp_4', name: 'Bills', icon: '💡', isIncome: false),
  Category(id: 'exp_5', name: 'Rent', icon: '🏠', isIncome: false),
  Category(id: 'exp_6', name: 'Health', icon: '💊', isIncome: false),
  Category(id: 'exp_7', name: 'Entertainment', icon: '🎬', isIncome: false),
];

List<Category> getCategories(TransactionType type) {
  switch (type) {
    case TransactionType.income:
      return incomeCategories;
    case TransactionType.expense:
      return expenseCategories;
    case TransactionType.transfer:
      return transferCategories;
  }
}
