class Account {
  final String id;
  final String name;
  final double balance;

  const Account({
    required this.id,
    required this.name,
    required this.balance,
  });


  factory Account.fromMap(Map<String, dynamic> map, {required String id}) {
    return Account(
      id: id,
      name: map['name'] as String,
      balance: (map['balance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'balance': balance,
    };
  }
}
