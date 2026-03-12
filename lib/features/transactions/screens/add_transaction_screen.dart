import 'package:flutter/material.dart';
import '../../../models/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {

  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {

  final titleController = TextEditingController();
  final amountController = TextEditingController();

  void save(){

    final transaction = TransactionModel(
      id: DateTime.now().toString(),
      title: titleController.text,
      amount: double.parse(amountController.text),
      categoryId: "general",
      date: DateTime.now(),
    );

    Navigator.pop(context, transaction);

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Add Transaction"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(

          children: [

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                  labelText: "Title"
              ),
            ),

            const SizedBox(height:20),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: "Amount"
              ),
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