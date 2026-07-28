import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import 'signup_screen.dart';

enum IdentifiedType { empty, phone, email }

class DetectedCountry {
  final String flag;
  final String code;
  final String nameAr;
  final String nameEn;

  const DetectedCountry({
    required this.flag,
    required this.code,
    required this.nameAr,
    required this.nameEn,
  });
}

const countryYemen = DetectedCountry(
  flag: '🇾🇪',
  code: '+967',
  nameAr: 'اليمن',
  nameEn: 'Yemen',
);

const countrySaudi = DetectedCountry(
  flag: '🇸🇦',
  code: '+966',
  nameAr: 'السعودية',
  nameEn: 'Saudi Arabia',
);

const countryUAE = DetectedCountry(
  flag: '🇦🇪',
  code: '+971',
  nameAr: 'الإمارات',
  nameEn: 'UAE',
);

class UnifiedLoginScreen extends StatefulWidget {
  const UnifiedLoginScreen({super.key});

  @override
  State<UnifiedLoginScreen> createState() => _UnifiedLoginScreenState();
}

class _UnifiedLoginScreenState extends State<UnifiedLoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  IdentifiedType _detectedType = IdentifiedType.empty;
  DetectedCountry _detectedCountry = countryYemen;

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

    _identifierController.addListener(_onIdentifierChanged);
  }

  void _onIdentifierChanged() {
    final raw = _identifierController.text.trim();
    if (raw.isEmpty) {
      if (_detectedType != IdentifiedType.empty) {
        setState(() {
          _detectedType = IdentifiedType.empty;
          _detectedCountry = countryYemen;
        });
      }
      return;
    }

    final firstChar = raw.substring(0, 1);
    final isDigitOrPlus = RegExp(r'[0-9+]').hasMatch(firstChar);

    if (isDigitOrPlus) {
      IdentifiedType newType = IdentifiedType.phone;
      DetectedCountry country = countryYemen;

      String clean = raw.replaceAll(RegExp(r'[^\d+]'), '');

      if (clean.startsWith('5') ||
          clean.startsWith('05') ||
          clean.startsWith('+966') ||
          clean.startsWith('966')) {
        country = countrySaudi;
      } else if (clean.startsWith('7') ||
          clean.startsWith('07') ||
          clean.startsWith('+967') ||
          clean.startsWith('967')) {
        country = countryYemen;
      } else if (clean.startsWith('+971') || clean.startsWith('971')) {
        country = countryUAE;
      } else {
        country = (clean.startsWith('5') || clean.startsWith('05'))
            ? countrySaudi
            : countryYemen;
      }

      if (_detectedType != newType || _detectedCountry != country) {
        setState(() {
          _detectedType = newType;
          _detectedCountry = country;
        });
      }
    } else {
      bool isEmailChar = RegExp(r'^[a-zA-Z]').hasMatch(firstChar);
      if (isEmailChar || raw.contains('@')) {
        if (_detectedType != IdentifiedType.email) {
          setState(() {
            _detectedType = IdentifiedType.email;
          });
        }
      }
    }
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

  void _handleLogin(SettingsProvider settings, bool isArabic) {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      final identifier = _identifierController.text.trim();
      final userName = _detectedType == IdentifiedType.email
          ? identifier.split('@').first
          : 'ياسر الحكيمي';
      settings.setLoggedIn(true, userName);
      _showSuccess(
          _t(isArabic, 'تم تسجيل الدخول بنجاح!', 'Signed in successfully!'));
      Navigator.of(context).pop();
    });
  }

  void _handleSocialLogin(
      String provider, bool isArabic, SettingsProvider settings) {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      final userLabel = provider == 'Google' ? 'مستخدم جوجل' : 'مستخدم أبل';
      settings.setLoggedIn(true, userLabel);
      _showSuccess(
        _t(
          isArabic,
          'تم تسجيل الدخول بواسطة $provider بنجاح!',
          'Signed in with $provider successfully!',
        ),
      );
      Navigator.of(context).pop();
    });
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
                            FadeTransition(
                              opacity: _fade ?? kAlwaysCompleteAnimation,
                              child: _buildInputFields(isArabic, isDark),
                            ),
                            const SizedBox(height: 16),

                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () => _handleLogin(settings, isArabic),
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

                            const SizedBox(height: 22),

                            // Social Divider "أو التسجيل بواسطة"
                            Row(
                              children: [
                                Expanded(
                                    child: Divider(color: cardBorder(isDark))),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    _t(isArabic, 'أو التسجيل بواسطة',
                                        'Or sign in with'),
                                    style: GoogleFonts.cairo(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: textSecondary(isDark),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Divider(color: cardBorder(isDark))),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Google & Apple Buttons
                            Row(
                              children: [
                                // Google
                                Expanded(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: _isLoading
                                          ? null
                                          : () => _handleSocialLogin(
                                              'Google', isArabic, settings),
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color:
                                              cardBg(isDark).withOpacity(0.6),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                              color: cardBorder(isDark)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const CustomGoogleIcon(size: 20),
                                            const SizedBox(width: 8),
                                            Text(
                                              _t(isArabic, 'جوجل', 'Google'),
                                              style: GoogleFonts.cairo(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: textPrimary(isDark),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Apple
                                Expanded(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: _isLoading
                                          ? null
                                          : () => _handleSocialLogin(
                                              'Apple', isArabic, settings),
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color:
                                              cardBg(isDark).withOpacity(0.6),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                              color: cardBorder(isDark)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.apple,
                                              size: 22,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              _t(isArabic, 'أبل', 'Apple'),
                                              style: GoogleFonts.cairo(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: textPrimary(isDark),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            TextButton.icon(
                              onPressed: _isLoading
                                  ? null
                                  : () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const SignupScreen(),
                                        ),
                                      ),
                              icon: const Icon(Icons.storefront_outlined,
                                  size: 18, color: AppPalette.primary),
                              label: Text(
                                _t(isArabic, 'انضم إلينا كـ بائع شريك',
                                    'Join us as a Seller Partner'),
                                style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppPalette.primary,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFields(bool isArabic, bool isDark) {
    String getHintText() {
      if (_detectedType == IdentifiedType.phone) {
        if (_detectedCountry == countrySaudi) {
          return _t(isArabic, 'رقم الهاتف (مثال: 0512345678)',
              'Phone number (ex: 0512345678)');
        }
        return _t(isArabic, 'رقم الهاتف (مثال: 771234567)',
            'Phone number (ex: 771234567)');
      } else if (_detectedType == IdentifiedType.email) {
        return _t(isArabic, 'البريد الإلكتروني (example@domain.com)',
            'Email (example@domain.com)');
      }
      return _t(
          isArabic, 'رقم الهاتف أو البريد الإلكتروني', 'Phone number or Email');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _identifierController,
          enabled: !_isLoading,
          keyboardType: _detectedType == IdentifiedType.phone
              ? TextInputType.phone
              : TextInputType.emailAddress,
          validator: (v) => _validateIdentifier(v, isArabic),
          style: GoogleFonts.cairo(fontSize: 15, color: textPrimary(isDark)),
          decoration: InputDecoration(
            hintText: getHintText(),
            hintStyle:
                GoogleFonts.cairo(fontSize: 13.5, color: textSecondary(isDark)),
            prefixIcon: _buildIdentifierPrefixWidget(isDark),
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
              borderSide:
                  const BorderSide(color: AppPalette.primary, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          enabled: !_isLoading,
          validator: (v) {
            if (v == null || v.isEmpty) {
              return _t(isArabic, 'كلمة المرور مطلوبة', 'Password is required');
            }
            if (v.length < 6) {
              return _t(isArabic, 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
                  'Password must be at least 6 characters');
            }
            return null;
          },
          style: GoogleFonts.cairo(fontSize: 15, color: textPrimary(isDark)),
          decoration: InputDecoration(
            hintText: _t(isArabic, 'كلمة المرور', 'Password'),
            hintStyle:
                GoogleFonts.cairo(fontSize: 13.5, color: textSecondary(isDark)),
            prefixIcon:
                const Icon(Icons.lock_outline, color: AppPalette.primary),
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
              borderSide:
                  const BorderSide(color: AppPalette.primary, width: 1.5),
            ),
          ),
        ),
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
      ],
    );
  }

  Widget _buildIdentifierPrefixWidget(bool isDark) {
    if (_detectedType == IdentifiedType.phone) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        margin: const EdgeInsets.only(left: 8, right: 8),
        decoration: BoxDecoration(
          color: AppPalette.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.phone_android_rounded,
                size: 18, color: AppPalette.primary),
            const SizedBox(width: 6),
            Text(
              _detectedCountry.flag,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(width: 4),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                _detectedCountry.code,
                style: GoogleFonts.cairo(
                  color: AppPalette.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (_detectedType == IdentifiedType.email) {
      return const Icon(
        Icons.alternate_email_rounded,
        color: AppPalette.primary,
      );
    } else {
      return const Icon(
        Icons.person_outline_rounded,
        color: AppPalette.primary,
      );
    }
  }

  String? _validateIdentifier(String? v, bool isArabic) {
    if (v == null || v.trim().isEmpty) {
      return _t(isArabic, 'يرجى إدخال رقم الهاتف أو البريد الإلكتروني',
          'Please enter phone number or email');
    }

    final val = v.trim();

    if (_detectedType == IdentifiedType.phone) {
      final cleanDigits = val.replaceAll(RegExp(r'[^\d]'), '');
      if (cleanDigits.length < 8) {
        return _t(
            isArabic, 'يرجى إدخال رقم هاتف صحيح', 'Enter a valid phone number');
      }
    } else if (_detectedType == IdentifiedType.email) {
      if (!val.contains('@') || !val.contains('.') || val.length < 5) {
        return _t(isArabic, 'يرجى إدخال بريد إلكتروني صحيح',
            'Enter a valid email address');
      }
    } else {
      if (RegExp(r'^\d+$').hasMatch(val)) {
        if (val.length < 8) {
          return _t(isArabic, 'يرجى إدخال رقم هاتف صحيح',
              'Enter a valid phone number');
        }
      } else {
        if (!val.contains('@') || val.length < 5) {
          return _t(isArabic, 'يرجى إدخال بريد إلكتروني صحيح',
              'Enter a valid email address');
        }
      }
    }
    return null;
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
    final tempController =
        TextEditingController(text: _identifierController.text);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cardBg(isDark),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
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
                    _t(
                        isArabic,
                        'أدخل رقم الهاتف أو البريد الإلكتروني لاستلام رمز إعادة التعيين',
                        'Enter your phone number or email to receive reset code'),
                    style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: textSecondary(isDark),
                        height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: tempController,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return _t(isArabic, 'مطلوب', 'Required');
                      }
                      return null;
                    },
                    style: GoogleFonts.cairo(
                        fontSize: 15, color: textPrimary(isDark)),
                    decoration: InputDecoration(
                      hintText: _t(isArabic, 'رقم الهاتف أو البريد الإلكتروني',
                          'Phone number or Email'),
                      prefixIcon: const Icon(Icons.lock_reset_rounded,
                          color: AppPalette.primary),
                      filled: true,
                      fillColor: cardBg(isDark),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 16),
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
                        borderSide: const BorderSide(
                            color: AppPalette.primary, width: 1.5),
                      ),
                    ),
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
                        final destination = tempController.text.trim();
                        Navigator.pop(ctx);
                        _showSuccess(
                          _t(isArabic, 'تم إرسال تعليمات إعادة التعيين',
                              'Reset instructions sent'),
                        );
                        Navigator.pushNamed(context, '/otp', arguments: {
                          'identifier': destination,
                          'method':
                              destination.contains('@') ? 'email' : 'phone',
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
    _identifierController.removeListener(_onIdentifierChanged);
    _identifierController.dispose();
    _passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }
}

class CustomGoogleIcon extends StatelessWidget {
  final double size;
  const CustomGoogleIcon({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleIconPainter(),
      ),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double center = w / 2;
    final double radius = w / 2;
    final double strokeWidth = w * 0.22;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Rect rect = Rect.fromCircle(
      center: Offset(center, center),
      radius: radius - strokeWidth / 2,
    );

    // Red arc
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, -0.7 * 3.14159, 1.1 * 3.14159, false, paint);

    // Yellow arc
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, 0.4 * 3.14159, 0.6 * 3.14159, false, paint);

    // Green arc
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(rect, 1.0 * 3.14159, 0.6 * 3.14159, false, paint);

    // Blue arc
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, 1.6 * 3.14159, 0.5 * 3.14159, false, paint);

    // Horizontal bar
    final Paint fillPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(
          center - 1, center - strokeWidth / 2, radius * 0.9, strokeWidth),
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
