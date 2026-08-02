import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_colors.dart';

import '../theme/responsive_layout.dart';

class CreateCustomPartRequestScreen extends StatefulWidget {
  const CreateCustomPartRequestScreen({super.key});

  @override
  State<CreateCustomPartRequestScreen> createState() =>
      _CreateCustomPartRequestScreenState();
}

class _CreateCustomPartRequestScreenState
    extends State<CreateCustomPartRequestScreen> {
  int _selectedTab = 0; // 0: Form Request, 1: Brand & TecAlliance Catalog

  // Form Controllers
  final _formKey = GlobalKey<FormState>();
  final _brandModelController = TextEditingController();
  final _yearController = TextEditingController();
  final _vinController = TextEditingController();
  final _partNameController = TextEditingController();
  final _notesController = TextEditingController();
  bool _hasUploadedImage = false;

  // Catalog Flow State
  String? _selectedBrand;
  String? _selectedModel;

  String _t(bool isArabic, String ar, String en) => isArabic ? ar : en;

  @override
  void dispose() {
    _brandModelController.dispose();
    _yearController.dispose();
    _vinController.dispose();
    _partNameController.dispose();
    _partNameController.dispose();
    _notesController.dispose();
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
            _t(isArabic, 'إنشاء طلب قطعة مخصصة', 'Create Custom Part Request'),
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: ResponsiveCenter(
          maxWidth: 850,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner
                _buildHeaderInfoCard(isArabic, isDark),

                const SizedBox(height: 20),

                // Tab Selector: Form vs Catalog
                _buildTabSelector(isArabic, isDark),

                const SizedBox(height: 20),

                // Tab Content View
                _selectedTab == 0
                    ? _buildFormRequestSection(isArabic, isDark)
                    : _buildCatalogFlowSection(isArabic, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Top Info Banner
  Widget _buildHeaderInfoCard(bool isArabic, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppPalette.primary, AppPalette.secondary],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppPalette.primary.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.precision_manufacturing_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _t(isArabic, 'خدمة التزويد بالقطع المخصصة',
                      'Custom Part Sourcing Service'),
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _t(
                    isArabic,
                    'يمكنك طلب أي قطعة صعبة التوفر عبر نموذج البيانات أو اختيار الماركة والموديل مباشرة',
                    'Request hard-to-find parts via custom form or by selecting car brand & model catalog',
                  ),
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: Colors.white70,
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

  /// Option Toggle Buttons
  Widget _buildTabSelector(bool isArabic, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cardBg(isDark),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder(isDark)),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _selectedTab = 0),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTab == 0
                      ? AppPalette.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit_note_rounded,
                      size: 20,
                      color: _selectedTab == 0
                          ? Colors.white
                          : textSecondary(isDark),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _t(isArabic, 'تعبئة نموذج طلب', 'Form Request'),
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _selectedTab == 0
                            ? Colors.white
                            : textSecondary(isDark),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _selectedTab = 1),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTab == 1
                      ? AppPalette.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions_car_filled_rounded,
                      size: 20,
                      color: _selectedTab == 1
                          ? Colors.white
                          : textSecondary(isDark),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _t(isArabic, 'كتالوج الماركات', 'Brand Catalog'),
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: _selectedTab == 1
                            ? Colors.white
                            : textSecondary(isDark),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // OPTION 1: FORM-BASED REQUEST
  // ==========================================
  Widget _buildFormRequestSection(bool isArabic, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg(isDark),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorder(isDark)),
        boxShadow: [
          BoxShadow(
            color: cardShadow(isDark),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _t(isArabic, 'تفاصيل المركبة والقطعة المطلوبة',
                  'Vehicle & Part Specifications'),
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textPrimary(isDark),
              ),
            ),
            const SizedBox(height: 16),

            // Car Brand & Model Field
            _buildInputField(
              controller: _brandModelController,
              label: _t(isArabic, 'ماركة وموديل السيارة', 'Brand & Model'),
              hint: 'مثال: تويوتا كامري / Toyota Camry',
              icon: Icons.car_repair_rounded,
              isDark: isDark,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? _t(isArabic, 'يرجى إدخال الماركة والموديل', 'Required')
                  : null,
            ),
            const SizedBox(height: 14),

            // Year & VIN Number Row
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    controller: _yearController,
                    label: _t(isArabic, 'سنة الصنع', 'Year'),
                    hint: '2024',
                    icon: Icons.calendar_today_rounded,
                    keyboardType: TextInputType.number,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInputField(
                    controller: _vinController,
                    label: _t(isArabic, 'رقم الشاصي (اختياري)', 'VIN (Optional)'),
                    hint: '17-digit VIN',
                    icon: Icons.numbers_rounded,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Part Name Field
            _buildInputField(
              controller: _partNameController,
              label: _t(isArabic, 'اسم القطعة أو رقمها الأصلي',
                  'Part Name or OEM Part Number'),
              hint: 'مثال: مساعدات أمامية / Brake pads',
              icon: Icons.build_circle_outlined,
              isDark: isDark,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? _t(isArabic, 'يرجى كتابة اسم القطعة المطلوبة', 'Required')
                  : null,
            ),
            const SizedBox(height: 14),

            // Image Upload Placeholder
            Text(
              _t(isArabic, 'إرفاق صورة للقطعة (اختياري)', 'Attach Part Photo (Optional)'),
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: textPrimary(isDark),
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                setState(() {
                  _hasUploadedImage = !_hasUploadedImage;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _hasUploadedImage
                          ? _t(isArabic, 'تم إرفاق صورة القطعة بنجاح',
                              'Part photo attached')
                          : _t(isArabic, 'تم إلغاء إرفاق الصورة',
                              'Photo removed'),
                      style: GoogleFonts.cairo(),
                    ),
                    backgroundColor: AppPalette.primary,
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppPalette.primary.withOpacity(0.12)
                      : const Color(0xFFF0F5FA),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _hasUploadedImage
                        ? AppPalette.success
                        : AppPalette.primary.withOpacity(0.3),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _hasUploadedImage
                          ? Icons.check_circle_rounded
                          : Icons.add_a_photo_outlined,
                      size: 32,
                      color: _hasUploadedImage
                          ? AppPalette.success
                          : AppPalette.primary,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _hasUploadedImage
                          ? _t(isArabic, 'تم إرفاق الصورة (انقر للتغيير)',
                              'Photo attached (click to change)')
                          : _t(isArabic, 'اضغط هنا لرفع صورة القطعة القديمة',
                              'Click to upload photo of old part'),
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _hasUploadedImage
                            ? AppPalette.success
                            : AppPalette.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Additional Notes Field
            _buildInputField(
              controller: _notesController,
              label: _t(isArabic, 'ملاحظات إضافية', 'Additional Notes'),
              hint: _t(isArabic, 'أي مواصفات خاصة للقطعة...', 'Any extra details...'),
              icon: Icons.notes_rounded,
              maxLines: 3,
              isDark: isDark,
            ),
            const SizedBox(height: 22),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _showSuccessDialog(isArabic, isDark);
                  }
                },
                icon: const Icon(Icons.send_rounded, size: 20),
                label: Text(
                  _t(isArabic, 'إرسال طلب القطعة المخصصة',
                      'Submit Custom Part Request'),
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // OPTION 2: BRAND & MODEL CATALOG (TECALLIANCE FLOW)
  // ==========================================
  Widget _buildCatalogFlowSection(bool isArabic, bool isDark) {
    // 1. If no brand selected -> Show Brands Grid
    if (_selectedBrand == null) {
      return _buildBrandsGridSection(isArabic, isDark);
    }

    // 2. If brand selected but no model -> Show Models List for Brand
    if (_selectedModel == null) {
      return _buildModelsListSection(isArabic, isDark);
    }

    // 3. If model selected -> Show TecAlliance Parts & Graphics Placeholder Flow
    return _buildTecAlliancePartsCatalog(isArabic, isDark);
  }

  /// Brands Grid View
  Widget _buildBrandsGridSection(bool isArabic, bool isDark) {
    final brands = [
      {'name': 'تويوتا (Toyota)', 'logo': '🚗', 'count': '42 موديل'},
      {'name': 'هيونداي (Hyundai)', 'logo': '🚘', 'count': '35 موديل'},
      {'name': 'مرسيدس (Mercedes)', 'logo': '🏎️', 'count': '28 موديل'},
      {'name': 'بي إم دبليو (BMW)', 'logo': '🚙', 'count': '30 موديل'},
      {'name': 'نيسان (Nissan)', 'logo': '🚐', 'count': '26 موديل'},
      {'name': 'لكزس (Lexus)', 'logo': '🚘', 'count': '18 موديل'},
      {'name': 'كيا (Kia)', 'logo': '🚗', 'count': '22 موديل'},
      {'name': 'فورد (Ford)', 'logo': '🛻', 'count': '20 موديل'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _t(isArabic, 'اختر ماركة السيارة', 'Select Car Brand'),
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textPrimary(isDark),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppPalette.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _t(isArabic, 'TecAlliance Catalog', 'TecAlliance Catalog'),
                style: GoogleFonts.cairo(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppPalette.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: brands.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final b = brands[index];
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedBrand = b['name'];
                });
              },
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cardBg(isDark),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: cardBorder(isDark)),
                  boxShadow: [
                    BoxShadow(
                      color: cardShadow(isDark),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(b['logo']!, style: const TextStyle(fontSize: 32)),
                    const SizedBox(height: 6),
                    Text(
                      b['name']!,
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: textPrimary(isDark),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      b['count']!,
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        color: textSecondary(isDark),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Models List View for Selected Brand
  Widget _buildModelsListSection(bool isArabic, bool isDark) {
    final models = [
      {'name': 'كامري (Camry)', 'years': '2015 - 2025'},
      {'name': 'كورولا (Corolla)', 'years': '2012 - 2025'},
      {'name': 'لاند كروزر (Land Cruiser)', 'years': '2010 - 2025'},
      {'name': 'هايلوكس (Hilux)', 'years': '2014 - 2025'},
      {'name': 'يارس (Yaris)', 'years': '2016 - 2025'},
      {'name': 'فورتشنر (Fortuner)', 'years': '2015 - 2025'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Navigation Breadcrumb / Back to Brands
        InkWell(
          onTap: () => setState(() => _selectedBrand = null),
          child: Row(
            children: [
              const Icon(Icons.arrow_back_ios_rounded,
                  size: 16, color: AppPalette.primary),
              const SizedBox(width: 4),
              Text(
                _t(isArabic, 'الرجوع للماركات', 'Back to Brands'),
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppPalette.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        Text(
          _t(isArabic, 'اختر موديل $_selectedBrand', 'Select Model for $_selectedBrand'),
          style: GoogleFonts.cairo(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: textPrimary(isDark),
          ),
        ),
        const SizedBox(height: 14),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: models.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final m = models[index];
            return Container(
              decoration: BoxDecoration(
                color: cardBg(isDark),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cardBorder(isDark)),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppPalette.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.directions_car_rounded,
                      color: AppPalette.primary, size: 22),
                ),
                title: Text(
                  m['name']!,
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textPrimary(isDark),
                  ),
                ),
                subtitle: Text(
                  _t(isArabic, 'سنوات الصنع: ${m['years']}', 'Years: ${m['years']}'),
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: textSecondary(isDark),
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: AppPalette.primary),
                onTap: () {
                  setState(() {
                    _selectedModel = m['name'];
                  });
                },
              ),
            );
          },
        ),
      ],
    );
  }

  /// TecAlliance Diagrams & Parts Interactive Flow Placeholder
  Widget _buildTecAlliancePartsCatalog(bool isArabic, bool isDark) {
    final categories = [
      {'name': _t(isArabic, 'نظام المحرك والمكينة', 'Engine System'), 'icon': Icons.settings_suggest_rounded},
      {'name': _t(isArabic, 'نظام الفرامل والقماشات', 'Brake System'), 'icon': Icons.minor_crash_rounded},
      {'name': _t(isArabic, 'المساعدات ونظام التعليق', 'Suspension & Shock'), 'icon': Icons.build_circle_rounded},
      {'name': _t(isArabic, 'نظام الكهرباء والحساسات', 'Electrical & Sensors'), 'icon': Icons.bolt_rounded},
      {'name': _t(isArabic, 'قطع الهيكل والأبواب', 'Body & Doors'), 'icon': Icons.sensor_door_rounded},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Navigation Breadcrumb / Back to Models
        InkWell(
          onTap: () => setState(() => _selectedModel = null),
          child: Row(
            children: [
              const Icon(Icons.arrow_back_ios_rounded,
                  size: 16, color: AppPalette.primary),
              const SizedBox(width: 4),
              Text(
                _t(isArabic, 'الرجوع لموديلات $_selectedBrand', 'Back to Models'),
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppPalette.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Selected Car Model Info Badge
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppPalette.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppPalette.primary.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.verified_rounded, color: AppPalette.primary, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '$_selectedBrand • $_selectedModel',
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

        const SizedBox(height: 18),

        // TecAlliance API Integration Notice Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg(isDark),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppPalette.accent.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded, color: AppPalette.accent, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    _t(isArabic, 'رسومات وتفجيرات السيارات (TecAlliance API)', 'TecAlliance Diagrams Ready'),
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textPrimary(isDark),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                _t(
                  isArabic,
                  'سيتم جلب كافة الرسومات التفصيلية (Exploded Diagrams) فور ربط الاشتراك مع موقع TecAlliance لتتمكن من اختيار القطعة المخصصة بدقة 100%.',
                  'Exploded diagrams & exact part numbers will load automatically upon TecAlliance API subscription integration.',
                ),
                style: GoogleFonts.cairo(
                  fontSize: 12.5,
                  color: textSecondary(isDark),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        Text(
          _t(isArabic, 'أقسام رسومات وقطع السيارة', 'Diagram Categories'),
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textPrimary(isDark),
          ),
        ),
        const SizedBox(height: 10),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final c = categories[index];
            return Container(
              decoration: BoxDecoration(
                color: cardBg(isDark),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cardBorder(isDark)),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppPalette.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(c['icon'] as IconData,
                      color: AppPalette.primary, size: 22),
                ),
                title: Text(
                  c['name'] as String,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textPrimary(isDark),
                  ),
                ),
                subtitle: Text(
                  _t(isArabic, 'عرض الرسومات التوضيحية للقطعة', 'View exploded diagrams'),
                  style: GoogleFonts.cairo(fontSize: 12, color: textSecondary(isDark)),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPalette.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _t(isArabic, 'تم فتح رسم ${c['name']}',
                              'Opened diagram for ${c['name']}'),
                          style: GoogleFonts.cairo(),
                        ),
                        backgroundColor: AppPalette.primary,
                      ),
                    );
                  },
                  child: Text(
                    _t(isArabic, 'عرض الرسم', 'View Diagram'),
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Helper Input Field Builder
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDark,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: textPrimary(isDark),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.cairo(fontSize: 14, color: textPrimary(isDark)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.cairo(fontSize: 13, color: textSecondary(isDark)),
            prefixIcon: Icon(icon, color: AppPalette.primary),
            filled: true,
            fillColor: isDark
                ? AppPalette.darkBackground.withOpacity(0.5)
                : const Color(0xFFF8FAFC),
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
          ),
        ),
      ],
    );
  }

  /// Success Dialog on Form Submission
  void _showSuccessDialog(bool isArabic, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardBg(isDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppPalette.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, size: 36, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              _t(isArabic, 'تم إرسال الطلب بنجاح!', 'Request Sent Successfully!'),
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: textPrimary(isDark),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Text(
          _t(
            isArabic,
            'تم استلام طلبك الخاص بالقطعة المخصصة وسيقوم فريق CarZone بمراجعة المواصفات والرد عليك بالأسعار وتفاصيل التوفر في أقرب وقت.',
            'Your custom part request has been received. Our CarZone team will review the specs and get back to you with pricing & availability soon.',
          ),
          style: GoogleFonts.cairo(
            fontSize: 13.5,
            height: 1.5,
            color: textSecondary(isDark),
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: Text(
                _t(isArabic, 'حسناً، العودة للرئيسية', 'OK, Return Home'),
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
