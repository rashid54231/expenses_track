import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../transactions/screens/transaction_list_screen.dart';
import '../../categories/screens/category_list_screen.dart';
import '../../accounts/screens/account_list_screen.dart';
import '../../budgets/screens/budget_list_screen.dart';
import '../../tags/screens/tag_list_screen.dart';
import '../../recurring_transactions/screens/recurring_list_screen.dart';
import '../../notifications/screens/notification_screen.dart';
import '../../approvals/screens/approval_screen.dart';
import '../../../widgets/expense_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final ScrollController _scrollController = ScrollController();

  // Dummy values (later from Supabase)
  double totalBalance = 12450;
  double income = 5240;
  double expense = 2890;

  int notificationCount = 2;

  final List<Map<String, dynamic>> navItems = [
    {"title":"Transactions","subtitle":"24 this month","icon":Icons.swap_horiz,"screen":const TransactionListScreen()},
    {"title":"Categories","subtitle":"8 active","icon":Icons.grid_view,"screen":const CategoryListScreen()},
    {"title":"Accounts","subtitle":"3 linked","icon":Icons.account_balance,"screen":const AccountListScreen()},
    {"title":"Budgets","subtitle":"5 budgets","icon":Icons.pie_chart,"screen":const BudgetListScreen()},
    {"title":"Tags","subtitle":"12 tags","icon":Icons.label,"screen":const TagListScreen()},
    {"title":"Recurring","subtitle":"6 active","icon":Icons.autorenew,"screen":const RecurringListScreen()},
    {"title":"Notifications","subtitle":"2 new","icon":Icons.notifications,"screen":const NotificationScreen()},
    {"title":"Approvals","subtitle":"1 pending","icon":Icons.check_circle,"screen":const ApprovalScreen()},
  ];

  final List<Map<String,dynamic>> recentTransactions = [
    {"title":"Food","amount":"- \$20"},
    {"title":"Salary","amount":"+ \$500"},
    {"title":"Uber","amount":"- \$12"},
  ];

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0A0914),

      body: CustomScrollView(
        controller: _scrollController,
        slivers: [

          /// APP BAR
          SliverAppBar(
            pinned: true,
            backgroundColor: const Color(0xFF0A0914),
            elevation: 0,
            title: const Text(
              "Finance",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [

              const Icon(Icons.search),

              const SizedBox(width: 16),

              /// Notification icon with badge
              Stack(
                children: [

                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context)=>const NotificationScreen(),
                        ),
                      );
                    },
                  ),

                  if(notificationCount>0)
                    Positioned(
                      right:6,
                      top:6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle
                        ),
                        child: Text(
                          notificationCount.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10
                          ),
                        ),
                      ),
                    )
                ],
              ),

              const SizedBox(width: 10),
            ],
          ),

          /// BODY
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// BALANCE CARD
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                            colors: [Color(0xFF6C5CE7),Color(0xFF3ECFAA)]
                        )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "Total Balance",
                          style: TextStyle(color: Colors.white70),
                        ),

                        const SizedBox(height:8),

                        Text(
                          "\$${totalBalance.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize:34,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),

                        const SizedBox(height:16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Income",style:TextStyle(color:Colors.white70)),
                                Text("\$$income",
                                    style: const TextStyle(color:Colors.white,fontSize:18))
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Expense",style:TextStyle(color:Colors.white70)),
                                Text("\$$expense",
                                    style: const TextStyle(color:Colors.white,fontSize:18))
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height:30),

                  /// CHART
                  const Text(
                    "Spending Overview",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize:18,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  const SizedBox(height:10),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF13122A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const ExpenseChart(),
                  ),

                  const SizedBox(height:30),

                  /// RECENT TRANSACTIONS
                  const Text(
                    "Recent Transactions",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize:18,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  const SizedBox(height:10),

                  Column(
                    children: recentTransactions.map((tx){

                      return ListTile(
                        title: Text(
                          tx["title"],
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: Text(
                          tx["amount"],
                          style: const TextStyle(color: Colors.white),
                        ),
                      );

                    }).toList(),
                  ),

                  const SizedBox(height:30),

                  const Text(
                    "Quick Actions",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize:18,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  const SizedBox(height:15),

                ],
              ),
            ),
          ),

          /// NAV GRID
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal:20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:2,
                  mainAxisSpacing:15,
                  crossAxisSpacing:15,
                  childAspectRatio:1.2
              ),
              delegate: SliverChildBuilderDelegate(

                      (context,index){

                    final item = navItems[index];

                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder:(context)=>item["screen"]
                          ),
                        );
                      },

                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF13122A),
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Icon(item["icon"],color:Colors.white),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  item["title"],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),

                                Text(
                                  item["subtitle"],
                                  style: const TextStyle(
                                      color: Colors.white60,
                                      fontSize:12
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },

                  childCount: navItems.length
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height:40),
          )
        ],
      ),
    );
  }
}