import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive_layout.dart';

class SellerVerificationScreen extends StatefulWidget {
  const SellerVerificationScreen({super.key});

  @override
  State<SellerVerificationScreen> createState() =>
      _SellerVerificationScreenState();
}

class _SellerVerificationScreenState extends State<SellerVerificationScreen> {
  int _currentStep = 0;
  bool _isSubmitted = false;

  final _formKey = GlobalKey<FormState>();

  // Step 1 Controllers
  final _storeNameController = TextEditingController();
  final _crNumberController = TextEditingController();

  // Step 2 Controllers & State
  String _partsCategory = 'new'; // 'new', 'scrapy', 'all'
  final _cityController = TextEditingController(text: 'صنعاء');
  final _districtController = TextEditingController();

  // Step 3 Controllers
  final _bankNameController = TextEditingController();
  final _ibanController = TextEditingController();

  // Step 4 Documents state
  String? _uploadedDocName;

  String _t(bool isArabic, String ar, String en) => isArabic ? ar : en;

  @override
  void dispose() {
    _storeNameController.dispose();
    _crNumberController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _bankNameController.dispose();
    _ibanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;
    final isArabic = !settings.isEnglish;

    return Directionality(
      textDirection: settings.direction,
      child: Scaffold(
        backgroundColor: background(isDark),
        appBar: AppBar(
          backgroundColor: AppPalette.primary,
          elevation: 0,
          title: Text(
            _t(isArabic, 'توثيق حساب البائع التجاري', 'Seller Verification'),
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: ResponsiveCenter(
          maxWidth: 750,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Verification Status Card Header
                _buildStatusHeaderCard(isArabic, isDark),

                const SizedBox(height: 24),

                if (_isSubmitted)
                  _buildSuccessConfirmationCard(isArabic, isDark)
                else ...[
                  // Step Indicator Header
                  _buildStepIndicator(isArabic, isDark),

                  const SizedBox(height: 24),

                  // Active Step Form Container
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: cardBg(isDark),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: cardBorder(isDark)),
                        boxShadow: [
                          BoxShadow(
                            color: cardShadow(isDark),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: _buildCurrentStepContent(isArabic, isDark),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Bottom Action Buttons
                  _buildNavigationButtons(isArabic, isDark),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Top Status Header Banner
  Widget _buildStatusHeaderCard(bool isArabic, bool isDark) {
    final Color badgeColor = _isSubmitted ? AppPalette.accent : AppPalette.danger;
    final String statusText = _isSubmitted
        ? _t(isArabic, 'قيد المراجعة والتدقيق', 'Under Review')
        : _t(isArabic, 'غير موثّق (مطلوب)', 'Unverified (Required)');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFFEFF6FF), const Color(0xFFDBEAFE)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppPalette.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppPalette.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              size: 32,
              color: AppPalette.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _t(isArabic, 'توثيق الهوية والتجارة',
                          'Merchant Verification'),
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textPrimary(isDark),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: badgeColor),
                      ),
                      child: Text(
                        statusText,
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: badgeColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _t(
                    isArabic,
                    'توثيق حسابك يمنحك شارة التاجر الموثوق ويسمح لك بإرسال عروض الأسعار والبيع المباشر.',
                    'Verifying your account gives you a verified badge and enables quote submissions.',
                  ),
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: textSecondary(isDark),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 4-Step Visual Progress Indicator
  Widget _buildStepIndicator(bool isArabic, bool isDark) {
    final steps = [
      _t(isArabic, 'المنشأة', 'Store'),
      _t(isArabic, 'النشاط والموقع', 'Location'),
      _t(isArabic, 'الحساب البنكي', 'Bank'),
      _t(isArabic, 'المستندات', 'Documents'),
    ];

    return Row(
      children: List.generate(steps.length, (index) {
        final isActive = index == _currentStep;
        final isDone = index < _currentStep;

        return Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isDone
                          ? AppPalette.success
                          : (isActive
                              ? AppPalette.primary
                              : cardBg(isDark)),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDone || isActive
                            ? Colors.transparent
                            : cardBorder(isDark),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: isDone
                          ? const Icon(Icons.check, size: 18, color: Colors.white)
                          : Text(
                              '${index + 1}',
                              style: GoogleFonts.cairo(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isActive || isDone
                                    ? Colors.white
                                    : textSecondary(isDark),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    steps[index],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: 10.5,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.w500,
                      color: isActive
                          ? AppPalette.primary
                          : textSecondary(isDark),
                    ),
                  ),
                ],
              ),
              if (index < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    color: index < _currentStep
                        ? AppPalette.success
                        : cardBorder(isDark),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  /// Step Form Contents Switcher
  Widget _buildCurrentStepContent(bool isArabic, bool isDark) {
    switch (_currentStep) {
      case 0:
        return _buildStep1CommercialInfo(isArabic, isDark);
      case 1:
        return _buildStep2ActivityAndLocation(isArabic, isDark);
      case 2:
        return _buildStep3BankInfo(isArabic, isDark);
      case 3:
        return _buildStep4DocumentUpload(isArabic, isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  /// Step 1: Commercial Registration & Merchant Name
  Widget _buildStep1CommercialInfo(bool isArabic, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t(isArabic, 'الخطوة 1: بيانات المنشأة والتجارة',
              'Step 1: Store & Commercial Details'),
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textPrimary(isDark),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _storeNameController,
          style: GoogleFonts.cairo(color: textPrimary(isDark)),
          decoration: _inputDecoration(
            hint: _t(isArabic, 'اسم المتجر أو المؤسسة التجارية...',
                'Store or Enterprise Name...'),
            label: _t(isArabic, 'اسم المتجر / الشركة', 'Store Name'),
            icon: Icons.storefront_outlined,
            isDark: isDark,
          ),
          validator: (v) => v == null || v.trim().isEmpty
              ? _t(isArabic, 'اسم المتجر مطلوب', 'Store name is required')
              : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _crNumberController,
          keyboardType: TextInputType.number,
          style: GoogleFonts.cairo(color: textPrimary(isDark)),
          decoration: _inputDecoration(
            hint: _t(isArabic, 'أدخل رقم السجل التجاري (7-10 أرقام)...',
                'Enter CR Number...'),
            label: _t(isArabic, 'رقم السجل التجاري أو الترخيص',
                'Commercial Register No.'),
            icon: Icons.subtitles_outlined,
            isDark: isDark,
          ),
          validator: (v) => v == null || v.trim().isEmpty
              ? _t(isArabic, 'رقم السجل مطلوب', 'CR number is required')
              : null,
        ),
      ],
    );
  }

  /// Step 2: Activity Type & City/District
  Widget _buildStep2ActivityAndLocation(bool isArabic, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t(isArabic, 'الخطوة 2: نوع النشاط والموقع الجغرافي',
              'Step 2: Business Activity & Location'),
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textPrimary(isDark),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          _t(isArabic, 'تصنيف قطع الغيار والخدمات:', 'Parts Category:'),
          style: GoogleFonts.cairo(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textSecondary(isDark)),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _choiceChip(
                label: _t(isArabic, '✨ جديد (وكالة)', '✨ New OEM'),
                selected: _partsCategory == 'new',
                isDark: isDark,
                onTap: () => setState(() => _partsCategory = 'new'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _choiceChip(
                label: _t(isArabic, '📦 تشليح (مستعمل)', '📦 Scrapy'),
                selected: _partsCategory == 'scrapy',
                isDark: isDark,
                onTap: () => setState(() => _partsCategory = 'scrapy'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _choiceChip(
                label: _t(isArabic, '⚡ الكل', '⚡ Both'),
                selected: _partsCategory == 'all',
                isDark: isDark,
                onTap: () => setState(() => _partsCategory = 'all'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        TextFormField(
          controller: _cityController,
          style: GoogleFonts.cairo(color: textPrimary(isDark)),
          decoration: _inputDecoration(
            hint: _t(isArabic, 'صنعاء / الرياض / عدن...', 'City...'),
            label: _t(isArabic, 'المدينة الرئيسيّة', 'City'),
            icon: Icons.location_city_outlined,
            isDark: isDark,
          ),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _districtController,
          style: GoogleFonts.cairo(color: textPrimary(isDark)),
          decoration: _inputDecoration(
            hint: _t(isArabic, 'اسم الحي أو المنطقة بالتفصيل...',
                'District or Area...'),
            label: _t(isArabic, 'الحي / المنطقة / الشارع', 'District / Street'),
            icon: Icons.signpost_outlined,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  /// Step 3: Bank Account / IBAN Details
  Widget _buildStep3BankInfo(bool isArabic, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t(isArabic, 'الخطوة 3: بيانات الحساب البنكي للتسوية',
              'Step 3: Settlement Bank Account'),
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textPrimary(isDark),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _t(
            isArabic,
            'تستخدم هذه البيانات لتحويل مستحقات مبيعاتك وعروضك المعتمدة تلقائياً.',
            'Used for automatic payouts of your accepted sales quotes.',
          ),
          style: GoogleFonts.cairo(fontSize: 12, color: textSecondary(isDark)),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _bankNameController,
          style: GoogleFonts.cairo(color: textPrimary(isDark)),
          decoration: _inputDecoration(
            hint: _t(isArabic, 'بنك التضامن / البنك الأهلي...', 'Bank Name...'),
            label: _t(isArabic, 'اسم البنك المصرفي', 'Bank Name'),
            icon: Icons.account_balance_outlined,
            isDark: isDark,
          ),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _ibanController,
          style: GoogleFonts.cairo(color: textPrimary(isDark)),
          decoration: _inputDecoration(
            hint: 'YE... / SA...',
            label: _t(isArabic, 'رقم الحساب أو الآيبان (IBAN)', 'IBAN Number'),
            icon: Icons.credit_card_outlined,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  /// Step 4: Documents Upload
  Widget _buildStep4DocumentUpload(bool isArabic, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t(isArabic, 'الخطوة 4: إرفاق وثيقة السجل أو الهوية',
              'Step 4: Attach CR / ID Document'),
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textPrimary(isDark),
          ),
        ),
        const SizedBox(height: 14),
        InkWell(
          onTap: () {
            setState(() {
              _uploadedDocName = "Commercial_Register_Doc.pdf";
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _uploadedDocName != null
                  ? AppPalette.success.withOpacity(0.08)
                  : AppPalette.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _uploadedDocName != null
                    ? AppPalette.success
                    : AppPalette.primary.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _uploadedDocName != null
                      ? Icons.check_circle_rounded
                      : Icons.cloud_upload_outlined,
                  size: 32,
                  color: _uploadedDocName != null
                      ? AppPalette.success
                      : AppPalette.primary,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _uploadedDocName ??
                            _t(isArabic, 'انقر هنا لرفع صورة السجل / الرخصة',
                                'Tap to upload CR / License document'),
                        style: GoogleFonts.cairo(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: textPrimary(isDark),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _uploadedDocName != null
                            ? _t(isArabic, 'تم إرفاق المستند بنجاح!',
                                'Document attached!')
                            : _t(isArabic, 'الصيغ المتاحة: PDF, PNG, JPG (حجم أقصى 5MB)',
                                'Formats: PDF, PNG, JPG (Max 5MB)'),
                        style: GoogleFonts.cairo(
                          fontSize: 11.5,
                          color: textSecondary(isDark),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Navigation Buttons (التالي / السابق / إرسال)
  Widget _buildNavigationButtons(bool isArabic, bool isDark) {
    final bool isLastStep = _currentStep == 3;

    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            flex: 4,
            child: OutlinedButton(
              onPressed: () => setState(() => _currentStep--),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: cardBorder(isDark)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                _t(isArabic, 'السابق', 'Previous'),
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textPrimary(isDark),
                ),
              ),
            ),
          ),
        if (_currentStep > 0) const SizedBox(width: 12),
        Expanded(
          flex: 6,
          child: ElevatedButton(
            onPressed: () {
              if (isLastStep) {
                setState(() => _isSubmitted = true);
              } else {
                setState(() => _currentStep++);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isLastStep ? AppPalette.success : AppPalette.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              isLastStep
                  ? _t(isArabic, 'إرسال طلب التوثيق الآن', 'Submit Verification')
                  : _t(isArabic, 'الخطوة التالية', 'Next Step'),
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Success Banner
  Widget _buildSuccessConfirmationCard(bool isArabic, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg(isDark),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppPalette.success.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          const Icon(Icons.task_alt_rounded, size: 64, color: AppPalette.success),
          const SizedBox(height: 16),
          Text(
            _t(isArabic, 'تم إرسال طلب التوثيق بنجاح!',
                'Verification Submitted!'),
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textPrimary(isDark),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _t(
              isArabic,
              'سيقوم فريق CarZone بمراجعة مستنداتك وسجلك التجاري خلال 24 ساعة لتفعيل حسابك بالكامل.',
              'Our team will review your CR & documents within 24 hours to activate full seller privileges.',
            ),
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 13,
              color: textSecondary(isDark),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                _t(isArabic, 'العودة للوحة تحكم البائع', 'Back to Seller Dashboard'),
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _choiceChip({
    required String label,
    required bool selected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppPalette.primary.withOpacity(0.12)
              : cardBg(isDark),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppPalette.primary : cardBorder(isDark),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 11.5,
              fontWeight: selected ? FontWeight.bold : FontWeight.w600,
              color: selected ? AppPalette.primary : textPrimary(isDark),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required String label,
    required IconData icon,
    required bool isDark,
  }) {
    return InputDecoration(
      hintText: hint,
      labelText: label,
      labelStyle: GoogleFonts.cairo(color: AppPalette.primary, fontSize: 13),
      hintStyle: GoogleFonts.cairo(fontSize: 12, color: textSecondary(isDark)),
      prefixIcon: Icon(icon, color: AppPalette.primary, size: 20),
      filled: true,
      fillColor: isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: cardBorder(isDark)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: cardBorder(isDark)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppPalette.primary, width: 1.5),
      ),
    );
  }
}
