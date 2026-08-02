import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_colors.dart';
import 'supplier_new_orders_screen.dart';
import 'supplier_my_offers_screen.dart';
import 'supplier_home_screen.dart';
import 'supplier_statistics_screen.dart';
import 'supplier_account_screen.dart';

class SupplierMainNavigationScreen extends StatefulWidget {
  const SupplierMainNavigationScreen({super.key});

  @override
  State<SupplierMainNavigationScreen> createState() => _SupplierMainNavigationScreenState();
}

class _SupplierMainNavigationScreenState extends State<SupplierMainNavigationScreen> {
  int _currentIndex = 2; // Center FAB (الرئيسية)

  String _t(bool isArabic, String ar, String en) => isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;
    final isArabic = !settings.isEnglish;

    final List<Widget> pages = const [
      SupplierNewOrdersScreen(),
      SupplierMyOffersScreen(),
      SupplierHomeScreen(),
      SupplierStatisticsScreen(),
      SupplierAccountScreen(),
    ];

    return Directionality(
      textDirection: settings.direction,
      child: Scaffold(
        backgroundColor: background(isDark),
        appBar: AppBar(
          backgroundColor: AppPalette.primary,
          elevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
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
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined,
                      color: Colors.white, size: 24),
                  onPressed: () {},
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
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '5',
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
        body: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
        bottomNavigationBar: _buildCustomBottomBar(isArabic, isDark),
      ),
    );
  }

  Widget _buildCustomBottomBar(bool isArabic, bool isDark) {
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
        border: Border(top: BorderSide(color: cardBorder(isDark), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            index: 0,
            icon: Icons.assignment_outlined,
            activeIcon: Icons.assignment_rounded,
            label: _t(isArabic, 'الطلبات', 'Requests'),
            isDark: isDark,
          ),
          _buildNavItem(
            index: 1,
            icon: Icons.local_offer_outlined,
            activeIcon: Icons.local_offer_rounded,
            label: _t(isArabic, 'عروضي', 'My Offers'),
            isDark: isDark,
          ),
          _buildCenterNavItem(
            index: 2,
            label: _t(isArabic, 'الرئيسية', 'Home'),
            isDark: isDark,
          ),
          _buildNavItem(
            index: 3,
            icon: Icons.bar_chart_outlined,
            activeIcon: Icons.bar_chart_rounded,
            label: _t(isArabic, 'الإحصائيات', 'Statistics'),
            isDark: isDark,
          ),
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

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isDark,
  }) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? AppPalette.primary : textSecondary(isDark);

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentIndex = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSelected ? activeIcon : icon, color: color, size: 24),
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
                    color: AppPalette.primary.withValues(alpha: isSelected ? 0.4 : 0.2),
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
}
