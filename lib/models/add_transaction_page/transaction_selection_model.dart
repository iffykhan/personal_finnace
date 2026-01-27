class TransactionSelection {
  final String account;
  final String category;

  TransactionSelection({required this.account, required this.category});

  TransactionSelection copyWith({String? account, String? category}) {
    return TransactionSelection(
        account: account ?? this.account, category: category ?? this.category);
  }
}
