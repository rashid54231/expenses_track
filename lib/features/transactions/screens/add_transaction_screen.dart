import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen>
    with SingleTickerProviderStateMixin {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final notesController = TextEditingController();

  String selectedType = "Expense";
  String selectedCategory = "General";
  DateTime selectedDate = DateTime.now();
  bool _isSaving = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

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

  final _categories = [
    {"label": "General",   "icon": Icons.grid_view_rounded},
    {"label": "Food",      "icon": Icons.restaurant_rounded},
    {"label": "Transport", "icon": Icons.directions_car_rounded},
    {"label": "Shopping",  "icon": Icons.shopping_bag_rounded},
    {"label": "Salary",    "icon": Icons.account_balance_wallet_rounded},
    {"label": "Bills",     "icon": Icons.receipt_long_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim  = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.07),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    titleController.dispose();
    amountController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Color get _typeColor => selectedType == "Income" ? _income : _expense;

  void pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: _accent,
            surface: _surface,
            onSurface: _textPri,
          ),
          dialogBackgroundColor: _surfaceAlt,
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> save() async {
    if (titleController.text.isEmpty || amountController.text.isEmpty) {
      _showSnack("Please fill all required fields.", isError: true);
      return;
    }
    final amount = double.tryParse(amountController.text);
    if (amount == null) {
      _showSnack("Enter a valid amount.", isError: true);
      return;
    }

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    final transaction = TransactionModel(
      id: DateTime.now().toString(),
      title: titleController.text.trim(),
      amount: amount,
      categoryId: selectedCategory,
      type: selectedType,
      notes: notesController.text.trim(),
      date: selectedDate,
    );

    Navigator.pop(context, transaction);
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: const TextStyle(fontFamily: 'Georgia', color: Colors.white)),
        backgroundColor: isError ? _expense : _income,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
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
          icon: const Icon(Icons.close_rounded, color: _textSec, size: 22),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          "New Transaction",
          style: TextStyle(
            fontFamily: 'Georgia',
            color: _textPri,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: _isSaving ? null : save,
              style: TextButton.styleFrom(
                foregroundColor: _accent,
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
              child: const Text(
                "Save",
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),

      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Amount hero card ──────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: _border),
                    boxShadow: [
                      BoxShadow(
                        color: _typeColor.withOpacity(0.06),
                        blurRadius: 32,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Income / Expense toggle ──────────────
                      Container(
                        decoration: BoxDecoration(
                          color: _surfaceAlt,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: ["Expense", "Income"].map((type) {
                            final active = selectedType == type;
                            final col =
                            type == "Income" ? _income : _expense;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => selectedType = type),
                                child: AnimatedContainer(
                                  duration:
                                  const Duration(milliseconds: 250),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10),
                                  decoration: BoxDecoration(
                                    color: active
                                        ? col.withOpacity(0.15)
                                        : Colors.transparent,
                                    borderRadius:
                                    BorderRadius.circular(11),
                                    border: active
                                        ? Border.all(
                                        color: col.withOpacity(0.4),
                                        width: 1)
                                        : null,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        type == "Income"
                                            ? Icons.arrow_downward_rounded
                                            : Icons.arrow_upward_rounded,
                                        color: active ? col : _textSec,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        type,
                                        style: TextStyle(
                                          fontFamily: 'Georgia',
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w700,
                                          color:
                                          active ? col : _textSec,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Amount field ─────────────────────────
                      Text(
                        "AMOUNT",
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: _textSec,
                          letterSpacing: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "\$",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: _typeColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: TextField(
                              controller: amountController,
                              keyboardType:
                              const TextInputType.numberWithOptions(
                                  decimal: true),
                              style: TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 38,
                                fontWeight: FontWeight.w700,
                                color: _typeColor,
                                letterSpacing: -1,
                              ),
                              decoration: InputDecoration(
                                hintText: "0.00",
                                hintStyle: TextStyle(
                                  fontFamily: 'Georgia',
                                  fontSize: 38,
                                  fontWeight: FontWeight.w700,
                                  color: _typeColor.withOpacity(0.25),
                                  letterSpacing: -1,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}')),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Details card ──────────────────────────────
                _SectionCard(
                  children: [
                    _FieldLabel("TITLE"),
                    const SizedBox(height: 8),
                    _styledField(
                      controller: titleController,
                      hint: "e.g. Grocery run",
                      icon: Icons.edit_rounded,
                    ),
                    _divider(),
                    _FieldLabel("NOTES (OPTIONAL)"),
                    const SizedBox(height: 8),
                    _styledField(
                      controller: notesController,
                      hint: "Add a note...",
                      icon: Icons.notes_rounded,
                      maxLines: 2,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Category picker ───────────────────────────
                _SectionCard(
                  children: [
                    _FieldLabel("CATEGORY"),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((cat) {
                        final label = cat["label"] as String;
                        final icon  = cat["icon"]  as IconData;
                        final active = selectedCategory == label;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => selectedCategory = label),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 9),
                            decoration: BoxDecoration(
                              color: active
                                  ? _accent.withOpacity(0.15)
                                  : _surfaceAlt,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: active
                                    ? _accent.withOpacity(0.5)
                                    : _border,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(icon,
                                    size: 14,
                                    color: active ? _accent : _textSec),
                                const SizedBox(width: 6),
                                Text(
                                  label,
                                  style: TextStyle(
                                    fontFamily: 'Georgia',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: active ? _accent : _textSec,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Date picker ───────────────────────────────
                _SectionCard(
                  children: [
                    _FieldLabel("DATE"),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: pickDate,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _accent.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.calendar_today_rounded,
                                color: _accent, size: 18),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              _formatDate(selectedDate),
                              style: const TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 15.5,
                                fontWeight: FontWeight.w600,
                                color: _textPri,
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded,
                              color: _textSec, size: 20),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ── Save CTA ──────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accent,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: _accent.withOpacity(0.4),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check_circle_outline_rounded,
                            size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Save Transaction",
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _styledField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        fontFamily: 'Georgia',
        fontSize: 14.5,
        color: _textPri,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
        const TextStyle(fontFamily: 'Georgia', color: _textSec, fontSize: 14.5),
        prefixIcon: Icon(icon, color: _textSec, size: 18),
        filled: true,
        fillColor: _surfaceAlt,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _accent, width: 1.5),
        ),
      ),
    );
  }

  Widget _divider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
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