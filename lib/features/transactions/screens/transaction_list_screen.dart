import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

      body: controller.transactions.isEmpty
          ? const Center(
        child: Text("No Transactions Yet"),
      )
          : ListView.builder(
        itemCount: controller.transactions.length,
        itemBuilder: (context,index){

          TransactionModel tx = controller.transactions[index];

          Color amountColor =
          tx.type == "Income" ? Colors.green : Colors.red;

          return Dismissible(
            key: Key(tx.id),
            direction: DismissDirection.endToStart,
            onDismissed: (_) {
              setState(() {
                controller.transactions.removeAt(index);
              });
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal:20),
              color: Colors.red,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: Card(
              margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6
              ),
              child: ListTile(

                leading: CircleAvatar(
                  backgroundColor: amountColor.withOpacity(0.15),
                  child: Icon(
                    tx.type == "Income"
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: amountColor,
                  ),
                ),

                title: Text(tx.title),

                subtitle: Text(
                  DateFormat("dd MMM yyyy").format(tx.date),
                ),

                trailing: Text(
                  "${tx.type == "Income" ? "+" : "-"} \$${tx.amount}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: amountColor,
                    fontSize: 16,
                  ),
                ),

                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TransactionDetailScreen(
                        transaction: tx,
                      ),
                    ),
                  );
                },

              ),
            ),
          );

        },
      ),

    );

  }
}