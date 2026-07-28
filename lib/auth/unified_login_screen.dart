import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import 'signup_screen.dart';

enum LoginMethod { email, phone }

class UnifiedLoginScreen extends StatefulWidget {
  const UnifiedLoginScreen({super.key});

  @override
  State<UnifiedLoginScreen> createState() => _UnifiedLoginScreenState();
}

class _UnifiedLoginScreenState extends State<UnifiedLoginScreen>
    with SingleTickerProviderStateMixin {
  LoginMethod _method = LoginMethod.phone;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  late AnimationController _controller;
  Animation<double>? _fade;
  bool _obscurePassword = true;

  String _t(bool isArabic, String ar, String en) => isArabic ? ar : en;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  void _switch(LoginMethod m) {
    if (_method == m || _isLoading) return;
    setState(() {
      _method = m;
      _emailController.clear();
      _phoneController.clear();
      _passwordController.clear();
    });
    _controller.forward(from: 0);
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.cairo()),
        backgroundColor: AppPalette.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;
    final isArabic = !settings.isEnglish;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            // Background Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [heroBg(isDark), AppPalette.secondary],
                ),
              ),
            ),
            _buildBackgroundCircle(
                top: -120, right: -80, size: 260, isDark: isDark),
            _buildBackgroundCircle(
                top: 120, left: -90, size: 200, isDark: isDark),

            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shield_outlined,
                          size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _t(isArabic, 'تسجيل الدخول', 'Sign in'),
                      style: GoogleFonts.cairo(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Text(
                        _t(isArabic, 'مرحباً بعودتك! يرجى إدخال بياناتك',
                            'Welcome back! Please enter your details'),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                            fontSize: 14, height: 1.6, color: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Login Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: cardBg(isDark),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: cardBorder(isDark)),
                        boxShadow: [
                          BoxShadow(
                            color: cardShadow(isDark),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              _t(isArabic, 'اختر طريقة تسجيل الدخول',
                                  'Choose a login method'),
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textPrimary(isDark),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                _methodButton(
                                  icon: Icons.phone_android,
                                  text: _t(isArabic, 'الهاتف', 'Phone'),
                                  selected: _method == LoginMethod.phone,
                                  onTap: () => _switch(LoginMethod.phone),
                                  isDark: isDark,
                                ),
                                const SizedBox(width: 12),
                                _methodButton(
                                  icon: Icons.alternate_email,
                                  text: _t(isArabic, 'الإيميل', 'Email'),
                                  selected: _method == LoginMethod.email,
                                  onTap: () => _switch(LoginMethod.email),
                                  isDark: isDark,
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            FadeTransition(
                              opacity: _fade ?? kAlwaysCompleteAnimation,
                              child: _buildInputFields(isArabic, isDark),
                            ),
                            const SizedBox(height: 10),

                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed:() {

                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonBg(isDark),
                                  disabledBackgroundColor:
                                      Colors.grey.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  elevation: 0,
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2),
                                      )
                                    : Text(
                                        _t(isArabic, 'تسجيل الدخول', 'Sign in'),
                                        style: GoogleFonts.cairo(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: buttonText(isDark),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextButton(
                              onPressed: _isLoading
                                  ? null
                                  : () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const SignupScreen(),
                                        ),
                                      ),
                              child: Text(_t(isArabic, 'إنشاء حساب جديد',
                                  'Create new account')),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFields(bool isArabic, bool isDark) {
    final List<Widget> fields = [];

    if (_method == LoginMethod.email) {
      fields.add(
        _input(
          controller: _emailController,
          hint: 'example@domain.com',
          icon: Icons.email_outlined,
          type: TextInputType.emailAddress,
          validator: (v) => (v != null && v.contains('@') && v.length > 5)
              ? null
              : _t(isArabic, 'يرجى إدخال بريد إلكتروني صحيح',
                  'Enter a valid email'),
          isDark: isDark,
        ),
      );
    } else {
      fields.add(
        _input(
          controller: _phoneController,
          hint: 'xxxxxxxxx',
          icon: Icons.phone_outlined,
          type: TextInputType.phone,
          prefixText: '+967 ',
          validator: (v) {
            if (v == null || v.isEmpty)
              return _t(isArabic, 'مطلوب', 'Required');
            if (!RegExp(r'^\d{9}$').hasMatch(v))
              return _t(isArabic, 'أدخل 9 أرقام', 'Enter 9 digits');
            return null;
          },
          isDark: isDark,
        ),
      );
    }

    fields.add(const SizedBox(height: 14));
    fields.add(
      TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        enabled: !_isLoading,
        validator: (v) {
          if (v == null || v.isEmpty)
            return _t(isArabic, 'كلمة المرور مطلوبة', 'Password is required');
          if (v.length < 6)
            return _t(isArabic, 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
                'Password must be at least 6 characters');
          return null;
        },
        style: GoogleFonts.cairo(fontSize: 15, color: textPrimary(isDark)),
        decoration: InputDecoration(
          hintText: _t(isArabic, 'كلمة المرور', 'Password'),
          prefixIcon: const Icon(Icons.lock_outline, color: AppPalette.primary),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              color: textSecondary(isDark),
              size: 20,
            ),
            onPressed: _isLoading
                ? null
                : () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          filled: true,
          fillColor: cardBg(isDark),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: cardBorder(isDark)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: cardBorder(isDark)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppPalette.primary, width: 1.5),
          ),
        ),
      ),
    );

    fields.add(
      Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 4),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton(
            onPressed:
                _isLoading ? null : () => _openForgotSheet(isArabic, isDark),
            child: Text(
              _t(isArabic, 'نسيت كلمة المرور؟', 'Forgot password?'),
              style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppPalette.primary),
            ),
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: fields,
    );
  }

  Widget _methodButton({
    required IconData icon,
    required String text,
    required bool selected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Expanded(
      child: InkWell(
        onTap: _isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(15),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color:
                selected ? AppPalette.primary : cardBg(isDark).withOpacity(0.5),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                color: selected ? AppPalette.primary : cardBorder(isDark)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 20,
                  color: selected ? Colors.white : textSecondary(isDark)),
              const SizedBox(width: 8),
              Text(text,
                  style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: selected ? Colors.white : textSecondary(isDark))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required TextInputType type,
    required String? Function(String?) validator,
    required bool isDark,
    String? prefixText,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: type,
      enabled: !_isLoading,
      style: GoogleFonts.cairo(fontSize: 15, color: textPrimary(isDark)),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefixText != null
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Text(prefixText,
                    style: GoogleFonts.cairo(
                        color: AppPalette.primary,
                        fontWeight: FontWeight.bold)))
            : Icon(icon, color: AppPalette.primary),
        filled: true,
        fillColor: cardBg(isDark),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: cardBorder(isDark)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: cardBorder(isDark)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppPalette.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildBackgroundCircle(
      {double? top,
      double? right,
      double? left,
      required double size,
      required bool isDark}) {
    return Positioned(
      top: top,
      right: right,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(isDark ? 0.05 : 0.08),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  void _openForgotSheet(bool isArabic, bool isDark) {
    final sheetFormKey = GlobalKey<FormState>();
    LoginMethod selected = _method;
    final phoneTempController =
        TextEditingController(text: _phoneController.text);
    final emailTempController =
        TextEditingController(text: _emailController.text);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cardBg(isDark),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final isPhone = selected == LoginMethod.phone;
          final controller =
              isPhone ? phoneTempController : emailTempController;

          String? validator(String? v) {
            if (isPhone) {
              if (v == null || v.isEmpty)
                return _t(isArabic, 'مطلوب', 'Required');
              if (!RegExp(r'^\d{9}$').hasMatch(v)) {
                return _t(isArabic, 'أدخل 9 أرقام', 'Enter 9 digits');
              }
            } else {
              if (v == null || v.isEmpty)
                return _t(isArabic, 'مطلوب', 'Required');
              if (!v.contains('@') || v.length < 6) {
                return _t(isArabic, 'بريد إلكتروني غير صالح', 'Invalid email');
              }
            }
            return null;
          }

          return Padding(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Form(
              key: sheetFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          _t(isArabic, 'استرجاع كلمة المرور',
                              'Recover password'),
                          style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: textPrimary(isDark))),
                      IconButton(
                          icon: Icon(Icons.close_rounded,
                              color: textPrimary(isDark)),
                          onPressed: () => Navigator.pop(ctx)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isPhone
                        ? _t(
                            isArabic,
                            'اختر الإرسال للهاتف أو غيّر للإيميل حسب رغبتك',
                            'Send reset code to phone or switch to email')
                        : _t(
                            isArabic,
                            'اختر الإرسال للإيميل أو غيّر للهاتف حسب رغبتك',
                            'Send reset link to email or switch to phone'),
                    style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: textSecondary(isDark),
                        height: 1.4),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _methodButton(
                          icon: Icons.phone_android,
                          text: _t(isArabic, 'الهاتف', 'Phone'),
                          selected: isPhone,
                          onTap: () =>
                              setSheetState(() => selected = LoginMethod.phone),
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _methodButton(
                          icon: Icons.alternate_email,
                          text: _t(isArabic, 'الإيميل', 'Email'),
                          selected: !isPhone,
                          onTap: () =>
                              setSheetState(() => selected = LoginMethod.email),
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _input(
                    controller: controller,
                    hint: isPhone ? 'xxxxxxxxx' : 'email@domain.com',
                    icon: isPhone ? Icons.phone_outlined : Icons.email_outlined,
                    type: isPhone
                        ? TextInputType.phone
                        : TextInputType.emailAddress,
                    validator: validator,
                    isDark: isDark,
                    prefixText: isPhone ? '+967 ' : null,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        if (!sheetFormKey.currentState!.validate()) return;
                        final destination = controller.text.trim();
                        Navigator.pop(ctx);
                        _showSuccess(
                          isPhone
                              ? _t(isArabic, 'تم إرسال الرمز إلى هاتفك',
                                  'Reset code sent to your phone')
                              : _t(isArabic, 'تم إرسال الرابط إلى بريدك',
                                  'Reset link sent to your email'),
                        );
                        Navigator.pushNamed(context, '/otp', arguments: {
                          'identifier':
                              isPhone ? '+967 ${destination}' : destination,
                          'method': isPhone ? 'phone' : 'email',
                        });
                      },
                      child: Text(
                          _t(isArabic, 'إرسال الرمز', 'Send instructions'),
                          style: GoogleFonts.cairo(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
