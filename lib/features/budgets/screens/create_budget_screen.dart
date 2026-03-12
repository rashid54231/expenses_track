import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/services/supabase_service.dart';

class CreateBudgetScreen extends StatefulWidget {
  const CreateBudgetScreen({super.key});

  @override
  State<CreateBudgetScreen> createState() => _CreateBudgetScreenState();
}

class _CreateBudgetScreenState extends State<CreateBudgetScreen> {

  final TextEditingController amountController = TextEditingController();

  bool isSaving = false;

  String selectedMonth = "January";
  int selectedYear = DateTime.now().year;

  String? selectedCategory;

  List<Map<String, dynamic>> categories = [];

  final List<String> months = [
    "January","February","March","April","May","June",
    "July","August","September","October","November","December"
  ];

  final List<int> years =
  List.generate(10, (index) => DateTime.now().year + index);

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {

      final data = await SupabaseService.client
          .from("categories")
          .select();

      setState(() {
        categories = List<Map<String, dynamic>>.from(data);
      });

    } catch (e) {

      showMessage("Failed to load categories", true);

    }
  }

  Future<void> saveBudget() async {

    if (amountController.text.isEmpty) {
      showMessage("Enter budget amount", true);
      return;
    }

    if (selectedCategory == null) {
      showMessage("Select category", true);
      return;
    }

    double? amount = double.tryParse(amountController.text);

    if (amount == null) {
      showMessage("Invalid amount", true);
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {

      await SupabaseService.client.from("budgets").insert({

        "user_id": SupabaseService.client.auth.currentUser!.id,
        "category_id": selectedCategory,
        "limit_amount": amount,
        "month": selectedMonth,
        "year": selectedYear

      });

      showMessage("Budget saved successfully");

      if (mounted) {
        Navigator.pop(context);
      }

    } catch (e) {

      showMessage("Failed to save budget", true);

    }

    setState(() {
      isSaving = false;
    });

  }

  void showMessage(String text, [bool error = false]) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );

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

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text("Category"),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(

              value: selectedCategory,

              hint: const Text("Select Category"),

              items: categories.map((cat) {

                return DropdownMenuItem<String>(

                  value: cat["id"].toString(),

                  child: Text(cat["name"] ?? ""),

                );

              }).toList(),

              onChanged: (value) {

                setState(() {
                  selectedCategory = value;
                });

              },

            ),

            const SizedBox(height: 20),

            const Text("Budget Amount"),

            const SizedBox(height: 8),

            TextField(

              controller: amountController,

              keyboardType: TextInputType.number,

              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
              ],

              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter amount",
              ),

            ),

            const SizedBox(height: 20),

            const Text("Month"),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(

              value: selectedMonth,

              items: months.map((m) {

                return DropdownMenuItem(

                  value: m,

                  child: Text(m),

                );

              }).toList(),

              onChanged: (value) {

                setState(() {
                  selectedMonth = value!;
                });

              },

            ),

            const SizedBox(height: 20),

            const Text("Year"),

            const SizedBox(height: 8),

            DropdownButtonFormField<int>(

              value: selectedYear,

              items: years.map((y) {

                return DropdownMenuItem(

                  value: y,

                  child: Text(y.toString()),

                );

              }).toList(),

              onChanged: (value) {

                setState(() {
                  selectedYear = value!;
                });

              },

            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: isSaving ? null : saveBudget,

                child: isSaving
                    ? const CircularProgressIndicator()
                    : const Text("Save Budget"),

              ),

            )

          ],

        ),
      ),

    );

  }

}