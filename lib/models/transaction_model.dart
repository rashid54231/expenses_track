class TransactionModel {

  final String id;
  final String title;
  final double amount;
  final String categoryId;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.date,
  });

  factory TransactionModel.fromJson(Map<String,dynamic> json){
    return TransactionModel(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      categoryId: json['category_id'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "id": id,
      "title": title,
      "amount": amount,
      "category_id": categoryId,
      "date": date.toIso8601String(),
    };
  }

}