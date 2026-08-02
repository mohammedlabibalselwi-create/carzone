import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_colors.dart';
import '../widgets/submit_quote_bottom_sheet.dart';
import 'submit_quote_screen.dart';

class SupplierNewOrdersScreen extends StatefulWidget {
  const SupplierNewOrdersScreen({super.key});

  @override
  State<SupplierNewOrdersScreen> createState() =>
      _SupplierNewOrdersScreenState();
}

class _SupplierNewOrdersScreenState extends State<SupplierNewOrdersScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _allOrders = [
    {
      'id': '#REQ-1021',
      'carType': 'تويوتا (Toyota)',
      'carModel': 'كامري 2022',
      'part': 'صدام أمامي أصلي',
      'notes': 'يفضل قطعة جديدة من الوكالة أو قطعة تشليح نظيفة بدون خدوش',
      'city': 'الرياض',
      'timeAgo': 'منذ 5 دقائق',
      'urgent': true,
    },
    {
      'id': '#REQ-1022',
      'carType': 'هيونداي (Hyundai)',
      'carModel': 'سوناتا 2020',
      'part': 'فحمات فرامل خلفية',
      'notes': 'طقم كامل للمحور الخلفي',
      'city': 'جدة',
      'timeAgo': 'منذ 18 دقيقة',
      'urgent': false,
    },
    {
      'id': '#REQ-1023',
      'carType': 'نيسان (Nissan)',
      'carModel': 'التيما 2021',
      'part': 'فلتر زيت المحرك',
      'notes': 'أي ماركة معروفة مثل OEM أو Denso',
      'city': 'الدمام',
      'timeAgo': 'منذ 45 دقيقة',
      'urgent': false,
    },
    {
      'id': '#REQ-1024',
      'carType': 'لكزس (Lexus)',
      'carModel': 'LX570 2019',
      'part': 'مساعدات أمامية - طقم',
      'notes': 'يفضل مساعدات أصلية هيدروليكية',
      'city': 'الرياض',
      'timeAgo': 'منذ ساعة',
      'urgent': true,
    },
    {
      'id': '#REQ-1025',
      'carType': 'مرسيدس (Mercedes)',
      'carModel': 'C200 2020',
      'part': 'حساس مسافة (PDC) خلفي',
      'notes': 'اللون: أسود، أصلي فقط',
      'city': 'مكة',
      'timeAgo': 'منذ ساعتين',
      'urgent': false,
    },
    {
      'id': '#REQ-1026',
      'carType': 'كيا (Kia)',
      'carModel': 'سورينتو 2023',
      'part': 'ذراع تعليق أمامية يسار',
      'notes': 'ماركة Moog أو مشابه',
      'city': 'المدينة المنورة',
      'timeAgo': 'منذ 3 ساعات',
      'urgent': false,
    },
    {
      'id': '#REQ-1027',
      'carType': 'فورد (Ford)',
      'carModel': 'F150 2018',
      'part': 'ضاغطة تكييف',
      'notes': 'مستعملة أو جديدة، المهم تشتغل',
      'city': 'الرياض',
      'timeAgo': 'منذ 4 ساعات',
      'urgent': false,
    },
    {
      'id': '#REQ-1028',
      'carType': 'جي إم سي (GMC)',
      'carModel': 'يوكون 2022',
      'part': 'مصابيح أمامية LED - زوج',
      'notes': 'أصلية OEM بالضبط',
      'city': 'الطائف',
      'timeAgo': 'منذ 5 ساعات',
      'urgent': false,
    },
    {
      'id': '#REQ-1029',
      'carType': 'شيفروليه (Chevrolet)',
      'carModel': 'ماليبو 2021',
      'part': 'تيل فرامل أمامية',
      'notes': 'أي نوع موثوق',
      'city': 'الدمام',
      'timeAgo': 'منذ 6 ساعات',
      'urgent': false,
    },
    {
      'id': '#REQ-1030',
      'carType': 'بي إم دبليو (BMW)',
      'carModel': 'X5 2020',
      'part': 'حساس ABS خلفي أيمن',
      'notes': 'أصلي أو Bosch',
      'city': 'الرياض',
      'timeAgo': 'منذ 8 ساعات',
      'urgent': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredOrders {
    if (_searchQuery.isEmpty) return _allOrders;
    return _allOrders.where((o) {
      final q = _searchQuery.toLowerCase();
      return (o['carType'] as String).toLowerCase().contains(q) ||
          (o['carModel'] as String).toLowerCase().contains(q) ||
          (o['part'] as String).toLowerCase().contains(q) ||
          (o['id'] as String).toLowerCase().contains(q);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSubmitQuoteSheet(BuildContext context, Map<String, dynamic> order) {
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
      builder: (ctx) => _OrderDetailsSheet(order: order, isDark: isDark),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;
    final isArabic = !settings.isEnglish;
    String t(String ar, String en) => isArabic ? ar : en;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // ─── Search Bar ───
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: cardBg(isDark),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cardBorder(isDark)),
                boxShadow: [
                  BoxShadow(
                    color: cardShadow(isDark),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _searchQuery = v),
                style: GoogleFonts.cairo(color: textPrimary(isDark)),
                decoration: InputDecoration(
                  hintText: t('ابحث بالسيارة أو القطعة أو رقم الطلب...',
                      'Search by car, part, or request ID...'),
                  hintStyle: GoogleFonts.cairo(
                      color: textSecondary(isDark), fontSize: 14),
                  prefixIcon:
                      Icon(Icons.search_rounded, color: textSecondary(isDark)),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.close_rounded,
                              color: textSecondary(isDark)),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),

          // ─── Count Row ───
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppPalette.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${_filteredOrders.length} ${t('طلب نشط', 'active requests')}',
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

          // ─── Orders List ───
          Expanded(
            child: _filteredOrders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 60, color: textSecondary(isDark)),
                        const SizedBox(height: 12),
                        Text(
                          t('لا توجد نتائج مطابقة', 'No matching results'),
                          style: GoogleFonts.cairo(
                              color: textSecondary(isDark), fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = _filteredOrders[index];
                      return _OrderCard(
                        order: order,
                        isDark: isDark,
                        onViewDetails: () =>
                            _showOrderDetails(context, order, isDark),
                        onSubmitQuote: () =>
                            _showSubmitQuoteSheet(context, order),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Order Card Widget
// ─────────────────────────────────────────
class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final bool isDark;
  final VoidCallback onViewDetails;
  final VoidCallback onSubmitQuote;

  const _OrderCard({
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
                                fontWeight: FontWeight.bold,
                              ),
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

          // ── Order Body ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Car Info
                Row(
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
                            order['carType'] as String,
                            style: GoogleFonts.cairo(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: textPrimary(isDark),
                            ),
                          ),
                          Text(
                            order['carModel'] as String,
                            style: GoogleFonts.cairo(
                              fontSize: 13,
                              color: textSecondary(isDark),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 3),
                        Text(
                          order['city'] as String,
                          style: GoogleFonts.cairo(
                              fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Part Description
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppPalette.accent.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppPalette.accent.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.build_rounded,
                          color: AppPalette.accent, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'القطعة المطلوبة: ${order['part']}',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppPalette.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Action Buttons ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Row(
              children: [
                // View Details Button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onViewDetails,
                    icon: const Icon(Icons.visibility_outlined, size: 16),
                    label: Text(
                      'التفاصيل',
                      style: GoogleFonts.cairo(
                          fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppPalette.primary,
                      side: const BorderSide(color: AppPalette.primary),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Submit Quote Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onSubmitQuote,
                    icon: const Icon(Icons.send_rounded, size: 16),
                    label: Text(
                      'تقديم عرض',
                      style: GoogleFonts.cairo(
                          fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPalette.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
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

// ─────────────────────────────────────────
// Order Details Bottom Sheet
// ─────────────────────────────────────────
class _OrderDetailsSheet extends StatelessWidget {
  final Map<String, dynamic> order;
  final bool isDark;

  const _OrderDetailsSheet({required this.order, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      maxChildSize: 0.85,
      minChildSize: 0.4,
      builder: (ctx, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: cardBg(isDark),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
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
                    // Header
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
                        Column(
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
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : AppPalette.primary.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: cardBorder(isDark)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ملاحظات العميل:',
                            style: GoogleFonts.cairo(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: textSecondary(isDark),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            order['notes'] as String,
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              color: textPrimary(isDark),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                Text(
                  label,
                  style: GoogleFonts.cairo(
                      fontSize: 12, color: textSecondary(isDark)),
                ),
                Text(
                  value,
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textPrimary(isDark),
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
