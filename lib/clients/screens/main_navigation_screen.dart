import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_colors.dart';
import 'account_screen.dart';
import 'home_screen.dart';
import 'price_quotes_screen.dart';

import '../../theme/responsive_layout.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // Index 2 is "الرئيسية" (Home) in the center
  int _currentIndex = 2;
  int _pendingQuotesCount = 3;

  String _t(bool isArabic, String ar, String en) => isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;
    final isArabic = !settings.isEnglish;

    final List<Widget> pages = [
      _buildOrdersPage(isArabic, isDark),
      PriceQuotesScreen(
        onPendingCountChanged: (count) {
          setState(() {
            _pendingQuotesCount = count;
          });
        },
      ),
      const HomeScreen(),
      _buildMaintenancePage(isArabic, isDark),
      const AccountScreen(),
    ];

    return Directionality(
      textDirection: settings.direction,
      child: Scaffold(
        backgroundColor: background(isDark),
        appBar: AppBar(
          backgroundColor: AppPalette.primary,
          elevation: 0,
          centerTitle: false,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.directions_car_rounded,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 10),
              Text(
                'CarZone',
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          actions: [
            // Shopping Cart Icon with Badge
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined,
                      color: Colors.white, size: 24),
                  tooltip: _t(isArabic, 'سلة التسوق', 'Cart'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _t(isArabic, 'سلة التسوق تحوي 2 عناصر',
                              'Cart contains 2 items'),
                          style: GoogleFonts.cairo(),
                        ),
                        backgroundColor: AppPalette.primary,
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppPalette.accent,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '2',
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),

            // Notification Icon with Badge
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined,
                      color: Colors.white, size: 24),
                  tooltip: _t(isArabic, 'الإشعارات', 'Notifications'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _t(isArabic, 'لديك 3 إشعارات جديدة',
                              'You have 3 new notifications'),
                          style: GoogleFonts.cairo(),
                        ),
                        backgroundColor: AppPalette.primary,
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppPalette.danger,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '3',
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: ResponsiveCenter(
          maxWidth: 1000,
          child: IndexedStack(
            index: _currentIndex,
            children: pages,
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: _buildCustomBottomBar(isArabic, isDark, _pendingQuotesCount),
        ),
      ),
    );
  }

  /// Custom 5-Item Bottom Bar with Centered Home Button and Badges
  Widget _buildCustomBottomBar(
      bool isArabic, bool isDark, int pendingQuotesCount) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: cardBg(isDark),
        boxShadow: [
          BoxShadow(
            color: cardShadow(isDark),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(color: cardBorder(isDark), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 1. طلباتي (My Orders)
          _buildNavItem(
            index: 0,
            icon: Icons.assignment_outlined,
            activeIcon: Icons.assignment_rounded,
            label: _t(isArabic, 'طلباتي', 'Orders'),
            isDark: isDark,
          ),

          // 2. عروض الأسعار (Price Quotes) - With notification counter badge!
          _buildNavItem(
            index: 1,
            icon: Icons.request_quote_outlined,
            activeIcon: Icons.request_quote_rounded,
            label: _t(isArabic, 'عروض الأسعار', 'Price Quotes'),
            isDark: isDark,
            badgeCount: pendingQuotesCount,
          ),

          // 3. الرئيسية (Home) - CENTER BUTTON
          _buildCenterNavItem(
            index: 2,
            label: _t(isArabic, 'الرئيسية', 'Home'),
            isDark: isDark,
          ),

          // 4. خدمة الصيانة (Maintenance)
          _buildNavItem(
            index: 3,
            icon: Icons.build_circle_outlined,
            activeIcon: Icons.build_circle_rounded,
            label: _t(isArabic, 'الصيانة', 'Repair'),
            isDark: isDark,
          ),

          // 5. حسابي (Account)
          _buildNavItem(
            index: 4,
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            label: _t(isArabic, 'حسابي', 'Account'),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  /// Standard Nav Item with optional counter badge
  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isDark,
    int badgeCount = 0,
  }) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? AppPalette.primary : textSecondary(isDark);

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentIndex = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  color: color,
                  size: 24,
                ),
                if (badgeCount > 0)
                  Positioned(
                    top: -5,
                    right: -9,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppPalette.danger,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: cardBg(isDark), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppPalette.danger.withOpacity(0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$badgeCount',
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Center Featured Nav Item (الرئيسية)
  Widget _buildCenterNavItem({
    required int index,
    required String label,
    required bool isDark,
  }) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentIndex = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppPalette.primary, AppPalette.secondary],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.primary.withOpacity(isSelected ? 0.4 : 0.2),
                    blurRadius: isSelected ? 10 : 6,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.home_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? AppPalette.primary : textSecondary(isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. Dummy Orders Page (طلباتي)
  Widget _buildOrdersPage(bool isArabic, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _t(isArabic, 'طلباتي المنجزة والحالية', 'My Orders'),
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textPrimary(isDark),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final orders = [
                  {
                    'id': '#4812',
                    'title': _t(isArabic, 'طلب فحص وصيانة دورية', 'Full Service Order'),
                    'status': _t(isArabic, 'قيد التنفيذ', 'In Progress'),
                    'date': '2026-07-27',
                    'price': '150 \$'
                  },
                  {
                    'id': '#4790',
                    'title': _t(isArabic, 'شراء بطارية 70 أمبير', 'Battery Purchase'),
                    'status': _t(isArabic, 'تم التسليم', 'Completed'),
                    'date': '2026-07-20',
                    'price': '90 \$'
                  },
                  {
                    'id': '#4610',
                    'title': _t(isArabic, 'تغيير زيت المحرك', 'Engine Oil Change'),
                    'status': _t(isArabic, 'تم التسليم', 'Completed'),
                    'date': '2026-07-10',
                    'price': '45 \$'
                  },
                ];
                final item = orders[index];
                final isDone = item['status'] == _t(isArabic, 'تم التسليم', 'Completed');

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardBg(isDark),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cardBorder(isDark)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item['title']} (${item['id']})',
                            style: GoogleFonts.cairo(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: textPrimary(isDark),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${item['date']} • ${item['price']}',
                            style: GoogleFonts.cairo(
                              fontSize: 13,
                              color: textSecondary(isDark),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDone
                              ? AppPalette.success.withOpacity(0.15)
                              : AppPalette.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          item['status']!,
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDone ? AppPalette.success : AppPalette.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 4. Dummy Maintenance Page (خدمة الصيانة)
  Widget _buildMaintenancePage(bool isArabic, bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _t(isArabic, 'خدمة الصيانة والحجز الدوري', 'Maintenance Service'),
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textPrimary(isDark),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _t(isArabic, 'حجز موعد صيانة جديد', 'Book Maintenance Appointment'),
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textPrimary(isDark),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _t(isArabic, 'اختر نوع الصيانة المطلوبة لمركبتك',
                'Select maintenance type for your vehicle'),
            style: GoogleFonts.cairo(
              fontSize: 13,
              color: textSecondary(isDark),
            ),
          ),
          const SizedBox(height: 20),
          _buildServiceOption(
            icon: Icons.car_repair_rounded,
            title: _t(
                isArabic, 'صيانة دورية شاملة', 'Full Periodic Maintenance'),
            desc: _t(isArabic, 'تغيير فلاتر، فحص سوائل، وفحص المحرك',
                'Filters, fluids, & engine check'),
            isDark: isDark,
          ),
          _buildServiceOption(
            icon: Icons.electrical_services_rounded,
            title: _t(isArabic, 'صيانة الكهرباء والبرمجة',
                'Electrical & Diagnostics'),
            desc: _t(isArabic, 'فحص الكمبيوتر وحل أعطال الحساسات',
                'Computer diagnostic & sensors'),
            isDark: isDark,
          ),
          _buildServiceOption(
            icon: Icons.tire_repair_rounded,
            title: _t(isArabic, 'فحص الإطارات والفرامل',
                'Tires & Brakes Service'),
            desc: _t(isArabic, 'ميزان ذرعان، ترصيص، وتغيير قماشات',
                'Wheel alignment & brake pads'),
            isDark: isDark,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _t(isArabic, 'جاري تحضير نموذج الحجز...',
                          'Preparing booking form...'),
                      style: GoogleFonts.cairo(),
                    ),
                    backgroundColor: AppPalette.primary,
                  ),
                );
              },
              icon: const Icon(Icons.calendar_today_rounded, size: 20),
              label: Text(
                _t(isArabic, 'حجز موعد الآن', 'Book Now'),
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.primary,
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

  Widget _buildServiceOption({
    required IconData icon,
    required String title,
    required String desc,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg(isDark),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cardBorder(isDark)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppPalette.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppPalette.primary, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textPrimary(isDark),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
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
