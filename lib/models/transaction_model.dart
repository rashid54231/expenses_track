class TransactionModel {

  final String id;
  final String title;
  final double amount;
  final String categoryId;
  final String type;
  final String? notes;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.type,
    this.notes,
    required this.date,
  });

  factory TransactionModel.fromJson(Map<String,dynamic> json){
    return TransactionModel(
      id: json['id'],
      title: json['title'],
      amount: (json['amount'] as num).toDouble(),
      categoryId: json['category_id'],
      type: json['type'] ?? "Expense",
      notes: json['notes'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "id": id,
      "title": title,
      "amount": amount,
      "category_id": categoryId,
      "type": type,
      "notes": notes,
      "date": date.toIso8601String(),
    };
  }

}