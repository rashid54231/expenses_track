import 'package:flutter/material.dart';
import '../../../models/transaction_model.dart';
import '../controllers/transaction_controller.dart';
import 'add_transaction_screen.dart';
import 'transaction_detail_screen.dart';

class TransactionListScreen extends StatefulWidget {

  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {

  final TransactionController controller = TransactionController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Transactions"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddTransactionScreen(),
            ),
          );

          if(result != null){
            setState(() {
              controller.addTransaction(result);
            });
          }

        },
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(
        itemCount: controller.transactions.length,
        itemBuilder: (context,index){

          TransactionModel tx = controller.transactions[index];

          return ListTile(

            title: Text(tx.title),
            subtitle: Text(tx.date.toString()),

            trailing: Text(
              "\$${tx.amount}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold
              ),
            ),

            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TransactionDetailScreen(transaction: tx),
                ),
              );
            },

          );

        },
      ),

    );

  }
}