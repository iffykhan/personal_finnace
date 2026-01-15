class Transaction{
  final DateTime createAT;
  final String account;
  final String category;

  Transaction({required this.account,required this.category,required this.createAT});

  factory Transaction.fromJson(Map<String,dynamic> data){
    return Transaction(
      account: data['account'],
       category: data['category'],
        createAT: data['createAt']);
  }

  Map<String,dynamic> toJson(){
    return {
      'account': account,
      'category': category,
      'createAt':createAT
    };
  }
}