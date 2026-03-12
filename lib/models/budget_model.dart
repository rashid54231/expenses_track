class BudgetModel {

  final String id;
  final String categoryId;
  final double limitAmount;

  BudgetModel({
    required this.id,
    required this.categoryId,
    required this.limitAmount,
  });

  factory BudgetModel.fromJson(Map<String,dynamic> json){
    return BudgetModel(
      id: json['id'],
      categoryId: json['category_id'],
      limitAmount: json['limit_amount'],
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "id": id,
      "category_id": categoryId,
      "limit_amount": limitAmount,
    };
  }

}