import 'package:flutter/material.dart';
import '../../../models/transaction_model.dart';

class CreateRecurringScreen extends StatefulWidget {

  const CreateRecurringScreen({super.key});

  @override
  State<CreateRecurringScreen> createState() => _CreateRecurringScreenState();
}

class _CreateRecurringScreenState extends State<CreateRecurringScreen> {

  final titleController = TextEditingController();
  final amountController = TextEditingController();

  void save(){

    final transaction = TransactionModel(
      id: DateTime.now().toString(),
      title: titleController.text,
      amount: double.parse(amountController.text),
      categoryId: "Recurring",
      date: DateTime.now(),
    );

    Navigator.pop(context, transaction);

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Create Recurring Transaction"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height:20),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height:30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: save,
                child: const Text("Save Recurring Transaction"),
              ),
            )

          ],

        ),
      ),

    );

  }

}