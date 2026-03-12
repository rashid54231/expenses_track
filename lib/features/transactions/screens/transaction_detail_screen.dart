import 'package:flutter/material.dart';
import '../../../models/transaction_model.dart';

class TransactionDetailScreen extends StatelessWidget {

  final TransactionModel transaction;

  const TransactionDetailScreen({
    super.key,
    required this.transaction
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Transaction Detail"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              transaction.title,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
              ),
            ),

            const SizedBox(height:20),

            Text("Amount: \$${transaction.amount}"),

            const SizedBox(height:10),

            Text("Date: ${transaction.date}")

          ],

        ),

      ),

    );

  }
}