import 'package:flutter/material.dart';

class ApprovalScreen extends StatelessWidget {

  const ApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Approvals"),
      ),

      body: ListView(

        children: const [

          ListTile(
            title: Text("Transaction Approval"),
            subtitle: Text("Expense: \$200"),
            trailing: Icon(Icons.check_circle, color: Colors.green),
          ),

          ListTile(
            title: Text("Budget Approval"),
            subtitle: Text("Requested Budget: \$500"),
            trailing: Icon(Icons.pending, color: Colors.orange),
          ),

        ],

      ),

    );

  }
}