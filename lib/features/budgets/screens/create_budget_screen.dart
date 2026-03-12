import 'package:flutter/material.dart';
import '../../../core/services/supabase_service.dart';

class CreateBudgetScreen extends StatefulWidget {
  const CreateBudgetScreen({super.key});

  @override
  State<CreateBudgetScreen> createState() => _CreateBudgetScreenState();
}

class _CreateBudgetScreenState extends State<CreateBudgetScreen> {

  final amountController = TextEditingController();

  String selectedMonth = "June";

  Future<void> saveBudget() async {

    try {

      await SupabaseService.client
          .from('budgets')
          .insert({
        'user_id': SupabaseService.client.auth.currentUser!.id,
        'category_id': null,
        'limit_amount': double.parse(amountController.text),
        'month': selectedMonth,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Budget Saved")),
      );

      Navigator.pop(context);

    } catch (e) {

      print("Budget Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save budget")),
      );

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Create Budget"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Budget Amount",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height:20),

            DropdownButtonFormField(
              value: selectedMonth,
              items: const [
                DropdownMenuItem(value: "January", child: Text("January")),
                DropdownMenuItem(value: "February", child: Text("February")),
                DropdownMenuItem(value: "March", child: Text("March")),
                DropdownMenuItem(value: "April", child: Text("April")),
                DropdownMenuItem(value: "May", child: Text("May")),
                DropdownMenuItem(value: "June", child: Text("June")),
                DropdownMenuItem(value: "July", child: Text("July")),
                DropdownMenuItem(value: "August", child: Text("August")),
                DropdownMenuItem(value: "September", child: Text("September")),
                DropdownMenuItem(value: "October", child: Text("October")),
                DropdownMenuItem(value: "November", child: Text("November")),
                DropdownMenuItem(value: "December", child: Text("December")),
              ],
              onChanged: (value){
                setState(() {
                  selectedMonth = value.toString();
                });
              },
              decoration: const InputDecoration(
                labelText: "Month",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height:30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveBudget,
                child: const Text("Save Budget"),
              ),
            )

          ],

        ),
      ),

    );
  }
}