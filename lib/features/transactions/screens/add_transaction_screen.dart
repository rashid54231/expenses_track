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
  final notesController = TextEditingController();

  String selectedType = "Expense";
  String selectedCategory = "General";

  DateTime selectedDate = DateTime.now();

  final categories = [
    "General",
    "Food",
    "Transport",
    "Shopping",
    "Salary",
    "Bills"
  ];

  void pickDate() async {

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );

    if(picked != null){
      setState(() {
        selectedDate = picked;
      });
    }

  }

  void save(){

    if(titleController.text.isEmpty || amountController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all required fields"))
      );
      return;
    }

    double? amount = double.tryParse(amountController.text);

    if(amount == null){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Enter valid amount"))
      );
      return;
    }

    final transaction = TransactionModel(
      id: DateTime.now().toString(),
      title: titleController.text,
      amount: amount,
      categoryId: selectedCategory,
      type: selectedType,
      notes: notesController.text,
      date: selectedDate,
    );

    Navigator.pop(context, transaction);

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Add Transaction"),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(

            children: [

              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder()
                ),
              ),

              const SizedBox(height:20),

              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "Amount",
                    border: OutlineInputBorder()
                ),
              ),

              const SizedBox(height:20),

              DropdownButtonFormField(
                value: selectedType,
                decoration: const InputDecoration(
                    labelText: "Transaction Type",
                    border: OutlineInputBorder()
                ),
                items: ["Income","Expense"].map((type){
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value){
                  setState(() {
                    selectedType = value!;
                  });
                },
              ),

              const SizedBox(height:20),

              DropdownButtonFormField(
                value: selectedCategory,
                decoration: const InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder()
                ),
                items: categories.map((cat){
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (value){
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),

              const SizedBox(height:20),

              InkWell(
                onTap: pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 12
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4)
                  ),
                  width: double.infinity,
                  child: Text(
                    "Date: ${selectedDate.toLocal()}".split(' ')[0],
                  ),
                ),
              ),

              const SizedBox(height:20),

              TextField(
                controller: notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: "Notes (Optional)",
                    border: OutlineInputBorder()
                ),
              ),

              const SizedBox(height:30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: save,
                  child: const Text("Save Transaction"),
                ),
              )

            ],

          ),
        ),
      ),

    );

  }
}