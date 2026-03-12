import 'package:flutter/material.dart';
import '../../../models/category_model.dart';

class AddCategoryScreen extends StatefulWidget {

  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {

  final nameController = TextEditingController();

  String type = "expense";

  void save(){

    final category = CategoryModel(
      id: DateTime.now().toString(),
      name: nameController.text,
      type: type,
    );

    Navigator.pop(context, category);

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Add Category"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                  labelText: "Category Name"
              ),
            ),

            const SizedBox(height:20),

            DropdownButton<String>(
              value: type,
              items: const [
                DropdownMenuItem(
                  value: "expense",
                  child: Text("Expense"),
                ),
                DropdownMenuItem(
                  value: "income",
                  child: Text("Income"),
                )
              ],
              onChanged: (value){
                setState(() {
                  type = value!;
                });
              },
            ),

            const SizedBox(height:30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: save,
                child: const Text("Save"),
              ),
            )

          ],

        ),
      ),

    );

  }
}