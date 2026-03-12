import 'package:flutter/material.dart';
import '../../../models/account_model.dart';
import '../controllers/account_controller.dart';
import 'add_account_screen.dart';

class AccountListScreen extends StatefulWidget {

  const AccountListScreen({super.key});

  @override
  State<AccountListScreen> createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {

  final AccountController controller = AccountController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Accounts"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddAccountScreen(),
            ),
          );

          if(result != null){
            setState(() {
              controller.addAccount(result);
            });
          }

        },
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(
        itemCount: controller.accounts.length,
        itemBuilder: (context,index){

          AccountModel acc = controller.accounts[index];

          return ListTile(
            title: Text(acc.name),
            trailing: Text("\$${acc.balance}"),
          );

        },
      ),

    );

  }
}