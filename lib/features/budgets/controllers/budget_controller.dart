import '../../../models/budget_model.dart';

class BudgetController {

  final List<BudgetModel> _budgets = [];

  List<BudgetModel> get budgets => _budgets;

  void addBudget(BudgetModel budget){
    _budgets.add(budget);
  }

}