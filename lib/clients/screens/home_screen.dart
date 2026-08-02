import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../auth/unified_login_screen.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/responsive_layout.dart';
import 'create_custom_part_request_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _t(bool isArabic, String ar, String en) => isArabic ? ar : en;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;
    final isArabic = !settings.isEnglish;

    return Container(
      color: background(isDark),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              // 1. Welcome Card
              _buildWelcomeCard(isArabic, isDark, settings),

              const SizedBox(height: 20),

            // 2. VIN & Part Number Search Bar (البحث برقم الشاصي أو رقم القطعة)
            _buildVinOrPartSearchBar(isArabic, isDark),

            const SizedBox(height: 20),

            // 3. Create Custom Part Request Button (زر إنشاء طلب قطعة مخصصة)
            _buildCustomPartRequestHeroCard(isArabic, isDark),

            const SizedBox(height: 28),

            // 4. Featured Offers Section (العروض والخدمات المميزة)
            _buildSectionHeader(
              title: _t(isArabic, 'العروض والخدمات المميزة',
                  'Featured Services & Offers'),
              actionText: _t(isArabic, 'عرض الكل', 'View All'),
              isArabic: isArabic,
              isDark: isDark,
              onTap: () {},
            ),
            const SizedBox(height: 14),
            _buildFeaturedOffersList(isArabic, isDark),

            const SizedBox(height: 28),

            // 5. Quick Services Banner / Active Order
            _buildActiveOrderStatusCard(isArabic, isDark),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Welcome Card matching guest vs logged-in user UI state
  Widget _buildWelcomeCard(
      bool isArabic, bool isDark, SettingsProvider settings) {
    final isLoggedIn = settings.isLoggedIn;
    final customerName = isLoggedIn
        ? _t(isArabic, settings.userName, 'Yasser Al-Selwi')
        : _t(isArabic, 'عميل كار زون', 'CarZone Customer');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppPalette.primary,
            Color(0xFF144A75),
            AppPalette.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppPalette.primary.withOpacity(0.3),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background subtle circular decoration
          Positioned(
            left: isArabic ? -20 : null,
            right: isArabic ? null : -20,
            top: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text Greeting & Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _t(isArabic, 'مرحباً بك', 'Welcome'),
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.85),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          customerName,
                          style: GoogleFonts.cairo(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Shield / Security Icon Container (Top Corner Badge)
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Bottom Badge Row: Logged In ("حسابك موثّق وآمن") vs Visitor Guest ("سجّل دخولك الآن لتسهيل وتسريع خدماتك")
              if (isLoggedIn)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 13,
                              color: AppPalette.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _t(isArabic, 'حسابك موثّق وآمن',
                                'Your account is verified & secure'),
                            style: GoogleFonts.cairo(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              else
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UnifiedLoginScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.login_rounded,
                            size: 13,
                            color: AppPalette.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            _t(
                              isArabic,
                              'سجّل دخولك الآن لتسهيل وتسريع خدماتك',
                              'Sign in to access & speed up services',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// VIN / Part Number Search Bar (بحث برقم الشاصي أو رقم القطعة)
  Widget _buildVinOrPartSearchBar(bool isArabic, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppPalette.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.search_rounded,
                  color: AppPalette.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _t(isArabic, 'البحث السريع في CarZone', 'Quick Parts Search'),
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textPrimary(isDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _searchController,
            style: GoogleFonts.cairo(fontSize: 14, color: textPrimary(isDark)),
            decoration: InputDecoration(
              hintText: _t(
                isArabic,
                'أدخل رقم الشاصي (VIN) أو رقم القطعة الأصلي...',
                'Enter VIN Number or OEM Part Number...',
              ),
              hintStyle: GoogleFonts.cairo(
                fontSize: 12.5,
                color: textSecondary(isDark),
              ),
              prefixIcon: const Icon(
                Icons.directions_car_filled_outlined,
                color: AppPalette.primary,
              ),
              suffixIcon: InkWell(
                onTap: () {
                  final query = _searchController.text.trim();
                  if (query.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _t(isArabic, 'جاري البحث عن: $query',
                              'Searching for: $query'),
                          style: GoogleFonts.cairo(),
                        ),
                        backgroundColor: AppPalette.primary,
                      ),
                    );
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppPalette.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _t(isArabic, 'بحث', 'Search'),
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              filled: true,
              fillColor: isDark
                  ? AppPalette.darkBackground.withOpacity(0.5)
                  : const Color(0xFFF8FAFC),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
                borderSide:
                    const BorderSide(color: AppPalette.primary, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Create Custom Part Request Hero Card/Button
  Widget _buildCustomPartRequestHeroCard(bool isArabic, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E293B), AppPalette.primary]
              : [const Color(0xFFEFF6FF), const Color(0xFFDBEAFE)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppPalette.primary.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: cardShadow(isDark),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppPalette.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.build_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _t(isArabic, 'إنشاء طلب قطعة مخصصة',
                          'Create Custom Part Request'),
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textPrimary(isDark),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _t(
                        isArabic,
                        'أرسل مواصفات أي قطعة عبر النموذج أو تصفح ماركات السيارات (TecAlliance Catalog)',
                        'Request custom parts via form or explore car brand diagrams',
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
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateCustomPartRequestScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
              label: Text(
                _t(isArabic, 'طلب قطعة مخصصة الآن', 'Request Custom Part Now'),
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Header with clickable link
  Widget _buildSectionHeader({
    required String title,
    required String actionText,
    required bool isArabic,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textPrimary(isDark),
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            actionText,
            style: GoogleFonts.cairo(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppPalette.primary,
            ),
          ),
        ),
      ],
    );
  }

  /// Featured Offers Horizontal ListView with mock products/services
  Widget _buildFeaturedOffersList(bool isArabic, bool isDark) {
    final offers = [
      {
        'title': _t(isArabic, 'فحص شامل للسيارة', 'Full Car Inspection'),
        'subtitle':
            _t(isArabic, 'فحص 50 نقطة ميكانيكية', '50 Mechanical points check'),
        'price': '150 \$',
        'rating': '4.9',
        'icon': Icons.car_repair,
        'tag': _t(isArabic, 'الأكثر طلباً', 'Popular'),
      },
      {
        'title': _t(isArabic, 'تغيير زيت المحرك الأصلي', 'Engine Oil Change'),
        'subtitle':
            _t(isArabic, 'زيت كاسترول 10,000 كم', 'Castrol Oil 10,000 km'),
        'price': '45 \$',
        'rating': '4.8',
        'icon': Icons.oil_barrel_rounded,
        'tag': _t(isArabic, 'خصم 20%', '20% OFF'),
      },
      {
        'title': _t(isArabic, 'بطارية هانكوك 70 أمبير', 'Hankook Battery 70A'),
        'subtitle': _t(isArabic, 'مع الضمان لمدة سنة كاملة', '1 Year Warranty'),
        'price': '90 \$',
        'rating': '5.0',
        'icon': Icons.battery_charging_full_rounded,
        'tag': _t(isArabic, 'ضمان سنة', 'Warranty'),
      },
    ];

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: offers.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final offer = offers[index];
          return Container(
            width: 260,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardBg(isDark),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: cardBorder(isDark)),
              boxShadow: [
                BoxShadow(
                  color: cardShadow(isDark),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppPalette.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        offer['icon'] as IconData,
                        color: AppPalette.primary,
                        size: 24,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppPalette.accent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        offer['tag'] as String,
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppPalette.accent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  offer['title'] as String,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textPrimary(isDark),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  offer['subtitle'] as String,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: textSecondary(isDark),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      offer['price'] as String,
                      style: GoogleFonts.cairo(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppPalette.primary,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Colors.amber, size: 16),
                        const SizedBox(width: 2),
                        Text(
                          offer['rating'] as String,
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: textPrimary(isDark),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Active Order Status Card Widget
  Widget _buildActiveOrderStatusCard(bool isArabic, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg(isDark),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorder(isDark)),
        boxShadow: [
          BoxShadow(
            color: cardShadow(isDark),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppPalette.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.build_circle_outlined,
              color: AppPalette.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _t(isArabic, 'حالة طلب الصيانة الحالي',
                      'Current Repair Status'),
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textPrimary(isDark),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _t(isArabic, 'طلب #4812 - قيد التنفيذ في المركز',
                      'Order #4812 - In Progress at Center'),
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: textSecondary(isDark),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded,
              size: 16, color: AppPalette.primary),
        ],
      ),
    );
  }
}
