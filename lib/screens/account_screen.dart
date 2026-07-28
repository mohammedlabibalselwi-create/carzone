import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../auth/unified_login_screen.dart';
import '../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import 'settings_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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
            // Page Header Title inside body
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

            // 1. User Header Profile Card
            _buildProfileHeaderCard(isArabic, isDark, settings),

            const SizedBox(height: 16),

            // 2. User Stats Summary Row
            _buildUserStatsRow(isArabic, isDark),

            const SizedBox(height: 24),

            // 3. Section: Account & Vehicles (الحساب والسيارات)
            _buildSectionHeader(
              title:
                  _t(isArabic, 'إدارة الحساب والمركبات', 'Account & Vehicles'),
              isDark: isDark,
            ),
            const SizedBox(height: 10),
            _buildMenuGroup(
              isDark: isDark,
              items: [
                _buildMenuItem(
                  icon: Icons.person_outline_rounded,
                  title: _t(
                      isArabic, 'تعديل البيانات الشخصية', 'Edit Profile Data'),
                  subtitle: _t(isArabic, 'الاسم، رقم الهاتف، والبريد',
                      'Name, phone & email'),
                  isDark: isDark,
                  onTap: () => _showSnackBar(
                      _t(isArabic, 'تعديل الملف الشخصي', 'Edit Profile')),
                ),
                _buildMenuItem(
                  icon: Icons.directions_car_filled_outlined,
                  title: _t(isArabic, 'مركباتي المسجلة (2)',
                      'My Registered Vehicles (2)'),
                  subtitle: _t(isArabic, 'تويوتا كامري، هيونداي تكسون',
                      'Toyota Camry, Hyundai Tucson'),
                  isDark: isDark,
                  onTap: () => _showSnackBar(
                      _t(isArabic, 'إدارة المركبات', 'Manage Vehicles')),
                ),
                _buildMenuItem(
                  icon: Icons.location_on_outlined,
                  title: _t(isArabic, 'العناوين المحفوظة', 'Saved Addresses'),
                  subtitle: _t(isArabic, 'المنزل، العمل، وموقع الصيانة',
                      'Home, Work & Garage'),
                  isDark: isDark,
                  onTap: () => _showSnackBar(
                      _t(isArabic, 'العناوين المحفوظة', 'Saved Addresses')),
                ),
                _buildMenuItem(
                  icon: Icons.payment_rounded,
                  title: _t(isArabic, 'طرق الدفع والبطاقات', 'Payment Methods'),
                  subtitle: _t(isArabic, 'بطاقات الماستركارد والمحفظة',
                      'Cards & Wallet'),
                  isDark: isDark,
                  showDivider: false,
                  onTap: () => _showSnackBar(
                      _t(isArabic, 'طرق الدفع', 'Payment Methods')),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 4. Section: Settings & Preferences (الإعدادات والتفضيلات)
            _buildSectionHeader(
              title: _t(
                  isArabic, 'الإعدادات والتفضيلات', 'Settings & Preferences'),
              isDark: isDark,
            ),
            const SizedBox(height: 10),
            _buildMenuGroup(
              isDark: isDark,
              items: [
                _buildMenuItem(
                  icon: Icons.settings_outlined,
                  title: _t(isArabic, 'إعدادات التطبيق', 'App Settings'),
                  subtitle: _t(
                    isArabic,
                    'المظهر (${isDark ? "داكن" : "فاتح"}) • اللغة (${settings.isEnglish ? "EN" : "العربية"}) • الإشعارات',
                    'Theme (${isDark ? "Dark" : "Light"}) • Language (${settings.isEnglish ? "EN" : "AR"}) • Notifications',
                  ),
                  isDark: isDark,
                  showDivider: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 5. Section: Support & Info (الدعم والمعلومات)
            _buildSectionHeader(
              title: _t(isArabic, 'الدعم والمعلومات', 'Support & Information'),
              isDark: isDark,
            ),
            const SizedBox(height: 10),
            _buildMenuGroup(
              isDark: isDark,
              items: [
                _buildMenuItem(
                  icon: Icons.help_outline_rounded,
                  title: _t(isArabic, 'مركز المساعدة والدعم الفني',
                      'Help & Support Center'),
                  subtitle: _t(isArabic, 'الأسئلة الشائعة والتواصل معنا',
                      'FAQ & Live Chat'),
                  isDark: isDark,
                  onTap: () => _showHelpSupportSheet(isArabic, isDark),
                ),
                _buildMenuItem(
                  icon: Icons.info_outline_rounded,
                  title: _t(isArabic, 'من نحن', 'About Us'),
                  subtitle: _t(isArabic, 'عن منصة CarZone للخدمات',
                      'About CarZone Platform'),
                  isDark: isDark,
                  onTap: () => _showAboutUsDialog(isArabic, isDark),
                ),
                _buildMenuItem(
                  icon: Icons.privacy_tip_outlined,
                  title: _t(isArabic, 'شروط الخدمة وسياسة الخصوصية',
                      'Terms & Privacy Policy'),
                  subtitle: _t(isArabic, 'حقوق الاستخدام والأمان',
                      'Terms of service & privacy'),
                  isDark: isDark,
                  onTap: () => _showTermsDialog(isArabic, isDark),
                ),
                _buildMenuItem(
                  icon: Icons.star_border_rounded,
                  title: _t(isArabic, 'تقييم التطبيق', 'Rate Our App'),
                  subtitle: _t(
                      isArabic, 'شاركونا رأيكم على المتجر', 'Rate us on Store'),
                  isDark: isDark,
                  showDivider: false,
                  onTap: () => _showSnackBar(_t(isArabic,
                      'شكراً لتقييمك التطبيق!', 'Thank you for rating!')),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 6. Section: Auth & Sign Out Button
            _buildAuthButton(isArabic, isDark, settings),

            const SizedBox(height: 16),

            // App Version Footer
            Text(
              _t(isArabic, 'إصدار التطبيق CarZone v1.2.0 (أحدث إصدار)',
                  'CarZone App Version v1.2.0'),
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: textSecondary(isDark),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Profile Card Container
  Widget _buildProfileHeaderCard(
      bool isArabic, bool isDark, SettingsProvider settings) {
    final isLoggedIn = settings.isLoggedIn;
    final displayName = isLoggedIn
        ? _t(isArabic, settings.userName, 'Yasser Al-Hakimi')
        : _t(isArabic, 'عميل كار زون', 'CarZone Guest');

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
            color: AppPalette.primary.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar with Edit Badge
              Stack(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Text(
                      isLoggedIn ? 'ي' : 'غ',
                      style: GoogleFonts.cairo(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (isLoggedIn)
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

              // User Name & Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          displayName,
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (isLoggedIn) ...[
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.verified_rounded,
                            color: AppPalette.accent,
                            size: 18,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isLoggedIn
                          ? 'yasser@carzone.com'
                          : _t(isArabic, 'زائر (غير مسجّل)',
                              'Visitor (Not Signed In)'),
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                    if (isLoggedIn)
                      Text(
                        '+967 770 000 000',
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

  /// User Stats Summary Cards
  Widget _buildUserStatsRow(bool isArabic, bool isDark) {
    return Row(
      children: [
        _buildStatCard(
          title: _t(isArabic, 'إجمالي الطلبات', 'Orders'),
          value: '12',
          icon: Icons.assignment_turned_in_rounded,
          isDark: isDark,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          title: _t(isArabic, 'المركبات', 'Vehicles'),
          value: '2',
          icon: Icons.directions_car_rounded,
          isDark: isDark,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          title: _t(isArabic, 'نقاط المكافآت', 'Points'),
          value: '350',
          icon: Icons.stars_rounded,
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
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  /// Section Header Title
  Widget _buildSectionHeader({required String title, required bool isDark}) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        title,
        style: GoogleFonts.cairo(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textPrimary(isDark),
        ),
      ),
    );
  }

  /// Rounded Menu Container Box
  Widget _buildMenuGroup({
    required bool isDark,
    required List<Widget> items,
  }) {
    return Container(
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
        children: items,
      ),
    );
  }

  /// Standard Menu Item ListTile
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
    String? trailingText,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppPalette.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppPalette.primary, size: 22),
          ),
          title: Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textPrimary(isDark),
            ),
          ),
          subtitle: Text(
            subtitle,
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: textSecondary(isDark),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailingText != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppPalette.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    trailingText,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppPalette.primary,
                    ),
                  ),
                ),
              const SizedBox(width: 6),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 15, color: AppPalette.primary),
            ],
          ),
          onTap: onTap,
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 64,
            endIndent: 16,
            color: cardBorder(isDark),
          ),
      ],
    );
  }

  /// Auth & Sign In / Out Button
  Widget _buildAuthButton(
      bool isArabic, bool isDark, SettingsProvider settings) {
    final isLoggedIn = settings.isLoggedIn;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {
          if (isLoggedIn) {
            settings.logout();
            _showSnackBar(_t(
                isArabic, 'تم تسجيل الخروج بنجاح', 'Signed out successfully'));
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UnifiedLoginScreen()),
            );
          }
        },
        icon: Icon(
          isLoggedIn ? Icons.logout_rounded : Icons.login_rounded,
          color: isLoggedIn ? AppPalette.danger : AppPalette.primary,
        ),
        label: Text(
          isLoggedIn
              ? _t(isArabic, 'تسجيل الخروج من الحساب', 'Sign Out')
              : _t(isArabic, 'تسجيل الدخول / إنشاء حساب', 'Sign In / Register'),
          style: GoogleFonts.cairo(
            fontSize: 14.5,
            fontWeight: FontWeight.bold,
            color: isLoggedIn ? AppPalette.danger : AppPalette.primary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isLoggedIn ? AppPalette.danger : AppPalette.primary,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  /// Dialog for "من نحن" (About Us)
  void _showAboutUsDialog(bool isArabic, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardBg(isDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.directions_car_rounded, color: AppPalette.primary),
            const SizedBox(width: 10),
            Text(
              _t(isArabic, 'من نحن - CarZone', 'About Us - CarZone'),
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textPrimary(isDark),
              ),
            ),
          ],
        ),
        content: Text(
          _t(
            isArabic,
            'منصة CarZone هي المنصة المتكاملة الأولى لخدمات السيارات وقطع الغيار والصيانة الشاملة. نهدف إلى تقديم أفضل تجربة للمستخدم في متابعة صيانة مركباته وحجز الخدمات بكل يسر وسهولة وأمان.',
            'CarZone is the premier all-in-one platform for automotive services, spare parts, and full maintenance. We aim to deliver the best user experience for managing vehicle maintenance easily and securely.',
          ),
          style: GoogleFonts.cairo(
            fontSize: 14,
            height: 1.6,
            color: textSecondary(isDark),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              _t(isArabic, 'إغلاق', 'Close'),
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                color: AppPalette.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Dialog for Terms & Privacy
  void _showTermsDialog(bool isArabic, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardBg(isDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          _t(isArabic, 'شروط الخدمة والخصوصية', 'Terms & Privacy'),
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: textPrimary(isDark),
          ),
        ),
        content: Text(
          _t(
            isArabic,
            'نلتزم بحماية خصوصية بياناتك وتوفير أقصى درجات الأمان المعوماتي. جميع البيانات الشخصية وبيانات السيارات مشفرة ولا يتم مشاركتها مع أي طرف ثالث دون موافقة مسبقة.',
            'We are committed to protecting your privacy and security. All personal and vehicle data are encrypted and never shared with third parties without prior consent.',
          ),
          style: GoogleFonts.cairo(
            fontSize: 13.5,
            height: 1.6,
            color: textSecondary(isDark),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              _t(isArabic, 'موافق', 'I Agree'),
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                color: AppPalette.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// BottomSheet for Help & Support Center
  void _showHelpSupportSheet(bool isArabic, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardBg(isDark),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _t(isArabic, 'مركز الدعم الفني والتواصل', 'Help & Live Support'),
              style: GoogleFonts.cairo(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: textPrimary(isDark),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _t(isArabic, 'فريق خدمة العملاء متواجد على مدار 24 ساعة لمساعدتك',
                  'Customer support available 24/7 to assist you'),
              style: GoogleFonts.cairo(
                fontSize: 13,
                color: textSecondary(isDark),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.phone_in_talk_rounded,
                  color: AppPalette.primary),
              title: Text(
                  _t(isArabic, 'الاتصال الهاتفي المباشر', 'Direct Call'),
                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              subtitle: Text('+967 800 000 00',
                  style: GoogleFonts.cairo(fontSize: 12)),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline_rounded,
                  color: AppPalette.accent),
              title: Text(
                  _t(isArabic, 'المحادثة الفورية (WhatsApp)',
                      'WhatsApp Support'),
                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              subtitle: Text(
                  _t(isArabic, 'رد فوري خلال دقائق', 'Instant response'),
                  style: GoogleFonts.cairo(fontSize: 12)),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: GoogleFonts.cairo()),
        backgroundColor: AppPalette.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
