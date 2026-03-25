import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/transaction_model.dart';

class TransactionDetailScreen extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailScreen({
    super.key,
    required this.transaction,
  });

  // ── Design tokens ─────────────────────────────────────────
  static const _bg         = Color(0xFF0F0F14);
  static const _surface    = Color(0xFF1A1A24);
  static const _surfaceAlt = Color(0xFF22222F);
  static const _border     = Color(0xFF2E2E3E);
  static const _textPri    = Color(0xFFF0EEF8);
  static const _textSec    = Color(0xFF8B8A9E);
  static const _income     = Color(0xFF34D399);
  static const _expense    = Color(0xFFFC6D6D);
  static const _accent     = Color(0xFF7C6DFA);
  // ──────────────────────────────────────────────────────────

  bool get _isIncome => transaction.type.toLowerCase() == "income";
  Color get _typeColor => _isIncome ? _income : _expense;

  String _formatDate(DateTime d) {
    const months = [
      'January','February','March','April','May','June',
      'July','August','September','October','November','December'
    ];
    const days = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
    return '${days[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  String _formatAmount(double amount) {
    final abs = amount.abs();
    if (abs == abs.roundToDouble()) {
      return abs.toStringAsFixed(0);
    }
    return abs.toStringAsFixed(2);
  }

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':      return Icons.restaurant_rounded;
      case 'transport': return Icons.directions_car_rounded;
      case 'shopping':  return Icons.shopping_bag_rounded;
      case 'salary':    return Icons.account_balance_wallet_rounded;
      case 'bills':     return Icons.receipt_long_rounded;
      default:          return Icons.grid_view_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF8B8A9E), size: 18),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          "Transaction Detail",
          style: TextStyle(
            fontFamily: 'Georgia',
            color: Color(0xFFF0EEF8),
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded,
                color: Color(0xFF8B8A9E), size: 22),
            onPressed: () {},
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Hero amount card ──────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _border),
                boxShadow: [
                  BoxShadow(
                    color: _typeColor.withOpacity(0.08),
                    blurRadius: 40,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [

                  // ── Type badge ─────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: _typeColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: _typeColor.withOpacity(0.35), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isIncome
                              ? Icons.arrow_downward_rounded
                              : Icons.arrow_upward_rounded,
                          color: _typeColor,
                          size: 13,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          transaction.type.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _typeColor,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Amount ─────────────────────────────
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: _isIncome ? "+\$" : "-\$",
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: _typeColor.withOpacity(0.7),
                          ),
                        ),
                        TextSpan(
                          text: _formatAmount(transaction.amount),
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 52,
                            fontWeight: FontWeight.w700,
                            color: _typeColor,
                            letterSpacing: -2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Title ──────────────────────────────
                  Text(
                    transaction.title,
                    style: const TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: _textPri,
                    ),
                    textAlign: TextAlign.center,
                  ),

                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Info rows card ────────────────────────────
            _SectionCard(
              children: [
                _InfoRow(
                  icon: Icons.calendar_today_rounded,
                  label: "Date",
                  value: _formatDate(transaction.date),
                ),
                _divider(),
                _InfoRow(
                  icon: _categoryIcon(transaction.categoryId),
                  label: "Category",
                  value: transaction.categoryId,
                ),
                _divider(),
                _InfoRow(
                  icon: _isIncome
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  label: "Type",
                  value: transaction.type,
                  valueColor: _typeColor,
                ),
              ],
            ),

            // ── Notes card (if present) ───────────────────
            if (transaction.notes != null &&
                transaction.notes!.trim().isNotEmpty) ...[
              const SizedBox(height: 16),
              _SectionCard(
                children: [
                  const _FieldLabel("NOTES"),
                  const SizedBox(height: 10),
                  Text(
                    transaction.notes!,
                    style: const TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 14.5,
                      color: _textPri,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 16),

            // ── Transaction ID card ───────────────────────
            _SectionCard(
              children: [
                const _FieldLabel("TRANSACTION ID"),
                const SizedBox(height: 8),
                Text(
                  transaction.id,
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 12.5,
                    color: _textSec,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ── Delete button ─────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: _surface,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: const Text(
                        "Delete Transaction",
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          color: _textPri,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      content: const Text(
                        "Are you sure you want to delete this transaction? This action cannot be undone.",
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          color: _textSec,
                          height: 1.5,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text("Cancel",
                              style: TextStyle(
                                  fontFamily: 'Georgia', color: _textSec)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.pop(context);
                          },
                          child: const Text("Delete",
                              style: TextStyle(
                                  fontFamily: 'Georgia',
                                  color: _expense,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete_outline_rounded,
                    size: 18, color: _expense),
                label: const Text(
                  "Delete Transaction",
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: _expense,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: _expense.withOpacity(0.4), width: 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Divider(color: _border, height: 1),
  );
}

// ── Shared widgets ─────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final List<Widget> children;
  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2E2E3E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: const Color(0xFF22222F),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon,
                color: const Color(0xFF8B8A9E), size: 16),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 11,
                    color: Color(0xFF8B8A9E),
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? const Color(0xFFF0EEF8),
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

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Georgia',
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        color: Color(0xFF8B8A9E),
        letterSpacing: 1.4,
      ),
    );
  }
}