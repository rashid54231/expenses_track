import 'package:flutter/material.dart';
import '../../../models/account_model.dart';

class AddAccountScreen extends StatefulWidget {

  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {

  final nameController = TextEditingController();
  final balanceController = TextEditingController();

  void save(){

    final account = AccountModel(
      id: DateTime.now().toString(),
      name: nameController.text,
      balance: double.parse(balanceController.text),
    );

    Navigator.pop(context, account);

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Add Account"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                  labelText: "Account Name"
              ),
            ),

            const SizedBox(height:20),

            TextField(
              controller: balanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: "Initial Balance"
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