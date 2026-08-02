import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_colors.dart';
import 'seller_verification_screen.dart';
import 'submit_quote_screen.dart';

class SupplierHomeScreen extends StatelessWidget {
  const SupplierHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;
    final isArabic = !settings.isEnglish;
    String t(String ar, String en) => isArabic ? ar : en;

    // آخر 10 طلبات
    final List<Map<String, dynamic>> latestOrders = [
      {
        'id': '#REQ-1030',
        'carType': 'تويوتا (Toyota)',
        'carModel': 'كامري 2022',
        'part': 'صدام أمامي أصلي',
        'city': 'الرياض',
        'timeAgo': 'منذ 5 دقائق',
        'urgent': true
      },
      {
        'id': '#REQ-1029',
        'carType': 'هيونداي (Hyundai)',
        'carModel': 'سوناتا 2020',
        'part': 'فحمات فرامل خلفية',
        'city': 'جدة',
        'timeAgo': 'منذ 20 دقيقة',
        'urgent': false
      },
      {
        'id': '#REQ-1028',
        'carType': 'نيسان (Nissan)',
        'carModel': 'التيما 2021',
        'part': 'فلتر زيت المحرك',
        'city': 'الدمام',
        'timeAgo': 'منذ 45 دقيقة',
        'urgent': false
      },
      {
        'id': '#REQ-1027',
        'carType': 'لكزس (Lexus)',
        'carModel': 'LX570 2019',
        'part': 'مساعدات أمامية - طقم',
        'city': 'الرياض',
        'timeAgo': 'منذ ساعة',
        'urgent': true
      },
      {
        'id': '#REQ-1026',
        'carType': 'مرسيدس (Mercedes)',
        'carModel': 'C200 2020',
        'part': 'حساس مسافة خلفي',
        'city': 'مكة',
        'timeAgo': 'منذ ساعتين',
        'urgent': false
      },
      {
        'id': '#REQ-1025',
        'carType': 'كيا (Kia)',
        'carModel': 'سورينتو 2023',
        'part': 'ذراع تعليق أمامية يسار',
        'city': 'المدينة',
        'timeAgo': 'منذ 3 ساعات',
        'urgent': false
      },
      {
        'id': '#REQ-1024',
        'carType': 'فورد (Ford)',
        'carModel': 'F150 2018',
        'part': 'ضاغطة تكييف',
        'city': 'الرياض',
        'timeAgo': 'منذ 4 ساعات',
        'urgent': false
      },
      {
        'id': '#REQ-1023',
        'carType': 'جي إم سي (GMC)',
        'carModel': 'يوكون 2022',
        'part': 'مصابيح أمامية LED',
        'city': 'الطائف',
        'timeAgo': 'منذ 5 ساعات',
        'urgent': false
      },
      {
        'id': '#REQ-1022',
        'carType': 'شيفروليه (Chevrolet)',
        'carModel': 'ماليبو 2021',
        'part': 'تيل فرامل أمامية',
        'city': 'الدمام',
        'timeAgo': 'منذ 6 ساعات',
        'urgent': false
      },
      {
        'id': '#REQ-1021',
        'carType': 'بي إم دبليو (BMW)',
        'carModel': 'X5 2020',
        'part': 'حساس ABS خلفي أيمن',
        'city': 'الرياض',
        'timeAgo': 'منذ 8 ساعات',
        'urgent': false
      },
    ];

    return Scaffold(
      backgroundColor: background(isDark),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── Welcome Banner ───
          SliverToBoxAdapter(child: _buildWelcomeBanner(isDark, t)),

          // ─── Verification Notice Banner ───
          SliverToBoxAdapter(
              child: _buildVerificationNoticeBanner(context, isDark, t)),

          // ─── Section Header ───
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
              child: Row(
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
                    t('أحدث 10 طلبات', 'Latest 10 Requests'),
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textPrimary(isDark),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppPalette.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${latestOrders.length} طلب',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppPalette.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Orders List ───
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final order = latestOrders[index];
                return _HomeOrderCard(
                  order: order,
                  isDark: isDark,
                  onViewDetails: () =>
                      _showOrderDetails(context, order, isDark),
                  onSubmitQuote: () => _showSubmitQuoteSheet(context, order, t),
                );
              },
              childCount: latestOrders.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  void _showSubmitQuoteSheet(BuildContext context, Map<String, dynamic> order,
      String Function(String, String) t) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SubmitQuoteScreen(
          orderId: order['id'] as String,
          carType: order['carType'] as String,
          carModel: order['carModel'] as String,
          partName: order['part'] as String,
        ),
      ),
    );
  }

  void _showOrderDetails(
      BuildContext context, Map<String, dynamic> order, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.8,
        minChildSize: 0.4,
        builder: (ctx, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: cardBg(isDark),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppPalette.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.description_rounded,
                                color: AppPalette.primary, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'تفاصيل الطلب',
                                  style: GoogleFonts.cairo(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textPrimary(isDark),
                                  ),
                                ),
                                Text(
                                  order['id'] as String,
                                  style: GoogleFonts.cairo(
                                    fontSize: 13,
                                    color: AppPalette.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _detailRow(Icons.directions_car_rounded, 'نوع السيارة',
                          order['carType'] as String, isDark),
                      _detailRow(Icons.calendar_today_rounded, 'الموديل',
                          order['carModel'] as String, isDark),
                      _detailRow(Icons.build_rounded, 'القطعة المطلوبة',
                          order['part'] as String, isDark),
                      _detailRow(Icons.location_on_rounded, 'المدينة',
                          order['city'] as String, isDark),
                      _detailRow(Icons.access_time_rounded, 'وقت الطلب',
                          order['timeAgo'] as String, isDark),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SubmitQuoteScreen(
                                  orderId: order['id'] as String,
                                  carType: order['carType'] as String,
                                  carModel: order['carModel'] as String,
                                  partName: order['part'] as String,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.send_rounded, size: 18),
                          label: Text(
                            'تقديم عرض سعر الآن',
                            style: GoogleFonts.cairo(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppPalette.accent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppPalette.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppPalette.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.cairo(
                        fontSize: 12, color: textSecondary(isDark))),
                Text(value,
                    style: GoogleFonts.cairo(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: textPrimary(isDark))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner(bool isDark, String Function(String, String) t) {
    return Container(
      margin: const EdgeInsets.all(16),
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
          ),
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
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.storefront_rounded,
                    color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t('مرحباً بك في كار زون', 'Welcome to CarZone'),
                      style: GoogleFonts.cairo(
                          fontSize: 14, color: Colors.white70),
                    ),
                    Text(
                      t('مؤسسة الخالد لقطع الغيار', 'Al-Khaled Auto Parts'),
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t('الطلبات الجديدة اليوم', 'New Orders Today'),
                      style:
                          GoogleFonts.cairo(color: Colors.white, fontSize: 13),
                    ),
                    Text(
                      '+10 ${t('طلب جديد', 'new requests')}',
                      style: GoogleFonts.cairo(
                        color: AppPalette.accent,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.trending_up_rounded, color: AppPalette.accent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationNoticeBanner(
      BuildContext context, bool isDark, String Function(String, String) t) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppPalette.danger.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPalette.danger.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: AppPalette.danger, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              t('حسابك غير موثّق بعد. يرجى إكمال التوثيق.',
                  'Seller account unverified. Please complete verification.'),
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppPalette.danger,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const SellerVerificationScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppPalette.danger,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                t('توثيق', 'Verify'),
                style: GoogleFonts.cairo(
                  fontSize: 11,
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
}

// ─────────────────────────────────────────
// Home Order Card  (بطاقة طلب الرئيسية)
// ─────────────────────────────────────────
class _HomeOrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final bool isDark;
  final VoidCallback onViewDetails;
  final VoidCallback onSubmitQuote;

  const _HomeOrderCard({
    required this.order,
    required this.isDark,
    required this.onViewDetails,
    required this.onSubmitQuote,
  });

  @override
  Widget build(BuildContext context) {
    final isUrgent = order['urgent'] as bool;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: cardBg(isDark),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUrgent
              ? AppPalette.danger.withValues(alpha: 0.4)
              : cardBorder(isDark),
          width: isUrgent ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isUrgent
                ? AppPalette.danger.withValues(alpha: 0.08)
                : cardShadow(isDark),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Row ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : AppPalette.primary.withValues(alpha: 0.04),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppPalette.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        order['id'] as String,
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isUrgent) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppPalette.danger,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.bolt_rounded,
                                color: Colors.white, size: 12),
                            const SizedBox(width: 3),
                            Text(
                              'عاجل',
                              style: GoogleFonts.cairo(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded,
                        size: 13, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      order['timeAgo'] as String,
                      style:
                          GoogleFonts.cairo(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Body ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppPalette.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.directions_car_rounded,
                      color: AppPalette.primary, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${order['carType']} · ${order['carModel']}',
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          color: textSecondary(isDark),
                        ),
                      ),
                      Text(
                        order['part'] as String,
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: textPrimary(isDark),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        size: 13, color: Colors.grey),
                    const SizedBox(width: 3),
                    Text(
                      order['city'] as String,
                      style:
                          GoogleFonts.cairo(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── TWO Action Buttons ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: Row(
              children: [
                // زر معاينة التفاصيل
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onViewDetails,
                    icon: const Icon(Icons.visibility_outlined, size: 15),
                    label: Text(
                      'التفاصيل',
                      style: GoogleFonts.cairo(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppPalette.primary,
                      side: const BorderSide(color: AppPalette.primary),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // زر تقديم عرض سعر
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onSubmitQuote,
                    icon: const Icon(Icons.send_rounded, size: 15),
                    label: Text(
                      'تقديم عرض',
                      style: GoogleFonts.cairo(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPalette.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
