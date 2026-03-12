import 'package:flutter/material.dart';
import '../../../models/transaction_model.dart';
import '../controllers/recurring_controller.dart';
import 'create_recurring_screen.dart';

class RecurringListScreen extends StatefulWidget {
  const RecurringListScreen({super.key});

  @override
  State<RecurringListScreen> createState() => _RecurringListScreenState();
}

class _RecurringListScreenState extends State<RecurringListScreen> {

  final RecurringController controller = RecurringController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Recurring Transactions"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateRecurringScreen(),
            ),
          );

          if(result != null){
            setState(() {
              controller.addRecurring(result);
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

            subtitle: const Text("Repeats Monthly"),

            trailing: Text("\$${tx.amount}"),

          );

        },

      ),

    );

  }

}