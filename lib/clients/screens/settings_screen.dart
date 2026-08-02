import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_colors.dart';

import '../theme/responsive_layout.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _maintenanceNotifs = true;
  bool _offersNotifs = true;
  bool _orderNotifs = true;
  bool _biometricsEnabled = false;

  String _t(bool isArabic, String ar, String en) => isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;
    final isArabic = !settings.isEnglish;

    return Scaffold(
      backgroundColor: background(isDark),
      appBar: AppBar(
        title: Text(
          _t(isArabic, 'الإعدادات العامة', 'App Settings'),
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppPalette.primary,
        elevation: 0,
        centerTitle: true,
      ),
      body: ResponsiveCenter(
        maxWidth: 850,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Theme & Appearance Section
              _buildSectionHeader(
                title: _t(isArabic, 'المظهر والنمط', 'Theme & Appearance'),
                icon: Icons.palette_outlined,
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              _buildMenuGroup(
                isDark: isDark,
                children: [
                  _buildThemeSelectorTile(
                    title: _t(isArabic, 'الوضع النهاري (فاتح)', 'Light Theme'),
                    subtitle: _t(isArabic, 'ألوان فاتحة ومريحة للعين في النهار',
                        'Comfortable light appearance'),
                    icon: Icons.wb_sunny_rounded,
                    isSelected: !isDark,
                    isDark: isDark,
                    onTap: () => settings.setDarkMode(false),
                  ),
                  Divider(height: 1, indent: 60, color: cardBorder(isDark)),
                  _buildThemeSelectorTile(
                    title: _t(isArabic, 'الوضع الداكن (ليلي)', 'Dark Theme'),
                    subtitle: _t(isArabic, 'مظهر داكن وموفر للطاقة والبطارية',
                        'Dark sleek appearance'),
                    icon: Icons.nights_stay_rounded,
                    isSelected: isDark,
                    isDark: isDark,
                    showDivider: false,
                    onTap: () => settings.setDarkMode(true),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 2. Language & Region Section
              _buildSectionHeader(
                title: _t(isArabic, 'اللغة والمنطقة', 'Language & Region'),
                icon: Icons.language_rounded,
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              _buildMenuGroup(
                isDark: isDark,
                children: [
                  _buildLanguageSelectorTile(
                    title: 'العربية (اليمن / الخليج)',
                    subtitle: 'Arabic',
                    flagText: '🇾🇪',
                    isSelected: isArabic,
                    isDark: isDark,
                    onTap: () => settings.setLanguage(isEnglish: false),
                  ),
                  Divider(height: 1, indent: 60, color: cardBorder(isDark)),
                  _buildLanguageSelectorTile(
                    title: 'English (United States)',
                    subtitle: 'English',
                    flagText: '🇬🇧',
                    isSelected: !isArabic,
                    isDark: isDark,
                    showDivider: false,
                    onTap: () => settings.setLanguage(isEnglish: true),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 3. Notification Settings Section
              _buildSectionHeader(
                title:
                    _t(isArabic, 'إعدادات الإشعارات', 'Notifications Settings'),
                icon: Icons.notifications_none_rounded,
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              _buildMenuGroup(
                isDark: isDark,
                children: [
                  _buildSwitchTile(
                    title: _t(isArabic, 'إشعارات الصيانة والمواعيد',
                        'Maintenance & Appointments'),
                    subtitle: _t(isArabic, 'تذكير قبل موعد الصيانة الدورية',
                        'Reminders before service date'),
                    icon: Icons.build_circle_outlined,
                    value: _maintenanceNotifs,
                    isDark: isDark,
                    onChanged: (v) => setState(() => _maintenanceNotifs = v),
                  ),
                  Divider(height: 1, indent: 60, color: cardBorder(isDark)),
                  _buildSwitchTile(
                    title: _t(isArabic, 'تنبيهات حالة الطلبات',
                        'Order Status Updates'),
                    subtitle: _t(isArabic, 'إشعار مباشر عند تحديث حالة الطلب',
                        'Live updates on order progress'),
                    icon: Icons.local_shipping_outlined,
                    value: _orderNotifs,
                    isDark: isDark,
                    onChanged: (v) => setState(() => _orderNotifs = v),
                  ),
                  Divider(height: 1, indent: 60, color: cardBorder(isDark)),
                  _buildSwitchTile(
                    title: _t(isArabic, 'عروض وتخفيضات CarZone',
                        'Promotions & Discounts'),
                    subtitle: _t(isArabic, 'إرسال التخفيضات والكوبونات',
                        'Receive coupons & discount alerts'),
                    icon: Icons.local_offer_outlined,
                    value: _offersNotifs,
                    isDark: isDark,
                    showDivider: false,
                    onChanged: (v) => setState(() => _offersNotifs = v),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 4. Security & Privacy Section
              _buildSectionHeader(
                title: _t(isArabic, 'الأمان والحماية', 'Security & Privacy'),
                icon: Icons.security_rounded,
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              _buildMenuGroup(
                isDark: isDark,
                children: [
                  _buildClickableTile(
                    title: _t(isArabic, 'تغيير كلمة المرور', 'Change Password'),
                    subtitle: _t(isArabic, 'تحديث كلمة المرور الخاصة بحسابك',
                        'Update account password'),
                    icon: Icons.lock_reset_rounded,
                    isDark: isDark,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              _t(isArabic, 'الانتقال لصفحة استعادة كلمة المرور',
                                  'Navigating to password reset'),
                              style: GoogleFonts.cairo()),
                          backgroundColor: AppPalette.primary,
                        ),
                      );
                    },
                  ),
                  Divider(height: 1, indent: 60, color: cardBorder(isDark)),
                  _buildSwitchTile(
                    title: _t(isArabic, 'الدخول بالبصمة / FaceID',
                        'Biometric / FaceID Login'),
                    subtitle: _t(isArabic, 'تسجيل دخول سريع وآمن بالبصمة',
                        'Quick fingerprint & face login'),
                    icon: Icons.fingerprint_rounded,
                    value: _biometricsEnabled,
                    isDark: isDark,
                    showDivider: false,
                    onChanged: (v) => setState(() => _biometricsEnabled = v),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 5. Data & Storage
              _buildSectionHeader(
                title: _t(isArabic, 'التخزين والبيانات', 'Storage & Data'),
                icon: Icons.storage_rounded,
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              _buildMenuGroup(
                isDark: isDark,
                children: [
                  _buildClickableTile(
                    title: _t(isArabic, 'مسح الذاكرة المؤقتة (Cache)',
                        'Clear App Cache'),
                    subtitle: _t(
                        isArabic,
                        'تحرير المساحة وتسريع التطبيق (14.2 ميجابايت)',
                        'Free space & speed up app (14.2 MB)'),
                    icon: Icons.cleaning_services_rounded,
                    isDark: isDark,
                    showDivider: false,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              _t(isArabic, 'تم مسح الذاكرة المؤقتة بنجاح',
                                  'Cache cleared successfully'),
                              style: GoogleFonts.cairo()),
                          backgroundColor: AppPalette.success,
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppPalette.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: textPrimary(isDark),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuGroup({
    required bool isDark,
    required List<Widget> children,
  }) {
    return Container(
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
      child: Column(children: children),
    );
  }

  Widget _buildThemeSelectorTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppPalette.primary.withOpacity(0.15)
              : AppPalette.primary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isSelected ? AppPalette.primary : textSecondary(isDark),
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.cairo(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          color: textPrimary(isDark),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.cairo(fontSize: 12, color: textSecondary(isDark)),
      ),
      trailing: isSelected
          ? Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: AppPalette.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 14, color: Colors.white),
            )
          : const SizedBox.shrink(),
      onTap: onTap,
    );
  }

  Widget _buildLanguageSelectorTile({
    required String title,
    required String subtitle,
    required String flagText,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppPalette.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          flagText,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.cairo(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          color: textPrimary(isDark),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.cairo(fontSize: 12, color: textSecondary(isDark)),
      ),
      trailing: isSelected
          ? Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: AppPalette.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 14, color: Colors.white),
            )
          : const SizedBox.shrink(),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required bool isDark,
    required ValueChanged<bool> onChanged,
    bool showDivider = true,
  }) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      secondary: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppPalette.primary.withOpacity(0.08),
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
        style: GoogleFonts.cairo(fontSize: 12, color: textSecondary(isDark)),
      ),
      activeColor: AppPalette.primary,
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildClickableTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isDark,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppPalette.primary.withOpacity(0.08),
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
        style: GoogleFonts.cairo(fontSize: 12, color: textSecondary(isDark)),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded,
          size: 15, color: AppPalette.primary),
      onTap: onTap,
    );
  }
}
