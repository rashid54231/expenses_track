import 'package:flutter/material.dart';
import '../controllers/category_controller.dart';
import 'add_category_screen.dart';
import '../../../models/category_model.dart';

class CategoryListScreen extends StatefulWidget {

  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {

  final CategoryController controller = CategoryController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Categories"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddCategoryScreen(),
            ),
          );

          if(result != null){
            setState(() {
              controller.addCategory(result);
            });
          }

        },
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(
        itemCount: controller.categories.length,
        itemBuilder: (context,index){

          CategoryModel cat = controller.categories[index];

          return ListTile(
            title: Text(cat.name),
            subtitle: Text(cat.type),
          );

        },
      ),

    );

  }
}