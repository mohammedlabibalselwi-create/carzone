import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String identifier;
  final String method;

  const ResetPasswordScreen({
    super.key,
    required this.identifier,
    required this.method,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  String _t(bool isArabic, String ar, String en) => isArabic ? ar : en;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String _strengthLabel(String value, bool isArabic) {
    if (value.length >= 10 &&
        RegExp(r'[A-Za-z]').hasMatch(value) &&
        RegExp(r'\d').hasMatch(value)) {
      return _t(isArabic, 'قوي', 'Strong');
    }
    if (value.length >= 7) {
      return _t(isArabic, 'متوسط', 'Medium');
    }
    if (value.isNotEmpty) {
      return _t(isArabic, 'ضعيف', 'Weak');
    }
    return _t(isArabic, 'غير محدد', 'Not set');
  }

  Color _strengthColor(String value) {
    if (value.length >= 10 &&
        RegExp(r'[A-Za-z]').hasMatch(value) &&
        RegExp(r'\d').hasMatch(value)) {
      return Colors.green;
    }
    if (value.length >= 7) {
      return Colors.orange;
    }
    if (value.isNotEmpty) {
      return Colors.redAccent;
    }
    return Colors.grey;
  }

  Future<void> _submit(bool isArabic) async {
    if (!_formKey.currentState!.validate()) return;
    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showSnack(
        _t(isArabic, 'كلمتا المرور غير متطابقتين', 'Passwords do not match'),
        Colors.redAccent,
      );
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _loading = false);

    _showSnack(
      _t(isArabic, 'تم تحديث كلمة المرور', 'Password updated successfully'),
      AppPalette.primary,
    );

    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  void _showSnack(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: GoogleFonts.cairo()),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;
    final isArabic = !settings.isEnglish;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: background(isDark),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [heroBg(isDark), AppPalette.secondary],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(top: -60, left: -70, child: _circle(220, isDark)),
            Positioned(bottom: -100, right: -80, child: _circle(300, isDark)),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: isTablet ? 520 : double.infinity),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 18),
                        _buildHeader(isArabic, isDark, isTablet),
                        const SizedBox(height: 26),
                        _buildFormCard(isArabic, isDark),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isArabic, bool isDark, bool isTablet) {
    final target = widget.identifier.isEmpty
        ? _t(isArabic, 'حسابك', 'your account')
        : widget.identifier;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12), shape: BoxShape.circle),
          child: Icon(Icons.lock_reset_rounded,
              size: isTablet ? 60 : 50, color: heroText(isDark)),
        ),
        const SizedBox(height: 12),
        Text(
          _t(isArabic, 'إعادة تعيين كلمة المرور', 'Reset password'),
          style: GoogleFonts.cairo(
            fontSize: isTablet ? 26 : 22,
            fontWeight: FontWeight.w800,
            color: heroText(isDark),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          _t(isArabic, 'تطبيق التغيير على', 'Applying change to'),
          style: GoogleFonts.cairo(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 2),
        Text(
          target,
          style: GoogleFonts.cairo(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormCard(bool isArabic, bool isDark) {
    final newValue = _newPasswordController.text;
    final strength = _strengthLabel(newValue, isArabic);
    final strengthColor = _strengthColor(newValue);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cardBg(isDark),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: cardBorder(isDark)),
        boxShadow: [
          BoxShadow(
            color: cardShadow(isDark),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _t(isArabic, 'أنشئ كلمة مرور جديدة', 'Create a new password'),
              style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimary(isDark)),
            ),
            const SizedBox(height: 16),
            _passwordField(
              controller: _newPasswordController,
              label: _t(isArabic, 'كلمة المرور الجديدة', 'New password'),
              obscure: _obscureNew,
              toggle: () => setState(() => _obscureNew = !_obscureNew),
              isDark: isDark,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return _t(
                      isArabic, 'هذا الحقل مطلوب', 'This field is required');
                }
                if (v.length < 6) {
                  return _t(
                      isArabic, '6 أحرف على الأقل', 'At least 6 characters');
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            _passwordField(
              controller: _confirmPasswordController,
              label: _t(isArabic, 'تأكيد كلمة المرور', 'Confirm password'),
              obscure: _obscureConfirm,
              toggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
              isDark: isDark,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return _t(
                      isArabic, 'هذا الحقل مطلوب', 'This field is required');
                }
                if (v.length < 6) {
                  return _t(
                      isArabic, '6 أحرف على الأقل', 'At least 6 characters');
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: strengthColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _t(isArabic, 'قوة كلمة المرور: ', 'Password strength: ') +
                      strength,
                  style: GoogleFonts.cairo(
                      fontSize: 13, color: textSecondary(isDark)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              _t(
                isArabic,
                'يُنصح باستخدام مزيج من الحروف الكبيرة والصغيرة والأرقام والرموز لضمان أمان أعلى.',
                'Use uppercase, lowercase, numbers, and symbols for better security.',
              ),
              style: GoogleFonts.cairo(
                  fontSize: 12.5, color: textSecondary(isDark), height: 1.4),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _loading ? null : () => _submit(isArabic),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonBg(isDark),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: _loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        _t(isArabic, 'حفظ كلمة المرور', 'Save password'),
                        style: GoogleFonts.cairo(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: buttonText(isDark)),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
    required bool isDark,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: GoogleFonts.cairo(fontSize: 15, color: textPrimary(isDark)),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline, color: AppPalette.primary),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            size: 20,
            color: textSecondary(isDark),
          ),
          onPressed: toggle,
        ),
        filled: true,
        fillColor: cardBg(isDark),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cardBorder(isDark)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cardBorder(isDark)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: AppPalette.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _circle(double size, bool isDark) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(isDark ? 0.05 : 0.08),
      ),
    );
  }
}
