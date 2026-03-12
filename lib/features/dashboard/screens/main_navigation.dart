import 'package:flutter/material.dart';
import '../../transactions/screens/transaction_list_screen.dart';
import '../../categories/screens/category_list_screen.dart';
import '../../accounts/screens/account_list_screen.dart';
import 'dashboard_screen.dart';

class MainNavigation extends StatefulWidget {

  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {

  int index = 0;

  final screens = [
    const DashboardScreen(),
    const TransactionListScreen(),
    const CategoryListScreen(),
    const AccountListScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: screens[index],

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: index,

        onTap: (i){
          setState(() {
            index = i;
          });
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: "Transactions",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Categories",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: "Accounts",
          ),

        ],

      ),

    );

  }
}