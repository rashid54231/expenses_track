import 'package:flutter/material.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../routes/route_names.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {

  final emailController    = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController controller = AuthController();

  bool _hidePassword = true;
  bool _isLoading    = false;

  late final AnimationController _fadeController;
  late final Animation<double>   _fadeAnim;

  // ── Palette ──────────────────────────────────────────────
  static const Color _bg        = Color(0xFF0F0E13);
  static const Color _surface   = Color(0xFF1A1825);
  static const Color _accent    = Color(0xFF7C6EFF);
  static const Color _textPrim  = Color(0xFFF0EEF8);
  static const Color _textMuted = Color(0x61F0EEF8);   // 38 %
  static const Color _border    = Color(0x1AF0EEF8);   // 10 %

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ── Login logic ──────────────────────────────────────────
  Future<void> _login() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final success = await controller.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushReplacementNamed(context, RouteNames.dashboard);
    } else {
      _showError("Invalid email or password.");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline,
                color: Color(0xFFFF6B6B), size: 18),
            const SizedBox(width: 10),
            Text(msg,
                style: const TextStyle(
                    color: _textPrim, fontSize: 14)),
          ],
        ),
        backgroundColor: _surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
              color: Color(0x33FF6B6B), width: 0.5),
        ),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
                horizontal: 28, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Brand accent bar ──────────────────────
                Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: _accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 40),

                // ── Header ────────────────────────────────
                const Text(
                  "WELCOME BACK",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                    color: _accent,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Sign in",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w500,
                    color: _textPrim,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Access your account to continue",
                  style: TextStyle(
                      fontSize: 14,
                      color: _textMuted,
                      height: 1.5),
                ),
                const SizedBox(height: 44),

                // ── Email ─────────────────────────────────
                _FieldLabel("Email address"),
                const SizedBox(height: 8),
                _StyledField(
                  controller: emailController,
                  hint: "you@example.com",
                  prefixIcon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // ── Password ──────────────────────────────
                _FieldLabel("Password"),
                const SizedBox(height: 8),
                _StyledField(
                  controller: passwordController,
                  hint: "••••••••••",
                  prefixIcon: Icons.lock_outline_rounded,
                  obscure: _hidePassword,
                  focused: true,
                  suffix: GestureDetector(
                    onTap: () => setState(
                            () => _hidePassword = !_hidePassword),
                    child: Icon(
                      _hidePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: _textMuted,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // ── Forgot password ───────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, RouteNames.forgotPassword),
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(
                        fontSize: 13,
                        color: _accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // ── Sign in button ────────────────────────
                _PrimaryButton(
                  label: "Sign in",
                  isLoading: _isLoading,
                  onPressed: _login,
                ),
                const SizedBox(height: 20),

                // ── Divider ───────────────────────────────
                Row(children: [
                  const Expanded(child: Divider(
                      color: _border, thickness: 0.5)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14),
                    child: Text("or",
                        style: TextStyle(
                            fontSize: 12,
                            color: _textMuted)),
                  ),
                  const Expanded(child: Divider(
                      color: _border, thickness: 0.5)),
                ]),
                const SizedBox(height: 20),

                // ── Create account ────────────────────────
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, RouteNames.signup),
                    child: RichText(
                      text: const TextSpan(
                        text: "New here?  ",
                        style: TextStyle(
                            fontSize: 14,
                            color: _textMuted),
                        children: [
                          TextSpan(
                            text: "Create account",
                            style: TextStyle(
                              color: _accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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
}

// ─────────────────────────────────────────────────────────────
// Helper widgets (private to this file)
// ─────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: Color(0x72F0EEF8),   // 45 %
      ),
    );
  }
}

class _StyledField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final bool obscure;
  final bool focused;
  final Widget? suffix;
  final TextInputType? keyboardType;

  const _StyledField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.obscure      = false,
    this.focused      = false,
    this.suffix,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    const surface = Color(0xFF1A1825);
    const border  = Color(0x1AF0EEF8);
    const accent  = Color(0xFF7C6EFF);
    const muted   = Color(0x61F0EEF8);

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: focused ? accent.withOpacity(0.5) : border,
          width: focused ? 1.0 : 0.5,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(prefixIcon, size: 18, color: muted),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboardType,
              style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFFF0EEF8)),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                    fontSize: 15, color: muted),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              cursorColor: accent,
            ),
          ),
          if (suffix != null) ...[
            suffix!,
            const SizedBox(width: 16),
          ],
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7C6EFF), Color(0xFF5A4DD4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C6EFF).withOpacity(0.30),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            width: 22, height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}