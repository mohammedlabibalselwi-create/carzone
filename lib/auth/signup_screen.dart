import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import 'unified_login_screen.dart';
import '../suppliers/screens/supplier_main_navigation_screen.dart';

// --- دوال المساعدة ---
String t(bool isArabic, String ar, String en) => isArabic ? ar : en;

TextStyle ts(bool isArabic,
    {double? size,
    FontWeight? weight,
    Color? color,
    double? height,
    TextDecoration? decoration,
    double? letterSpacing}) {
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

enum SignupCountry { yemen, saudi }

class CityItem {
  final String ar;
  final String en;

  const CityItem(this.ar, this.en);

  String name(bool isArabic) => isArabic ? ar : en;
}

const List<CityItem> yemenCities = [
  CityItem('صنعاء', 'Sana\'a'),
  CityItem('عدن', 'Aden'),
  CityItem('تعز', 'Taiz'),
  CityItem('الحديدة', 'Al Hudaydah'),
  CityItem('إب', 'Ibb'),
  CityItem('المكلا', 'Mukalla'),
  CityItem('ذمار', 'Dhamar'),
  CityItem('سيئون', 'Seiyun'),
  CityItem('عمران', 'Amran'),
  CityItem('صعدة', 'Saada'),
  CityItem('مأرب', 'Marib'),
  CityItem('الغيضة', 'Al Ghaydah'),
  CityItem('عتق', 'Ataq'),
  CityItem('حجة', 'Hajjah'),
  CityItem('البيضاء', 'Al Bayda'),
  CityItem('زنجبار', 'Zinjibar'),
  CityItem('المحويت', 'Al Mahwit'),
  CityItem('رداع', 'Rada\'a'),
  CityItem('تريم', 'Tarim'),
  CityItem('الشحر', 'Ash Shihr'),
];

const List<CityItem> saudiCities = [
  CityItem('الرياض', 'Riyadh'),
  CityItem('جدة', 'Jeddah'),
  CityItem('مكة المكرمة', 'Makkah'),
  CityItem('المدينة المنورة', 'Madinah'),
  CityItem('الدمام', 'Dammam'),
  CityItem('الخبر', 'Khobar'),
  CityItem('الظهران', 'Dhahran'),
  CityItem('الأحساء', 'Al Ahsa'),
  CityItem('الطائف', 'Taif'),
  CityItem('تبوك', 'Tabuk'),
  CityItem('بريدة', 'Buraidah'),
  CityItem('عنيزة', 'Unaizah'),
  CityItem('أبها', 'Abha'),
  CityItem('خميس مشيط', 'Khamis Mushait'),
  CityItem('جازان', 'Jazan'),
  CityItem('نجران', 'Najran'),
  CityItem('حائل', 'Hail'),
  CityItem('الجوف', 'Al Jouf'),
  CityItem('عرعر', 'Arar'),
  CityItem('الباحة', 'Al Baha'),
  CityItem('ينبع', 'Yanbu'),
  CityItem('الجبيل', 'Jubail'),
  CityItem('القنفذة', 'Al Qunfudhah'),
];

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  SignupRole _selectedRole = SignupRole.seller;
  PartsType _partsType = PartsType.newParts;
  SignupCountry _selectedCountry = SignupCountry.yemen;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final isArabic = !settings.isEnglish;
    if (_cityController.text.isEmpty) {
      _cityController.text = _selectedCountry == SignupCountry.yemen
          ? (isArabic ? 'صنعاء' : 'Sana\'a')
          : (isArabic ? 'الرياض' : 'Riyadh');
    }
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

  void _onCountryChanged(SignupCountry country, bool isArabic) {
    if (_selectedCountry == country) return;
    setState(() {
      _selectedCountry = country;
      if (country == SignupCountry.yemen) {
        _cityController.text = isArabic ? 'صنعاء' : 'Sana\'a';
      } else {
        _cityController.text = isArabic ? 'الرياض' : 'Riyadh';
      }
    });
  }

  void _handleSubmit(bool isArabic) {
    if (_selectedRole == SignupRole.seller) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SupplierMainNavigationScreen(),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      _showMessage(
          t(isArabic, 'يرجى إكمال الحقول المطلوبة بشكل صحيح',
              'Please complete all required fields correctly'),
          isError: true,
          isArabic: isArabic);
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showMessage(
          t(isArabic, 'تم التسجيل بنجاح!', 'Account created successfully!'),
          isArabic: isArabic);
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
                          const SizedBox(height: 25),
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
          child:
              Icon(Icons.storefront_rounded, size: 48, color: heroText(isDark)),
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
            _buildCountrySelector(isArabic, isDark),
            const SizedBox(height: 18),
            CustomInputField(
              controller: _storeNameController,
              label: t(isArabic, 'اسم المحل / المركز التجاري',
                  'Store / Merchant Name'),
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
            _buildMapPickerButton(isArabic, isDark),
            const SizedBox(height: 16),
            CustomInputField(
              controller: _cityController,
              label: t(
                  isArabic, 'المدينة (اضغط للاختيار)', 'City (Tap to choose)'),
              icon: Icons.location_city,
              readOnly: true,
              onTap: () => _openCityPickerSheet(isArabic, isDark),
              suffixIcon: const Icon(Icons.arrow_drop_down_circle_outlined,
                  color: AppPalette.primary),
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
              label: t(isArabic, 'الشارع / العنوان بالتفصيل', 'Street Address'),
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
            const SizedBox(height: 28),
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

  Widget _buildCountrySelector(bool isArabic, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t(isArabic, 'اختر الدولة', 'Select Country'),
          style: ts(isArabic,
              size: 13.5, weight: FontWeight.w700, color: textPrimary(isDark)),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _countryChip(
                flag: '🇾🇪',
                label: t(isArabic, 'اليمن', 'Yemen'),
                selected: _selectedCountry == SignupCountry.yemen,
                isDark: isDark,
                isArabic: isArabic,
                onTap: () => _onCountryChanged(SignupCountry.yemen, isArabic),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _countryChip(
                flag: '🇸🇦',
                label: t(isArabic, 'السعودية', 'Saudi Arabia'),
                selected: _selectedCountry == SignupCountry.saudi,
                isDark: isDark,
                isArabic: isArabic,
                onTap: () => _onCountryChanged(SignupCountry.saudi, isArabic),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _countryChip({
    required String flag,
    required String label,
    required bool selected,
    required bool isDark,
    required bool isArabic,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color:
              selected ? AppPalette.primary.withOpacity(0.12) : cardBg(isDark),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppPalette.primary : cardBorder(isDark),
            width: selected ? 1.8 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppPalette.primary.withOpacity(0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(flag, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              label,
              style: ts(
                isArabic,
                size: 14,
                weight: FontWeight.bold,
                color: selected ? AppPalette.primary : textPrimary(isDark),
              ),
            ),
            if (selected) ...[
              const SizedBox(width: 6),
              const Icon(Icons.check_circle_rounded,
                  size: 16, color: AppPalette.primary),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildMapPickerButton(bool isArabic, bool isDark) {
    return InkWell(
      onTap: () => _openMapPickerSheet(isArabic, isDark),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: AppPalette.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppPalette.primary.withOpacity(0.3),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: AppPalette.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.my_location_rounded,
                  color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            Text(
              t(isArabic, 'تحديد الموقع على الخريطة (اختياري)',
                  'Pick Location on Map (Optional)'),
              style: ts(
                isArabic,
                size: 13,
                weight: FontWeight.bold,
                color: AppPalette.primary,
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.map_outlined,
                size: 18, color: AppPalette.primary.withOpacity(0.8)),
          ],
        ),
      ),
    );
  }

  void _openCityPickerSheet(bool isArabic, bool isDark) {
    final cities =
        _selectedCountry == SignupCountry.yemen ? yemenCities : saudiCities;
    final countryName = _selectedCountry == SignupCountry.yemen
        ? (isArabic ? 'اليمن 🇾🇪' : 'Yemen 🇾🇪')
        : (isArabic ? 'السعودية 🇸🇦' : 'Saudi Arabia 🇸🇦');

    String searchQuery = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cardBg(isDark),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final filteredCities = cities.where((c) {
              final query = searchQuery.trim().toLowerCase();
              return c.ar.contains(searchQuery.trim()) ||
                  c.en.toLowerCase().contains(query);
            }).toList();

            return Container(
              height: MediaQuery.of(ctx).size.height * 0.65,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.location_city_rounded,
                          color: AppPalette.primary),
                      const SizedBox(width: 10),
                      Text(
                        t(isArabic, 'اختر المدينة ($countryName)',
                            'Select City ($countryName)'),
                        style: ts(isArabic,
                            size: 16,
                            weight: FontWeight.bold,
                            color: textPrimary(isDark)),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.close_rounded,
                            color: textPrimary(isDark)),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (val) => setSheetState(() => searchQuery = val),
                    style: ts(isArabic, size: 14, color: textPrimary(isDark)),
                    decoration: InputDecoration(
                      hintText: t(
                          isArabic, 'ابحث عن اسم المدينة...', 'Search city...'),
                      hintStyle:
                          ts(isArabic, size: 13, color: textSecondary(isDark)),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: AppPalette.primary),
                      filled: true,
                      fillColor: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.grey.withOpacity(0.08),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: filteredCities.isEmpty
                        ? Center(
                            child: Text(
                              t(isArabic, 'لم يتم العثور على مدن',
                                  'No cities found'),
                              style: ts(isArabic,
                                  size: 14, color: textSecondary(isDark)),
                            ),
                          )
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: filteredCities.length,
                            separatorBuilder: (_, __) =>
                                Divider(height: 1, color: cardBorder(isDark)),
                            itemBuilder: (ctx, idx) {
                              final city = filteredCities[idx];
                              final cityName = city.name(isArabic);
                              final isSelected =
                                  _cityController.text == cityName ||
                                      _cityController.text == city.ar ||
                                      _cityController.text == city.en;

                              return ListTile(
                                onTap: () {
                                  setState(() {
                                    _cityController.text = cityName;
                                  });
                                  Navigator.pop(ctx);
                                },
                                leading: Icon(
                                  Icons.location_on_outlined,
                                  color: isSelected
                                      ? AppPalette.primary
                                      : textSecondary(isDark),
                                ),
                                title: Text(
                                  cityName,
                                  style: ts(
                                    isArabic,
                                    size: 15,
                                    weight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? AppPalette.primary
                                        : textPrimary(isDark),
                                  ),
                                ),
                                subtitle: Text(
                                  isArabic ? city.en : city.ar,
                                  style: ts(
                                    isArabic,
                                    size: 12,
                                    color: textSecondary(isDark),
                                  ),
                                ),
                                trailing: isSelected
                                    ? const Icon(Icons.check_circle_rounded,
                                        color: AppPalette.primary)
                                    : null,
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openMapPickerSheet(bool isArabic, bool isDark) {
    final currentCountry = _selectedCountry;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cardBg(isDark),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final mockCity = currentCountry == SignupCountry.yemen
            ? (isArabic ? 'صنعاء' : 'Sana\'a')
            : (isArabic ? 'الرياض' : 'Riyadh');
        final mockDistrict = currentCountry == SignupCountry.yemen
            ? (isArabic ? 'حي السبعين' : 'Al-Sabeen District')
            : (isArabic ? 'حي العليا' : 'Al-Olaya District');
        final mockStreet = currentCountry == SignupCountry.yemen
            ? (isArabic ? 'شارع الستين' : 'Sixty Street')
            : (isArabic ? 'طريق الملك فهد' : 'King Fahd Road');

        return Container(
          height: MediaQuery.of(ctx).size.height * 0.75,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.map_rounded,
                      color: AppPalette.primary, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    t(isArabic, 'تحديد الموقع على الخريطة',
                        'Pick Location on Map'),
                    style: ts(isArabic,
                        size: 16,
                        weight: FontWeight.bold,
                        color: textPrimary(isDark)),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: textPrimary(isDark)),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Mock Map Container
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFE2E8F0),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.map,
                            size: 140,
                            color: isDark
                                ? Colors.white.withOpacity(0.08)
                                : Colors.black.withOpacity(0.06),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppPalette.primary,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8)
                                ],
                              ),
                              child: Text(
                                t(isArabic, 'اسحب الخريطة لتحديد موقعك 📍',
                                    'Drag to pick position 📍'),
                                style: ts(isArabic,
                                    size: 12,
                                    color: Colors.white,
                                    weight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Icon(Icons.location_on_rounded,
                                size: 48, color: Colors.redAccent),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 14,
                        left: 14,
                        right: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: cardBg(isDark).withOpacity(0.95),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10)
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search_rounded,
                                  color: AppPalette.primary, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  t(isArabic, 'ابحث عن عنوان، حي أو معلم...',
                                      'Search address or landmark...'),
                                  style: ts(isArabic,
                                      size: 13, color: textSecondary(isDark)),
                                ),
                              ),
                              const Icon(Icons.my_location_rounded,
                                  color: AppPalette.primary, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Selected Address Box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppPalette.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: AppPalette.primary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.place_rounded,
                        color: AppPalette.primary, size: 26),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t(isArabic, 'العنوان المكتشف تلقائياً:',
                                'Detected Address:'),
                            style: ts(isArabic,
                                size: 11.5, color: textSecondary(isDark)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$mockCity - $mockDistrict - $mockStreet',
                            style: ts(isArabic,
                                size: 13.5,
                                weight: FontWeight.bold,
                                color: textPrimary(isDark)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _cityController.text = mockCity;
                      _districtController.text = mockDistrict;
                      _streetController.text = mockStreet;
                    });
                    Navigator.pop(ctx);
                    _showMessage(
                      t(
                          isArabic,
                          'تم تحديد المدينة والحي والشارع تلقائياً بناءً على الخريطة!',
                          'City, District, and Street updated automatically from map!'),
                      isArabic: isArabic,
                    );
                  },
                  icon: const Icon(Icons.check_rounded, color: Colors.white),
                  label: Text(
                    t(isArabic, 'تأكيد واعتماد هذا الموقع', 'Confirm Location'),
                    style: ts(isArabic,
                        size: 15, weight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPalette.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
            : Text(
                t(isArabic, 'تسجيل حساب تجاري جديد',
                    'Register Merchant Account'),
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
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
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
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
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
      readOnly: widget.readOnly,
      onTap: widget.onTap,
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
        suffixIcon: widget.suffixIcon ??
            (widget.obscure
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
                : null),
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
