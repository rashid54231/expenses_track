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

// ─────────────────────────────────────────────────────────────────────────────
// THEME CONSTANTS
// ─────────────────────────────────────────────────────────────────────────────
class _AppColors {
  static const bg         = Color(0xFF0A0914);
  static const surface    = Color(0xFF13122A);
  static const surfaceAlt = Color(0xFF1A1932);
  static const border     = Color(0xFF252440);
  static const primary    = Color(0xFF7C6FFF);
  static const teal       = Color(0xFF3ECFAA);
  static const textPrimary   = Colors.white;
  static const textSecondary = Color(0xFF8B8AA8);
  static const textMuted     = Color(0xFF4E4D6C);
}

// ─────────────────────────────────────────────────────────────────────────────
// NAV ITEM MODEL
// ─────────────────────────────────────────────────────────────────────────────
class _NavItem {
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  const _NavItem(this.label, this.subtitle, this.icon, this.color);
}

// ─────────────────────────────────────────────────────────────────────────────
// DASHBOARD SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {

  late final ScrollController _scrollController;
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;
  bool _scrolled = false;

  static const _navItems = <_NavItem>[
    _NavItem('Transactions', '24 this month',  Icons.swap_horiz_rounded,    Color(0xFF7C6FFF)),
    _NavItem('Categories',   '8 active',        Icons.grid_view_rounded,     Color(0xFF3ECFAA)),
    _NavItem('Accounts',     '3 linked',        Icons.account_balance_rounded,Color(0xFFFF6B8A)),
    _NavItem('Budgets',      '5 budgets',       Icons.pie_chart_rounded,     Color(0xFFFFAA44)),
    _NavItem('Tags',         '12 tags',         Icons.label_rounded,         Color(0xFF4FC3F7)),
    _NavItem('Recurring',    '6 active',        Icons.autorenew_rounded,     Color(0xFFA78BFA)),
    _NavItem('Notifications','2 new',           Icons.notifications_rounded, Color(0xFF34D399)),
    _NavItem('Approvals',    '1 pending',       Icons.check_circle_rounded,  Color(0xFFF472B6)),
  ];

  List<Widget> get _screens => const [
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
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        final isScrolled = _scrollController.offset > 20;
        if (isScrolled != _scrolled) setState(() => _scrolled = isScrolled);
      });

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));

    final mq     = MediaQuery.of(context);
    final width  = mq.size.width;
    final isWide = width >= 600; // tablet breakpoint
    final hPad   = isWide ? 28.0 : 20.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _AppColors.bg,
        body: FadeTransition(
          opacity: _fadeAnim,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              // ── App Bar ────────────────────────────────────────────────
              _AppBarSliver(scrolled: _scrolled, hPad: hPad),

              // ── Content ────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // Balance Card
                      const _BalanceCard(),
                      const SizedBox(height: 20),

                      // Quick Stats Row
                      const _QuickStatsRow(),
                      const SizedBox(height: 24),

                      // Chart
                      _SectionHeader(
                        title: 'Spending Overview',
                        onSeeAll: () {},
                      ),
                      const SizedBox(height: 12),
                      const _ChartCard(),
                      const SizedBox(height: 28),

                      // Quick Actions header
                      _SectionHeader(
                        title: 'Quick Actions',
                        onSeeAll: () {},
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              // ── Nav Grid ───────────────────────────────────────────────
              SliverPadding(
                padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 40),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isWide ? 3 : 2,
                    mainAxisSpacing:  14,
                    crossAxisSpacing: 14,
                    childAspectRatio: isWide ? 1.25 : 1.15,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (ctx, i) => _NavCard(
                      item:   _navItems[i],
                      screen: _screens[i],
                      index:  i,
                    ),
                    childCount: _navItems.length,
                  ),
                ),
              ),

              // Safe-area bottom padding
              SliverToBoxAdapter(
                child: SizedBox(height: mq.padding.bottom + 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// APP BAR SLIVER
// ─────────────────────────────────────────────────────────────────────────────
class _AppBarSliver extends StatelessWidget {
  final bool scrolled;
  final double hPad;
  const _AppBarSliver({required this.scrolled, required this.hPad});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return SliverAppBar(
      expandedHeight: 180,
      floating:  false,
      pinned:    true,
      elevation: 0,
      backgroundColor: scrolled
          ? _AppColors.surface.withAlpha(230)
          : Colors.transparent,
      surfaceTintColor: Colors.transparent,
      title: AnimatedOpacity(
        opacity: scrolled ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: const Text(
          'Finance',
          style: TextStyle(
            color: _AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: _AppColors.textSecondary, size: 22),
          onPressed: () {},
        ),
        Padding(
          padding: EdgeInsets.only(right: hPad - 8),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [_AppColors.primary, _AppColors.teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _AppColors.primary.withAlpha(100),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                'A',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: _HeaderBanner(topPad: topPad, hPad: hPad),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HEADER BANNER
// ─────────────────────────────────────────────────────────────────────────────
class _HeaderBanner extends StatelessWidget {
  final double topPad;
  final double hPad;
  const _HeaderBanner({required this.topPad, required this.hPad});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1840), Color(0xFF0A0914)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          // Decorative blobs
          Positioned(
            top: topPad - 10,
            right: -30,
            child: _GlowBlob(size: 160, color: _AppColors.primary.withAlpha(50)),
          ),
          Positioned(
            bottom: 20,
            left: -20,
            child: _GlowBlob(size: 110, color: _AppColors.teal.withAlpha(35)),
          ),

          // Greeting content
          Positioned(
            bottom: 20,
            left: hPad,
            right: hPad,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _AppColors.primary.withAlpha(40),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _AppColors.primary.withAlpha(80),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.wb_sunny_rounded,
                              color: _AppColors.teal, size: 12),
                          SizedBox(width: 5),
                          Text(
                            'Good morning',
                            style: TextStyle(
                              color: _AppColors.teal,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Alex Johnson',
                  style: TextStyle(
                    color: _AppColors.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    height: 1.1,
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

class _GlowBlob extends StatelessWidget {
  final double size;
  final Color color;
  const _GlowBlob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    width:  size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
      boxShadow: [
        BoxShadow(color: color, blurRadius: size * 0.6, spreadRadius: 4),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// BALANCE CARD
// ─────────────────────────────────────────────────────────────────────────────
class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFF3ECFAA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C5CE7).withAlpha(100),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Balance',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.6,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(35),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up_rounded,
                        color: Colors.white, size: 13),
                    SizedBox(width: 4),
                    Text(
                      '+3.2%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            '\$12,450.00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.0,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: Colors.white.withAlpha(40),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _BalanceStat(
                label: 'Income',
                amount: '\$5,240',
                icon: Icons.arrow_downward_rounded,
                iconColor: const Color(0xFF3ECFAA),
              ),
              Container(
                width: 1,
                height: 32,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                color: Colors.white.withAlpha(40),
              ),
              _BalanceStat(
                label: 'Expenses',
                amount: '\$2,890',
                icon: Icons.arrow_upward_rounded,
                iconColor: const Color(0xFFFF6B8A),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceStat extends StatelessWidget {
  final String label;
  final String amount;
  final IconData icon;
  final Color iconColor;
  const _BalanceStat({
    required this.label,
    required this.amount,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withAlpha(50),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 14),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// QUICK STATS ROW
// ─────────────────────────────────────────────────────────────────────────────
class _QuickStatsRow extends StatelessWidget {
  const _QuickStatsRow();

  static const _stats = [
    ('Savings',  '\$4,200', Icons.savings_rounded,      Color(0xFF7C6FFF)),
    ('Invested', '\$8,100', Icons.show_chart_rounded,   Color(0xFF3ECFAA)),
    ('Credit',   '\$1,500', Icons.credit_card_rounded,  Color(0xFFFFAA44)),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _stats
          .map(
            (s) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: s == _stats.last ? 0 : 10,
            ),
            child: _StatPill(
              label: s.$1,
              value: s.$2,
              icon:  s.$3,
              color: s.$4,
            ),
          ),
        ),
      )
          .toList(),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatPill({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: _AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: _AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: _AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CHART CARD
// ─────────────────────────────────────────────────────────────────────────────
class _ChartCard extends StatelessWidget {
  const _ChartCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _AppColors.border),
      ),
      child: const ExpenseChart(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION HEADER
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  const _SectionHeader({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _AppColors.primary.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'See all',
              style: TextStyle(
                color: _AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NAV CARD
// ─────────────────────────────────────────────────────────────────────────────
class _NavCard extends StatefulWidget {
  final _NavItem item;
  final Widget screen;
  final int index;
  const _NavCard({
    required this.item,
    required this.screen,
    required this.index,
  });

  @override
  State<_NavCard> createState() => _NavCardState();
}

class _NavCardState extends State<_NavCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.04,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTap() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => widget.screen,
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.04, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
            child: child,
          ),
        ),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp:   (_) { _ctrl.reverse(); _onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            color: _AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _AppColors.border),
            boxShadow: [
              BoxShadow(
                color: item.color.withAlpha(20),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon with glow background
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: item.color.withAlpha(35),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: item.color.withAlpha(60),
                    width: 1,
                  ),
                ),
                child: Icon(item.icon, color: item.color, size: 20),
              ),

              // Label + Subtitle + Arrow
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: const TextStyle(
                      color: _AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      letterSpacing: 0.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.subtitle,
                          style: const TextStyle(
                            color: _AppColors.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: item.color.withAlpha(180),
                        size: 11,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}