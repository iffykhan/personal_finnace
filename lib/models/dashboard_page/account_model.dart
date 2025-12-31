class Account {
  final String id; // Firestore document ID
  final String name;
  final double balance;

  const Account({
    required this.id,
    required this.name,
    required this.balance,
  });

  /// Factory constructor to create Account from Firestore map
  factory Account.fromMap(Map<String, dynamic> map, {required String id}) {
    return Account(
      id: id, // document ID
      name: map['name'] as String,
      balance: (map['balance'] as num).toDouble(),
    );
  }

  /// Convert Account to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'balance': balance,
    };
  }
}
