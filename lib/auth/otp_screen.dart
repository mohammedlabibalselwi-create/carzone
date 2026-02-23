import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

import '../theme/app_colors.dart';

class OtpScreen extends StatefulWidget {
  final String identifier;
  final String method;
  final int length;
  final int initialTimer;
  final String? verificationId;

  const OtpScreen({
    super.key,
    required this.identifier,
    required this.method,
    this.length = 6,
    this.initialTimer = 60,
    this.verificationId,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {
  List<TextEditingController> _controllers = [];
  List<FocusNode> _nodes = [];
  Timer? _timer;

  int _seconds = 0;
  bool _canResend = false;
  bool _loading = false;

  String _t(bool isArabic, String ar, String en) => isArabic ? ar : en;

  void _ensureControllers() {
    if (_controllers.length == widget.length && _nodes.length == widget.length) {
      return;
    }

    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }

    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void initState() {
    super.initState();
    _ensureControllers();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant OtpScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.length != widget.length) {
      _ensureControllers();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _seconds = widget.initialTimer;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds == 0) {
        if (mounted) setState(() => _canResend = true);
        t.cancel();
      } else {
        if (mounted) setState(() => _seconds--);
      }
    });
  }

  void _resendCode() {
    final isArabic = !context.read<SettingsProvider>().isEnglish;
    if (!_canResend) return;
    _startTimer();
    _showSnackBar(
        _t(isArabic, 'تم إرسال رمز جديد', 'A new code has been sent'),
        AppPalette.primary);
  }

  Future<void> _verify() async {
    final isArabic = !context.read<SettingsProvider>().isEnglish;
    final bool isComplete = _controllers.every((c) => c.text.isNotEmpty);
    if (!isComplete) {
      _showSnackBar(
          _t(isArabic, 'أكمل جميع الخانات', 'Please fill all digits'),
          Colors.redAccent);
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _loading = false);
    _timer?.cancel();

    Navigator.pushReplacementNamed(context, '/reset-password', arguments: {
      'identifier': widget.identifier,
      'method': widget.method,
    });
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(msg, style: GoogleFonts.cairo()),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) c.dispose();
    for (var n in _nodes) n.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _ensureControllers();
    // Read global settings so colors/text react to dashboard toggles.
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;
    final isArabic = !settings.isEnglish;
    final Size size = MediaQuery.of(context).size;
    final bool isTablet = size.width > 600;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: background(isDark),
        body: Stack(
          children: [
            _buildBackgroundDecor(isDark),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 500 : double.infinity,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        _buildHeader(isTablet, isArabic, isDark),
                        const SizedBox(height: 40),
                        _buildOtpCard(isDark, isArabic),
                        const SizedBox(height: 20),
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

  Widget _buildHeader(bool isTablet, bool isArabic, bool isDark) {
    return Column(
      children: [
        Icon(Icons.verified_user_rounded,
            size: isTablet ? 90 : 70, color: heroText(isDark)),
        const SizedBox(height: 20),
        Text(
          _t(isArabic, 'التحقق من الرمز', 'Verify code'),
          style: GoogleFonts.cairo(
            fontSize: isTablet ? 32 : 26,
            fontWeight: FontWeight.bold,
            color: heroText(isDark),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            _t(isArabic, 'أرسلنا كود التحقق إلى\n${widget.identifier}',
                'We sent the code to\n${widget.identifier}'),
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
                fontSize: 15, color: Colors.white70, height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpCard(bool isDark, bool isArabic) {
    final bool isComplete = _controllers.every((c) => c.text.isNotEmpty);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: cardBg(isDark),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: cardBorder(isDark)),
        boxShadow: [
          BoxShadow(
              color: cardShadow(isDark),
              blurRadius: 25,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          _buildResponsiveOtpFields(isDark),
          const SizedBox(height: 35),
          _buildTimerSection(isArabic, isDark),
          const SizedBox(height: 25),
          _buildSubmitButton(isComplete, isArabic, isDark),
        ],
      ),
    );
  }

  Widget _buildResponsiveOtpFields(bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // حساب العرض الأقصى لكل خانة بناءً على المساحة المتوفرة
        double fieldWidth =
            (constraints.maxWidth - (widget.length * 8)) / widget.length;
        // وضع حد أقصى للعرض لكي لا تبدو الخانات ضخمة جداً في الشاشات الكبيرة
        fieldWidth = fieldWidth > 50 ? 50 : fieldWidth;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(widget.length, (i) {
            return SizedBox(
              width: fieldWidth,
              height: fieldWidth * 1.3,
              child: KeyboardListener(
                focusNode: FocusNode(),
                onKeyEvent: (event) {
                  if (event is KeyDownEvent &&
                      event.logicalKey == LogicalKeyboardKey.backspace &&
                      _controllers[i].text.isEmpty &&
                      i > 0) {
                    _nodes[i - 1].requestFocus();
                  }
                },
                child: TextField(
                  controller: _controllers[i],
                  focusNode: _nodes[i],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: GoogleFonts.cairo(
                    fontSize: fieldWidth * 0.5,
                    fontWeight: FontWeight.bold,
                    color: textPrimary(isDark),
                  ),
                  decoration: InputDecoration(
                    counterText: "",
                    filled: true,
                    fillColor: isDark
                        ? AppPalette.darkBackground
                        : Colors.grey.shade50,
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: cardBorder(isDark)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppPalette.primary, width: 2),
                    ),
                  ),
                  onChanged: (v) {
                    if (v.isNotEmpty && i < widget.length - 1) {
                      _nodes[i + 1].requestFocus();
                    } else if (v.isEmpty && i > 0) {
                      _nodes[i - 1].requestFocus();
                    }
                    setState(() {});
                    if (_controllers.every((c) => c.text.isNotEmpty) &&
                        !_loading) {}
                  },
                ),
              ),
            );
          }),
        );
      },
    );
  }

  // ... (دوال _buildTimerSection و _buildSubmitButton و _buildBackgroundDecor تظل كما هي)
  Widget _buildTimerSection(bool isArabic, bool isDark) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _canResend
          ? TextButton.icon(
              onPressed: _resendCode,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text(_t(isArabic, "إعادة إرسال الرمز", "Resend code"),
                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              style: TextButton.styleFrom(foregroundColor: AppPalette.primary),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer_outlined,
                    size: 18, color: textSecondary(isDark)),
                const SizedBox(width: 8),
                Text(
                  _t(
                      isArabic,
                      'إعادة الإرسال خلال ${_seconds.toString().padLeft(2, '0')} ثانية',
                      'Resend in ${_seconds.toString().padLeft(2, '0')}s'),
                  style: GoogleFonts.cairo(
                      color: textSecondary(isDark), fontSize: 13),
                ),
              ],
            ),
    );
  }

  Widget _buildSubmitButton(bool isComplete, bool isArabic, bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isComplete && !_loading ? _verify : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBg(isDark),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: _loading
            ? const SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2))
            : Text(_t(isArabic, 'تحقق الآن', 'Verify now'),
                style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: buttonText(isDark))),
      ),
    );
  }

  Widget _buildBackgroundDecor(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [heroBg(isDark), AppPalette.secondary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: -50, left: -50, child: _circle(200, isDark)),
          Positioned(bottom: -100, right: -50, child: _circle(300, isDark)),
        ],
      ),
    );
  }

  Widget _circle(double size, bool isDark) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (isDark ? Colors.white : Colors.white).withOpacity(0.05),
        ),
      );
}
