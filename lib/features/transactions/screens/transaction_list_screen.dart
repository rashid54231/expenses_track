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

  double get totalIncome {
    return controller.transactions
        .where((t) => t.type == "Income")
        .fold(0, (sum, t) => sum + t.amount);
  }

  double get totalExpense {
    return controller.transactions
        .where((t) => t.type == "Expense")
        .fold(0, (sum, t) => sum + t.amount);
  }

  Future<void> refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFF0A0914),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0A0914),
        title: const Text(
          "Transactions",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6C5CE7),
        onPressed: () async {

          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddTransactionScreen(),
            ),
          );

          if (result != null) {
            setState(() {
              controller.addTransaction(result);
            });
          }

        },
        child: const Icon(Icons.add),
      ),

      body: RefreshIndicator(

        onRefresh: refresh,

        child: Column(
          children: [

            /// SUMMARY CARD
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFF3ECFAA)],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Income",
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        "\$${totalIncome.toStringAsFixed(2)}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Expense",
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        "\$${totalExpense.toStringAsFixed(2)}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// TRANSACTION LIST
            Expanded(
              child: controller.transactions.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long,
                        size: 60,
                        color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      "No Transactions Yet",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
                  : ListView.builder(

                itemCount: controller.transactions.length,

                itemBuilder: (context, index) {

                  TransactionModel tx =
                  controller.transactions[index];

                  Color amountColor =
                  tx.type == "Income"
                      ? Colors.green
                      : Colors.red;

                  return Dismissible(

                    key: Key(tx.id),

                    direction: DismissDirection.endToStart,

                    confirmDismiss: (_) async {

                      return await showDialog(
                        context: context,
                        builder: (context) {

                          return AlertDialog(
                            title: const Text("Delete Transaction"),
                            content: const Text(
                                "Are you sure you want to delete this transaction?"),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, true),
                                child: const Text("Delete"),
                              ),
                            ],
                          );

                        },
                      );
                    },

                    onDismissed: (_) {

                      setState(() {
                        controller.transactions.removeAt(index);
                      });

                    },

                    background: Container(
                      alignment: Alignment.centerRight,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),

                    child: Card(
                      color: const Color(0xFF13122A),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: ListTile(

                        leading: CircleAvatar(
                          backgroundColor:
                          amountColor.withOpacity(0.15),
                          child: Icon(
                            tx.type == "Income"
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: amountColor,
                          ),
                        ),

                        title: Text(
                          tx.title,
                          style: const TextStyle(color: Colors.white),
                        ),

                        subtitle: Text(
                          DateFormat("dd MMM yyyy")
                              .format(tx.date),
                          style:
                          const TextStyle(color: Colors.grey),
                        ),

                        trailing: Text(
                          "${tx.type == "Income" ? "+" : "-"} \$${tx.amount}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: amountColor,
                            fontSize: 16,
                          ),
                        ),

                        onTap: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  TransactionDetailScreen(
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
            ),
          ],
        ),
      ),
    );
  }
}