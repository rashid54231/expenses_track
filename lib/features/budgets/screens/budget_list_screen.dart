import 'package:flutter/material.dart';
import 'create_budget_screen.dart';

class BudgetListScreen extends StatelessWidget {
  const BudgetListScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Budgets"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateBudgetScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: ListView(
        children: const [

          ListTile(
            title: Text("Food Budget"),
            subtitle: Text("Limit: \$300"),
          ),

          ListTile(
            title: Text("Shopping Budget"),
            subtitle: Text("Limit: \$200"),
          ),

        ],
      ),

    );
  }
}