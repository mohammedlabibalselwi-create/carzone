import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import 'unified_login_screen.dart';

// --- دوال المساعدة ---
String t(bool isArabic, String ar, String en) => isArabic ? ar : en;

TextStyle ts(bool isArabic,
    {double? size,
    FontWeight? weight,
    Color? color,
    double? height,
    TextDecoration? decoration,
    double? letterSpacing}) {
  // توحيد الخط عبر اللغتين للحفاظ على هوية بصرية ثابتة
  return GoogleFonts.cairo(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      decoration: decoration,
      letterSpacing: letterSpacing);
}

enum SignupRole { customer, seller }

enum PartsType { newParts, scrapy }

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  SignupRole _selectedRole = SignupRole.seller;
  PartsType _partsType = PartsType.newParts;
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _districtController = TextEditingController();
  final _storeNameController = TextEditingController();

  late final AnimationController _animationController;
  late final Animation<double> _contentFade;
  bool _isLoading = false;
  String? _selectedDocument;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));
    _contentFade =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    _districtController.dispose();
    _storeNameController.dispose();
    super.dispose();
  }

  void _handleSubmit(bool isArabic) {
    if (!_formKey.currentState!.validate()) {
      _showMessage(
          t(isArabic, 'يرجى إكمال الحقول المطلوبة بشكل صحيح',
              'Please complete all required fields correctly'),
          isError: true,
          isArabic: isArabic);
      return;
    }

    if (_selectedRole == SignupRole.seller &&
        (_selectedDocument == null || _selectedDocument!.isEmpty)) {
      _showMessage(
          t(isArabic, 'يرجى إرفاق المستند المطلوب',
              'Please attach the required document'),
          isError: true,
          isArabic: isArabic);
      return;
    }

    setState(() => _isLoading = true);

    // محاكاة طلب الشبكة
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showMessage(
          t(isArabic, 'تم إنشاء الحساب بنجاح', 'Account created successfully'),
          isArabic: isArabic);
      // يمكن إضافة التوجيه إلى الصفحة الرئيسية هنا
    });
  }

  void _showMessage(String msg,
      {bool isError = false, required bool isArabic}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: ts(isArabic,
                size: 14, color: Colors.white, weight: FontWeight.w600)),
        backgroundColor: isError ? Colors.redAccent : AppPalette.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(14),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isArabic = !settings.isEnglish;
    final isDark = settings.isDarkMode;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            _buildBackground(isDark),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: isTablet ? 520 : double.infinity),
                    child: FadeTransition(
                      opacity: _contentFade,
                      child: Column(
                        children: [
                          _buildHeader(isArabic, isDark),
                          const SizedBox(height: 30),
                          _buildSignupForm(isArabic, isDark),
                        ],
                      ),
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

  Widget _buildBackground(bool isDark) {
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
          Positioned(top: -70, left: -70, child: _circleDecoration(230)),
          Positioned(bottom: -120, right: -80, child: _circleDecoration(320)),
        ],
      ),
    );
  }

  Widget _circleDecoration(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Colors.white.withOpacity(0.04)),
    );
  }

  Widget _buildHeader(bool isArabic, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12), shape: BoxShape.circle),
          child: Icon(Icons.storefront_rounded,
              size: 48, color: heroText(isDark)),
        ),
        const SizedBox(height: 12),
        Text(t(isArabic, 'انضم إلينا كـ بائع شريك', 'Join as a Seller Partner'),
            textAlign: TextAlign.center,
            style: ts(isArabic,
                size: 24, weight: FontWeight.w800, color: heroText(isDark))),
        const SizedBox(height: 6),
        Text(
            t(isArabic, 'أنشئ حسابك التجاري وابدأ في بيع وتوريد قطع الغيار',
                'Create your merchant account and start selling auto parts'),
            textAlign: TextAlign.center,
            style: ts(isArabic, size: 13.5, color: Colors.white70)),
      ],
    );
  }

  Widget _buildSignupForm(bool isArabic, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg(isDark),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
              color: cardShadow(isDark),
              blurRadius: 24,
              offset: const Offset(0, 14))
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomInputField(
              controller: _storeNameController,
              label: t(isArabic, 'اسم المحل / المركز التجاري', 'Store / Merchant Name'),
              icon: Icons.storefront_outlined,
              isDark: isDark,
              isArabic: isArabic,
              validator: (value) => value == null || value.trim().isEmpty
                  ? t(isArabic, 'هذا الحقل مطلوب', 'This field is required')
                  : null,
            ),
            const SizedBox(height: 16),
            CustomInputField(
              controller: _emailController,
              label: t(isArabic, 'البريد الإلكتروني', 'Email'),
              icon: Icons.alternate_email,
              type: TextInputType.emailAddress,
              isDark: isDark,
              isArabic: isArabic,
              validator: (value) {
                if (value == null || value.trim().isEmpty)
                  return t(
                      isArabic, 'البريد الإلكتروني مطلوب', 'Email is required');
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return t(isArabic, 'صيغة البريد الإلكتروني غير صحيحة',
                      'Invalid email format');
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomInputField(
              controller: _phoneController,
              label: t(isArabic, 'رقم الهاتف', 'Phone'),
              icon: Icons.phone_android,
              type: TextInputType.phone,
              isDark: isDark,
              isArabic: isArabic,
              validator: (value) => value == null || value.trim().isEmpty
                  ? t(isArabic, 'رقم الهاتف مطلوب', 'Phone is required')
                  : null,
            ),
            const SizedBox(height: 16),
            if (_selectedRole == SignupRole.seller) ...[
              CustomInputField(
                controller: _cityController,
                label: t(isArabic, 'المدينة', 'City'),
                icon: Icons.location_city,
                isDark: isDark,
                isArabic: isArabic,
                validator: (value) => value == null || value.trim().isEmpty
                    ? t(isArabic, 'المدينة مطلوبة للبائعين',
                        'City is required for sellers')
                    : null,
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: _districtController,
                label: t(isArabic, 'الحي / المنطقة', 'District / Area'),
                icon: Icons.location_on_outlined,
                isDark: isDark,
                isArabic: isArabic,
                validator: (value) => value == null || value.trim().isEmpty
                    ? t(isArabic, 'الحي مطلوب للبائعين',
                        'District is required for sellers')
                    : null,
              ),
              const SizedBox(height: 16),
              CustomInputField(
                controller: _streetController,
                label: t(isArabic, 'الشارع', 'Street'),
                icon: Icons.signpost_outlined,
                isDark: isDark,
                isArabic: isArabic,
                validator: (value) => value == null || value.trim().isEmpty
                    ? t(isArabic, 'الشارع مطلوب للبائعين',
                        'Street is required for sellers')
                    : null,
              ),
              const SizedBox(height: 16),
              FormField<PartsType>(
                initialValue: _partsType,
                validator: (value) => value == null
                    ? t(isArabic, 'يرجى اختيار نوع القطع',
                        'Please choose parts type')
                    : null,
                builder: (fieldState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t(isArabic, 'نوع القطع', 'Parts type'),
                        style: ts(isArabic,
                            size: 13.5,
                            weight: FontWeight.w700,
                            color: textPrimary(isDark)),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _partsTypeChip(
                            label: t(isArabic, 'جديد', 'New'),
                            selected: _partsType == PartsType.newParts,
                            isDark: isDark,
                            isArabic: isArabic,
                            onTap: () {
                              setState(() => _partsType = PartsType.newParts);
                              fieldState.didChange(PartsType.newParts);
                            },
                          ),
                          const SizedBox(width: 10),
                          _partsTypeChip(
                            label: t(isArabic, 'تشليح', 'Scrapy'),
                            selected: _partsType == PartsType.scrapy,
                            isDark: isDark,
                            isArabic: isArabic,
                            onTap: () {
                              setState(() => _partsType = PartsType.scrapy);
                              fieldState.didChange(PartsType.scrapy);
                            },
                          ),
                        ],
                      ),
                      if (fieldState.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            fieldState.errorText!,
                            style:
                                ts(isArabic, size: 12, color: Colors.redAccent),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              UploadDocumentTile(
                isArabic: isArabic,
                isDark: isDark,
                selectedDocument: _selectedDocument,
                onTap: () => setState(
                    () => _selectedDocument = "Commercial_Register_01.pdf"),
              ),
              const SizedBox(height: 16),
            ],
            CustomInputField(
              controller: _passwordController,
              label: t(isArabic, 'كلمة المرور', 'Password'),
              icon: Icons.lock_outline,
              obscure: true,
              isDark: isDark,
              isArabic: isArabic,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return t(
                      isArabic, 'كلمة المرور مطلوبة', 'Password is required');
                if (value.length < 6)
                  return t(isArabic, 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
                      'Password must be at least 6 characters');
                return null;
              },
            ),
            const SizedBox(height: 32),
            _buildSubmitButton(isArabic, isDark),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UnifiedLoginScreen(),
                ),
              ),
              child: Text(
                t(isArabic, 'لديك حساب بالفعل؟ تسجيل الدخول',
                    'Already have an account? Login'),
                style: ts(isArabic,
                    size: 13.5,
                    weight: FontWeight.w600,
                    color: AppPalette.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(bool isArabic, bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isLoading ? null : () => _handleSubmit(isArabic),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPalette.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5),
              )
            : Text(t(isArabic, 'تسجيل حساب تجاري جديد', 'Register Merchant Account'),
                style: ts(isArabic,
                    size: 16, weight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _partsTypeChip({
    required String label,
    required bool selected,
    required bool isDark,
    required bool isArabic,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: selected
                ? AppPalette.primary.withOpacity(0.12)
                : cardBg(isDark),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppPalette.primary : cardBorder(isDark),
              width: selected ? 1.4 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppPalette.primary.withOpacity(0.10),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                size: 18,
                color: selected ? AppPalette.primary : textSecondary(isDark),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: ts(
                  isArabic,
                  size: 13.5,
                  weight: FontWeight.w700,
                  color: selected ? AppPalette.primary : textPrimary(isDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType type;
  final bool obscure;
  final int maxLines;
  final String? Function(String?)? validator;
  final bool isDark;
  final bool isArabic;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.type = TextInputType.text,
    this.obscure = false,
    this.maxLines = 1,
    this.validator,
    required this.isDark,
    required this.isArabic,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.type,
      obscureText: widget.obscure ? _isObscured : false,
      maxLines: widget.obscure ? 1 : widget.maxLines,
      validator: widget.validator,
      style: ts(widget.isArabic,
          size: 15, weight: FontWeight.w500, color: textPrimary(widget.isDark)),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle:
            ts(widget.isArabic, color: textSecondary(widget.isDark), size: 14),
        prefixIcon: Icon(widget.icon, color: AppPalette.primary, size: 22),
        suffixIcon: widget.obscure
            ? IconButton(
                icon: Icon(
                  _isObscured
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: textSecondary(widget.isDark),
                  size: 20,
                ),
                onPressed: () => setState(() => _isObscured = !_isObscured),
              )
            : null,
        filled: true,
        fillColor: cardBg(widget.isDark),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cardBorder(widget.isDark)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppPalette.primary, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        errorStyle: ts(widget.isArabic, size: 12, color: Colors.redAccent),
      ),
    );
  }
}

class RoleSelectionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final bool isDark;
  final bool isArabic;

  const RoleSelectionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.isDark,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: selected ? 1.02 : 1.0,
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 12), // مسافات متناسقة
          decoration: BoxDecoration(
            color: selected
                ? AppPalette.primary.withOpacity(0.04)
                : cardBg(isDark),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppPalette.primary : cardBorder(isDark),
              width: selected ? 2.0 : 1.0,
            ),
            boxShadow: [
              if (selected)
                BoxShadow(
                  color: AppPalette.primary.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected
                          ? AppPalette.primary
                          : AppPalette.primary.withOpacity(0.08),
                    ),
                    child: Icon(
                      icon,
                      color: selected ? Colors.white : AppPalette.primary,
                      size: 24,
                    ),
                  ),
                  if (selected)
                    const Icon(Icons.check_circle_rounded,
                        color: AppPalette.primary, size: 24),
                  if (!selected)
                    const SizedBox(
                        width: 24, height: 24), // للحفاظ على توازن الارتفاع
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: ts(isArabic,
                    size: 16,
                    weight: FontWeight.w800,
                    color: selected ? AppPalette.primary : textPrimary(isDark)),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: ts(isArabic,
                    size: 12, height: 1.4, color: textSecondary(isDark)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UploadDocumentTile extends StatelessWidget {
  final bool isArabic;
  final bool isDark;
  final String? selectedDocument;
  final VoidCallback onTap;

  const UploadDocumentTile({
    super.key,
    required this.isArabic,
    required this.isDark,
    required this.selectedDocument,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = selectedDocument != null && selectedDocument!.isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: cardBg(isDark),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasFile ? AppPalette.primary : cardBorder(isDark),
            width: hasFile ? 1.2 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: hasFile
                    ? AppPalette.primary
                    : AppPalette.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                  hasFile
                      ? Icons.check_circle_outline
                      : Icons.cloud_upload_rounded,
                  color: hasFile ? Colors.white : AppPalette.primary,
                  size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t(isArabic, 'السجل التجاري / صورة المحل',
                        'Commercial registry / store photo'),
                    style: ts(isArabic,
                        size: 14,
                        weight: FontWeight.w700,
                        color: textPrimary(isDark)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hasFile
                        ? selectedDocument!
                        : t(isArabic, 'اضغط لاختيار ملف', 'Tap to choose file'),
                    style: ts(
                      isArabic,
                      size: 12,
                      color:
                          hasFile ? AppPalette.primary : textSecondary(isDark),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
