import '../../../models/transaction_model.dart';

class RecurringController {

  final List<TransactionModel> _recurringTransactions = [];

  List<TransactionModel> get transactions => _recurringTransactions;

  void addRecurring(TransactionModel transaction) {
    _recurringTransactions.add(transaction);
  }

}