class AccountModel {

  final String id;
  final String name;
  final double balance;

  AccountModel({
    required this.id,
    required this.name,
    required this.balance,
  });

  factory AccountModel.fromJson(Map<String,dynamic> json){
    return AccountModel(
      id: json['id'],
      name: json['name'],
      balance: json['balance'],
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "id": id,
      "name": name,
      "balance": balance,
    };
  }

}