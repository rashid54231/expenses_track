import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // ── Design tokens ──────────────────────────────────────────
  static const _bg = Color(0xFFF7F5F2);
  static const _surface = Color(0xFFFFFFFF);
  static const _accent = Color(0xFF1A1A2E);
  static const _accentLight = Color(0xFF4A4E69);
  static const _highlight = Color(0xFFE8A87C);
  static const _textPrimary = Color(0xFF1A1A2E);
  static const _textSecondary = Color(0xFF6B7280);
  static const _border = Color(0xFFE5E0D8);
  // ───────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      _showSnack("Please enter your email address.", isError: true);
      return;
    }
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(email)) {
      _showSnack("Please enter a valid email address.", isError: true);
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500)); // simulate network
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _emailSent = true;
    });
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontFamily: 'Georgia')),
        backgroundColor: isError ? const Color(0xFFD9534F) : _accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: _textPrimary, size: 18),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          "Account Recovery",
          style: TextStyle(
            color: _textPrimary,
            fontFamily: 'Georgia',
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // ── Header illustration block ────────────────
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: _accent,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: _accent.withOpacity(0.18),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.lock_reset_rounded,
                          color: Colors.white, size: 36),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Headline ─────────────────────────────────
                  const Center(
                    child: Text(
                      "Forgot your password?",
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: _textPrimary,
                        letterSpacing: -0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: Text(
                      _emailSent
                          ? "Check your inbox for the reset link."
                          : "No worries — we'll send you a secure\nreset link right away.",
                      style: const TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 14.5,
                        color: _textSecondary,
                        height: 1.55,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 36),

                  if (!_emailSent) ...[
                    // ── Card form ──────────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _border, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Email address",
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: _accentLight,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 15,
                              color: _textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: "you@example.com",
                              hintStyle: TextStyle(
                                fontFamily: 'Georgia',
                                color: _textSecondary.withOpacity(0.6),
                                fontSize: 15,
                              ),
                              prefixIcon: const Icon(Icons.mail_outline_rounded,
                                  color: _accentLight, size: 20),
                              filled: true,
                              fillColor: _bg,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: _accent, width: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Primary CTA ────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : resetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accent,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: _accent.withOpacity(0.6),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Text(
                          "Send Reset Link",
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    // ── Success state ──────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDF7F0),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xFFA8D5B5), width: 1),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.check_circle_outline_rounded,
                              color: Color(0xFF2E7D52), size: 40),
                          const SizedBox(height: 12),
                          Text(
                            "Link sent to\n${emailController.text.trim()}",
                            style: const TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 14,
                              color: Color(0xFF2E7D52),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () =>
                                setState(() => _emailSent = false),
                            child: const Text(
                              "Use a different email",
                              style: TextStyle(
                                fontFamily: 'Georgia',
                                color: _accentLight,
                                fontSize: 13.5,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // ── Divider with label ─────────────────────
                  Row(
                    children: [
                      const Expanded(child: Divider(color: _border)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "OR",
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 11,
                            color: _textSecondary.withOpacity(0.7),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(color: _border)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Back to login ──────────────────────────
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                              fontFamily: 'Georgia', fontSize: 14),
                          children: [
                            TextSpan(
                              text: "Remembered it? ",
                              style: TextStyle(color: _textSecondary),
                            ),
                            TextSpan(
                              text: "Back to Sign In",
                              style: TextStyle(
                                color: _accent,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Security badge ─────────────────────────
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_user_outlined,
                            size: 13, color: _textSecondary.withOpacity(0.5)),
                        const SizedBox(width: 5),
                        Text(
                          "Secured with end-to-end encryption",
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 11.5,
                            color: _textSecondary.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}