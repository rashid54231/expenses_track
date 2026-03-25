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

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // ── Design tokens ─────────────────────────────────────────
  static const _bg          = Color(0xFF080810);
  static const _surface     = Color(0xFF10101E);
  static const _surfaceAlt  = Color(0xFF16162A);
  static const _border      = Color(0xFF1E1E36);
  static const _accent      = Color(0xFF7C6DFA);
  static const _accentGlow  = Color(0x337C6DFA);
  static const _income      = Color(0xFF34D399);
  static const _expense     = Color(0xFFFC6D6D);
  static const _gold        = Color(0xFFFBBF24);
  static const _textPri     = Color(0xFFF0EEF8);
  static const _textSec     = Color(0xFF6B6A82);
  static const _textMid     = Color(0xFFAFADC8);
  // ──────────────────────────────────────────────────────────

  double totalBalance = 12450.00;
  double income       = 5240.00;
  double expense      = 2890.00;
  double savingsRate  = 0.72; // 72%
  int notificationCount = 2;

  final List<Map<String, dynamic>> navItems = [
    {"title": "Transactions", "subtitle": "24 this month", "icon": Icons.swap_horiz_rounded,       "color": Color(0xFF7C6DFA), "screen": const TransactionListScreen()},
    {"title": "Categories",   "subtitle": "8 active",       "icon": Icons.grid_view_rounded,        "color": Color(0xFF34D399), "screen": const CategoryListScreen()},
    {"title": "Accounts",     "subtitle": "3 linked",       "icon": Icons.account_balance_rounded,  "color": Color(0xFFFBBF24), "screen": const AccountListScreen()},
    {"title": "Budgets",      "subtitle": "5 budgets",      "icon": Icons.donut_large_rounded,      "color": Color(0xFFFC6D6D), "screen": const BudgetListScreen()},
    {"title": "Tags",         "subtitle": "12 tags",        "icon": Icons.label_rounded,            "color": Color(0xFF38BDF8), "screen": const TagListScreen()},
    {"title": "Recurring",    "subtitle": "6 active",       "icon": Icons.autorenew_rounded,        "color": Color(0xFFA78BFA), "screen": const RecurringListScreen()},
    {"title": "Notifications","subtitle": "2 new",          "icon": Icons.notifications_rounded,    "color": Color(0xFFFB923C), "screen": const NotificationScreen()},
    {"title": "Approvals",    "subtitle": "1 pending",      "icon": Icons.check_circle_rounded,     "color": Color(0xFF2DD4BF), "screen": const ApprovalScreen()},
  ];

  final List<Map<String, dynamic>> recentTransactions = [
    {"title": "Grocery Store",    "category": "Food",      "amount": -20.50,  "icon": Icons.restaurant_rounded,           "date": "Today"},
    {"title": "Monthly Salary",   "category": "Salary",    "amount": 500.00,  "icon": Icons.account_balance_wallet_rounded,"date": "Today"},
    {"title": "Uber Ride",        "category": "Transport", "amount": -12.00,  "icon": Icons.directions_car_rounded,       "date": "Yesterday"},
    {"title": "Netflix",          "category": "Bills",     "amount": -15.99,  "icon": Icons.subscriptions_rounded,        "date": "Mon"},
  ];

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim  = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _fmt(double v) {
    if (v >= 1000) {
      return '\$${(v / 1000).toStringAsFixed(1)}k';
    }
    return '\$${v.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: _bg,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [

              // ── App Bar ───────────────────────────────────
              SliverAppBar(
                pinned: true,
                backgroundColor: _bg,
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle.light,
                expandedHeight: 0,
                toolbarHeight: 64,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(color: _bg),
                ),
                title: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C6DFA), Color(0xFF34D399)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "JD",
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          "Good morning,",
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            color: Color(0xFF6B6A82),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "John Doe",
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            color: Color(0xFFF0EEF8),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  // Search
                  _AppBarIcon(
                    icon: Icons.search_rounded,
                    onTap: () {},
                  ),
                  const SizedBox(width: 8),
                  // Notification with badge
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      _AppBarIcon(
                        icon: Icons.notifications_outlined,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const NotificationScreen()),
                        ),
                      ),
                      if (notificationCount > 0)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 17,
                            height: 17,
                            decoration: BoxDecoration(
                              color: _expense,
                              shape: BoxShape.circle,
                              border: Border.all(color: _bg, width: 2),
                            ),
                            child: Center(
                              child: Text(
                                notificationCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                ],
              ),

              // ── Body ──────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ── Balance Hero Card ──────────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1E1250), Color(0xFF0E1A2E)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(color: _border, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: _accentGlow,
                              blurRadius: 48,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Label row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    "TOTAL BALANCE",
                                    style: TextStyle(
                                      fontFamily: 'Georgia',
                                      color: Colors.white60,
                                      fontSize: 10,
                                      letterSpacing: 1.3,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: _income.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: _income.withOpacity(0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.trending_up_rounded,
                                          color: _income, size: 12),
                                      const SizedBox(width: 4),
                                      Text(
                                        "+${(savingsRate * 100).toStringAsFixed(0)}%",
                                        style: TextStyle(
                                          fontFamily: 'Georgia',
                                          color: _income,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Amount
                            Text(
                              "\$${totalBalance.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 44,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -1.5,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "Updated just now",
                              style: TextStyle(
                                fontFamily: 'Georgia',
                                color: Colors.white.withOpacity(0.35),
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Divider
                            Divider(
                                color: Colors.white.withOpacity(0.08),
                                height: 1),

                            const SizedBox(height: 20),

                            // Income / Expense / Savings row
                            Row(
                              children: [
                                _BalanceStat(
                                  label: "Income",
                                  value: _fmt(income),
                                  color: _income,
                                  icon: Icons.arrow_downward_rounded,
                                ),
                                _VertDivider(),
                                _BalanceStat(
                                  label: "Expense",
                                  value: _fmt(expense),
                                  color: _expense,
                                  icon: Icons.arrow_upward_rounded,
                                ),
                                _VertDivider(),
                                _BalanceStat(
                                  label: "Savings",
                                  value: _fmt(income - expense),
                                  color: _gold,
                                  icon: Icons.savings_rounded,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Quick stat chips ───────────────────
                      Row(
                        children: [
                          _StatChip(
                            label: "This Month",
                            value: "\$2,890",
                            delta: "+12%",
                            positive: false,
                          ),
                          const SizedBox(width: 10),
                          _StatChip(
                            label: "Avg / Day",
                            value: "\$93",
                            delta: "-4%",
                            positive: true,
                          ),
                          const SizedBox(width: 10),
                          _StatChip(
                            label: "Top Category",
                            value: "Food",
                            delta: "42%",
                            positive: false,
                            isText: true,
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // ── Section header ─────────────────────
                      _SectionHeader(
                        title: "Spending Overview",
                        actionLabel: "All time",
                        onTap: () {},
                      ),

                      const SizedBox(height: 12),

                      // ── Chart card ─────────────────────────
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                        decoration: BoxDecoration(
                          color: _surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: _border),
                        ),
                        child: const ExpenseChart(),
                      ),

                      const SizedBox(height: 28),

                      // ── Recent Transactions ────────────────
                      _SectionHeader(
                        title: "Recent Transactions",
                        actionLabel: "See all",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const TransactionListScreen()),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Container(
                        decoration: BoxDecoration(
                          color: _surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: _border),
                        ),
                        child: Column(
                          children: List.generate(
                            recentTransactions.length,
                                (i) {
                              final tx = recentTransactions[i];
                              final isIncome = (tx["amount"] as double) > 0;
                              final color = isIncome ? _income : _expense;
                              final isLast =
                                  i == recentTransactions.length - 1;
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 14),
                                    child: Row(
                                      children: [
                                        // Icon container
                                        Container(
                                          width: 42,
                                          height: 42,
                                          decoration: BoxDecoration(
                                            color: color.withOpacity(0.1),
                                            borderRadius:
                                            BorderRadius.circular(13),
                                          ),
                                          child: Icon(
                                            tx["icon"] as IconData,
                                            color: color,
                                            size: 18,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // Title + category
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                tx["title"] as String,
                                                style: const TextStyle(
                                                  fontFamily: 'Georgia',
                                                  color: _textPri,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Row(
                                                children: [
                                                  Text(
                                                    tx["category"] as String,
                                                    style: const TextStyle(
                                                      fontFamily: 'Georgia',
                                                      color: _textSec,
                                                      fontSize: 11.5,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Container(
                                                    width: 3,
                                                    height: 3,
                                                    decoration: const BoxDecoration(
                                                      color: _textSec,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    tx["date"] as String,
                                                    style: const TextStyle(
                                                      fontFamily: 'Georgia',
                                                      color: _textSec,
                                                      fontSize: 11.5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Amount
                                        Text(
                                          "${isIncome ? '+' : '-'}\$${(tx["amount"] as double).abs().toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontFamily: 'Georgia',
                                            color: color,
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!isLast)
                                    Divider(
                                      height: 1,
                                      color: _border,
                                      indent: 70,
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Quick Actions header ───────────────
                      _SectionHeader(
                        title: "Quick Actions",
                        actionLabel: "",
                        onTap: null,
                      ),

                      const SizedBox(height: 14),
                    ],
                  ),
                ),
              ),

              // ── Nav Grid ──────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.55,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final item = navItems[index];
                      final color = item["color"] as Color;
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => item["screen"] as Widget),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Icon badge
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  item["icon"] as IconData,
                                  color: color,
                                  size: 18,
                                ),
                              ),
                              // Title + subtitle
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["title"] as String,
                                    style: const TextStyle(
                                      fontFamily: 'Georgia',
                                      color: _textPri,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item["subtitle"] as String,
                                    style: const TextStyle(
                                      fontFamily: 'Georgia',
                                      color: _textSec,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: navItems.length,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 48)),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shared widgets ─────────────────────────────────────────────

class _AppBarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _AppBarIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFF10101E),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: const Color(0xFF1E1E36)),
        ),
        child: Icon(icon, color: const Color(0xFF8B8A9E), size: 18),
      ),
    );
  }
}

class _BalanceStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  const _BalanceStat(
      {required this.label,
        required this.value,
        required this.color,
        required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 11),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Georgia',
                  color: Colors.white54,
                  fontSize: 10.5,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Georgia',
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: Colors.white.withOpacity(0.08),
      margin: const EdgeInsets.symmetric(horizontal: 12),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final String delta;
  final bool positive;
  final bool isText;

  const _StatChip({
    required this.label,
    required this.value,
    required this.delta,
    required this.positive,
    this.isText = false,
  });

  @override
  Widget build(BuildContext context) {
    final deltaColor =
    isText ? const Color(0xFF7C6DFA) : (positive ? const Color(0xFF34D399) : const Color(0xFFFC6D6D));

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF10101E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1E1E36)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Georgia',
                color: Color(0xFF6B6A82),
                fontSize: 10,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Georgia',
                color: Color(0xFFF0EEF8),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              delta,
              style: TextStyle(
                fontFamily: 'Georgia',
                color: deltaColor,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback? onTap;

  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Georgia',
            color: Color(0xFFF0EEF8),
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        if (actionLabel.isNotEmpty && onTap != null)
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF7C6DFA).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: const Color(0xFF7C6DFA).withOpacity(0.25)),
              ),
              child: Text(
                actionLabel,
                style: const TextStyle(
                  fontFamily: 'Georgia',
                  color: Color(0xFF7C6DFA),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}