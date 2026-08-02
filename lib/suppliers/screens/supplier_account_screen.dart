import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_colors.dart';
import '../../auth/unified_login_screen.dart';
import 'seller_verification_screen.dart';

class SupplierAccountScreen extends StatefulWidget {
  const SupplierAccountScreen({super.key});

  @override
  State<SupplierAccountScreen> createState() => _SupplierAccountScreenState();
}

class _SupplierAccountScreenState extends State<SupplierAccountScreen> {
  String _t(bool isArabic, String ar, String en) => isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;
    final isArabic = !settings.isEnglish;

    return Scaffold(
      backgroundColor: background(isDark),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(
                _t(isArabic, 'الملف الشخصي والحساب', 'My Profile & Account'),
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textPrimary(isDark),
                ),
              ),
            ),
            _buildProfileHeaderCard(isArabic, isDark, settings),
            const SizedBox(height: 16),
            _buildUserStatsRow(isArabic, isDark),
            const SizedBox(height: 24),
            _buildSectionHeader(
              title: _t(isArabic, 'إدارة المحفظة المالية', 'Wallet Management'),
              isDark: isDark,
            ),
            const SizedBox(height: 10),
            _buildWalletCard(isArabic, isDark),
            const SizedBox(height: 24),
            _buildSectionHeader(
              title: _t(
                  isArabic, 'الإعدادات والتفضيلات', 'Settings & Preferences'),
              isDark: isDark,
            ),
            _buildMenuGroup(
              isDark: isDark,
              items: [
                _buildMenuItem(
                  icon: Icons.verified_user_outlined,
                  title: _t(isArabic, 'توثيق حساب البائع التجاري',
                      'Seller Verification'),
                  subtitle: _t(
                      isArabic,
                      'إدخال السجل التجاري والبيانات البنكية',
                      'CR & Settlement Details'),
                  isDark: isDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SellerVerificationScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.notifications_outlined,
                  title: _t(isArabic, 'إشعارات التطبيق', 'App Notifications'),
                  subtitle: _t(isArabic, 'تفعيل أو تعطيل التنبيهات',
                      'Enable or disable alerts'),
                  isDark: isDark,
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.lock_outline_rounded,
                  title: _t(isArabic, 'تغيير كلمة المرور', 'Change Password'),
                  subtitle:
                      _t(isArabic, 'تحديث بيانات الدخول', 'Update login info'),
                  isDark: isDark,
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.settings_outlined,
                  title: _t(isArabic, 'تفضيلات الحساب', 'Account Preferences'),
                  subtitle: _t(isArabic, 'المظهر واللغة', 'Theme & Language'),
                  isDark: isDark,
                  showDivider: false,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (c) => const UnifiedLoginScreen()));
                },
                icon: const Icon(Icons.logout_rounded,
                    color: AppPalette.danger, size: 20),
                label: Text(
                  _t(isArabic, 'تسجيل الخروج', 'Sign Out'),
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppPalette.danger,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppPalette.danger, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeaderCard(
      bool isArabic, bool isDark, SettingsProvider settings) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppPalette.primary, AppPalette.secondary],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppPalette.primary.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: Text(
                      'م',
                      style: GoogleFonts.cairo(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppPalette.accent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        size: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _t(isArabic, 'مؤسسة الخالد لقطع الغيار',
                                'Al-Khaled Auto Parts'),
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.verified_rounded,
                          color: AppPalette.accent,
                          size: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _t(isArabic, 'مورد موثق (الرياض)',
                          'Verified Supplier (Riyadh)'),
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      '+966 501 234 567',
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserStatsRow(bool isArabic, bool isDark) {
    return Row(
      children: [
        _buildStatCard(
          title: _t(isArabic, 'إجمالي الطلبات', 'Total Orders'),
          value: '45',
          icon: Icons.assignment_turned_in_rounded,
          isDark: isDark,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          title: _t(isArabic, 'قيد التجهيز', 'Pending'),
          value: '3',
          icon: Icons.timer_rounded,
          isDark: isDark,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          title: _t(isArabic, 'التقييم', 'Rating'),
          value: '4.8',
          icon: Icons.star_rounded,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
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
          children: [
            Icon(icon, color: AppPalette.primary, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.cairo(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: textPrimary(isDark),
              ),
            ),
            Text(
              title,
              style: GoogleFonts.cairo(
                fontSize: 11,
                color: textSecondary(isDark),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required bool isDark}) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppPalette.accent,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: textPrimary(isDark),
          ),
        ),
      ],
    );
  }

  Widget _buildWalletCard(bool isArabic, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg(isDark),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cardBorder(isDark)),
        boxShadow: [
          BoxShadow(
            color: cardShadow(isDark),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppPalette.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.account_balance_wallet_rounded,
                    color: AppPalette.primary),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _t(isArabic, 'الرصيد المتاح', 'Available Balance'),
                    style: GoogleFonts.cairo(
                        color: textSecondary(isDark), fontSize: 13),
                  ),
                  Text(
                    '12,450 ر.س',
                    style: GoogleFonts.cairo(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppPalette.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.money_rounded, size: 20),
              label: Text(
                _t(isArabic, 'سحب الأرباح', 'Withdraw'),
                style: GoogleFonts.cairo(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGroup({required bool isDark, required List<Widget> items}) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg(isDark),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorder(isDark)),
        boxShadow: [
          BoxShadow(
            color: cardShadow(isDark),
            blurRadius: 12,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: items,
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppPalette.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppPalette.primary, size: 22),
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
                      Text(
                        subtitle,
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: textSecondary(isDark),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: textSecondary(isDark).withValues(alpha: 0.5),
                  size: 14,
                ),
              ],
            ),
          ),
          if (showDivider)
            Padding(
              padding: const EdgeInsets.only(left: 60, right: 16),
              child: Divider(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
              ),
            ),
        ],
      ),
    );
  }
}
