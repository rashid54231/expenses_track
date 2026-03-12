import 'package:flutter/material.dart';

import '../../transactions/screens/transaction_list_screen.dart';
import '../../categories/screens/category_list_screen.dart';
import '../../accounts/screens/account_list_screen.dart';
import '../../budgets/screens/budget_list_screen.dart';
import '../../tags/screens/tag_list_screen.dart';
import '../../recurring_transactions/screens/recurring_list_screen.dart';
import '../../notifications/screens/notification_screen.dart';
import '../../approvals/screens/approval_screen.dart';

import '../../../widgets/expense_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // ── Nav tile data ────────────────────────────────────────────────────────
  static const List<_NavItem> _navItems = [
    _NavItem('Transactions', Icons.swap_horiz_rounded, Color(0xFF6C63FF)),
    _NavItem('Categories', Icons.grid_view_rounded, Color(0xFF43C6AC)),
    _NavItem('Accounts', Icons.account_balance_rounded, Color(0xFFFF6584)),
    _NavItem('Budgets', Icons.pie_chart_rounded, Color(0xFFFFA040)),
    _NavItem('Tags', Icons.label_rounded, Color(0xFF4FC3F7)),
    _NavItem('Recurring', Icons.autorenew_rounded, Color(0xFFA78BFA)),
    _NavItem('Notifications', Icons.notifications_rounded, Color(0xFF34D399)),
    _NavItem('Approvals', Icons.check_circle_rounded, Color(0xFFF472B6)),
  ];

  List<Widget> _buildScreens() => const [
    TransactionListScreen(),
    CategoryListScreen(),
    AccountListScreen(),
    BudgetListScreen(),
    TagListScreen(),
    RecurringListScreen(),
    NotificationScreen(),
    ApprovalScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final screens = _buildScreens();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E1A),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Collapsible App Bar ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF0F0E1A),
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: _HeaderBanner(width: size.width),
            ),
            title: const Text(
              'Finance',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: 0.5,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded, color: Colors.white70),
                onPressed: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFF6C63FF),
                  child: const Text(
                    'A',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Balance Card ─────────────────────────────────────────
                  const _BalanceCard(),

                  const SizedBox(height: 24),

                  // ── Chart Section ────────────────────────────────────────
                  _SectionHeader(title: 'Spending Overview'),
                  const SizedBox(height: 12),
                  _ChartCard(),

                  const SizedBox(height: 28),

                  // ── Quick Actions Grid ───────────────────────────────────
                  _SectionHeader(title: 'Quick Actions'),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // ── 2-column grid ────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.15,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, i) => _NavCard(
                  item: _navItems[i],
                  screen: screens[i],
                ),
                childCount: _navItems.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header Banner ─────────────────────────────────────────────────────────────

class _HeaderBanner extends StatelessWidget {
  final double width;
  const _HeaderBanner({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A183A), Color(0xFF0F0E1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative blobs
          Positioned(
            top: -30,
            right: -40,
            child: _Blob(size: 180, color: const Color(0xFF6C63FF).withOpacity(0.25)),
          ),
          Positioned(
            top: 60,
            left: -20,
            child: _Blob(size: 120, color: const Color(0xFF43C6AC).withOpacity(0.15)),
          ),
          // Greeting
          Positioned(
            bottom: 28,
            left: 22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Good morning 👋',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Alex Johnson',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}

// ── Balance Card ──────────────────────────────────────────────────────────────

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF43C6AC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Total Balance',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 6),
              Text(
                '\$12,450.00',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.arrow_upward_rounded,
                      color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text(
                    '+3.2% this month',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Chart Card ────────────────────────────────────────────────────────────────

class _ChartCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1B2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: const ExpenseChart(),
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        Text(
          'See all',
          style: TextStyle(
            color: const Color(0xFF6C63FF).withOpacity(0.9),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ── Nav Card ──────────────────────────────────────────────────────────────────

class _NavItem {
  final String label;
  final IconData icon;
  final Color color;
  const _NavItem(this.label, this.icon, this.color);
}

class _NavCard extends StatelessWidget {
  final _NavItem item;
  final Widget screen;
  const _NavCard({required this.item, required this.screen});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => screen),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1C1B2E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.color, size: 22),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      'Open',
                      style: TextStyle(
                        color: item.color.withOpacity(0.8),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: item.color.withOpacity(0.8),
                      size: 11,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}