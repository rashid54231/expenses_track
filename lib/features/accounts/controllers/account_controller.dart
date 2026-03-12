import '../../../models/account_model.dart';

class AccountController {

  final List<AccountModel> _accounts = [
    AccountModel(id: "1", name: "Cash", balance: 500),
    AccountModel(id: "2", name: "Bank", balance: 2000),
  ];

  List<AccountModel> get accounts => _accounts;

  void addAccount(AccountModel account){
    _accounts.add(account);
  }

}