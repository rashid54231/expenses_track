import '../../../models/category_model.dart';

class CategoryController {

  final List<CategoryModel> _categories = [
    CategoryModel(id: "1", name: "Food", type: "expense"),
    CategoryModel(id: "2", name: "Transport", type: "expense"),
    CategoryModel(id: "3", name: "Salary", type: "income"),
  ];

  List<CategoryModel> get categories => _categories;

  void addCategory(CategoryModel category){
    _categories.add(category);
  }

}