import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_colors.dart';
import '../widgets/submit_quote_bottom_sheet.dart';

enum OfferStatus { pending, accepted, rejected }

class SupplierMyOffersScreen extends StatefulWidget {
  const SupplierMyOffersScreen({super.key});

  @override
  State<SupplierMyOffersScreen> createState() => _SupplierMyOffersScreenState();
}

class _SupplierMyOffersScreenState extends State<SupplierMyOffersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _allOffers = [
    {
      'id': 'OF-501',
      'requestId': '#REQ-1021',
      'part': 'صدام أمامي أصلي',
      'carType': 'تويوتا كامري 2022',
      'price': 450.0,
      'delivery': 'خلال 24 ساعة',
      'timeAgo': 'منذ 10 دقائق',
      'status': OfferStatus.pending,
    },
    {
      'id': 'OF-502',
      'requestId': '#REQ-1022',
      'part': 'فحمات فرامل خلفية',
      'carType': 'هيونداي سوناتا 2020',
      'price': 120.0,
      'delivery': 'يومين',
      'timeAgo': 'منذ ساعة',
      'status': OfferStatus.pending,
    },
    {
      'id': 'OF-503',
      'requestId': '#REQ-1010',
      'part': 'مساعدات أمامية - طقم',
      'carType': 'لكزس LX570 2019',
      'price': 1200.0,
      'delivery': '3 أيام',
      'timeAgo': 'منذ 3 ساعات',
      'status': OfferStatus.accepted,
    },
    {
      'id': 'OF-504',
      'requestId': '#REQ-1005',
      'part': 'فلتر زيت المحرك',
      'carType': 'نيسان التيما 2021',
      'price': 45.0,
      'delivery': 'فوري',
      'timeAgo': 'منذ يوم',
      'status': OfferStatus.accepted,
    },
    {
      'id': 'OF-505',
      'requestId': '#REQ-0998',
      'part': 'حساس ABS خلفي أيمن',
      'carType': 'بي إم دبليو X5 2020',
      'price': 380.0,
      'delivery': '5 أيام',
      'timeAgo': 'منذ 3 أيام',
      'status': OfferStatus.rejected,
    },
    {
      'id': 'OF-506',
      'requestId': '#REQ-0985',
      'part': 'حساس مسافة (PDC) خلفي',
      'carType': 'مرسيدس C200 2020',
      'price': 290.0,
      'delivery': 'يومان',
      'timeAgo': 'منذ 5 أيام',
      'status': OfferStatus.rejected,
    },
    {
      'id': 'OF-507',
      'requestId': '#REQ-1028',
      'part': 'مصابيح أمامية LED',
      'carType': 'جي إم سي يوكون 2022',
      'price': 870.0,
      'delivery': '4 أيام',
      'timeAgo': 'منذ 5 ساعات',
      'status': OfferStatus.pending,
    },
  ];

  List<Map<String, dynamic>> _getByStatus(OfferStatus status) =>
      _allOffers.where((o) => o['status'] == status).toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // ─── Tab Bar ───
          Container(
            color: cardBg(isDark),
            child: TabBar(
              controller: _tabController,
              labelStyle:
                  GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13),
              unselectedLabelStyle: GoogleFonts.cairo(fontSize: 12),
              labelColor: AppPalette.primary,
              unselectedLabelColor: textSecondary(isDark),
              indicatorColor: AppPalette.accent,
              indicatorWeight: 3,
              tabs: [
                Tab(
                  child: _buildTabLabel(
                    'قيد الانتظار',
                    _getByStatus(OfferStatus.pending).length,
                    Colors.orange,
                  ),
                ),
                Tab(
                  child: _buildTabLabel(
                    'مقبولة',
                    _getByStatus(OfferStatus.accepted).length,
                    AppPalette.success,
                  ),
                ),
                Tab(
                  child: _buildTabLabel(
                    'مرفوضة',
                    _getByStatus(OfferStatus.rejected).length,
                    AppPalette.danger,
                  ),
                ),
              ],
            ),
          ),

          // ─── Tab Views ───
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOffersList(_getByStatus(OfferStatus.pending), isDark),
                _buildOffersList(_getByStatus(OfferStatus.accepted), isDark),
                _buildOffersList(_getByStatus(OfferStatus.rejected), isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabLabel(String label, int count, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        if (count > 0) ...[
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Text(
              '$count',
              style: GoogleFonts.cairo(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOffersList(List<Map<String, dynamic>> offers, bool isDark) {
    if (offers.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded,
                size: 64, color: textSecondary(isDark).withValues(alpha: 0.4)),
            const SizedBox(height: 14),
            Text(
              'لا توجد عروض في هذا القسم',
              style:
                  GoogleFonts.cairo(color: textSecondary(isDark), fontSize: 15),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      physics: const BouncingScrollPhysics(),
      itemCount: offers.length,
      itemBuilder: (ctx, i) => _OfferCard(
        offer: offers[i],
        isDark: isDark,
        onEdit: () => _showEditSheet(context, offers[i]),
      ),
    );
  }

  void _showEditSheet(BuildContext context, Map<String, dynamic> offer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SubmitQuoteBottomSheet(
        orderTitle: offer['part'] as String,
        initialPrice: (offer['price'] as double).toStringAsFixed(0),
        initialDelivery: offer['delivery'] as String,
        isEditing: true,
        onQuoteSubmitted: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم تعديل العرض بنجاح', style: GoogleFonts.cairo()),
              backgroundColor: AppPalette.success,
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────
// Offer Card Widget
// ─────────────────────────────────────────
class _OfferCard extends StatelessWidget {
  final Map<String, dynamic> offer;
  final bool isDark;
  final VoidCallback onEdit;

  const _OfferCard({
    required this.offer,
    required this.isDark,
    required this.onEdit,
  });

  Color get _statusColor {
    switch (offer['status'] as OfferStatus) {
      case OfferStatus.pending:
        return Colors.orange;
      case OfferStatus.accepted:
        return AppPalette.success;
      case OfferStatus.rejected:
        return AppPalette.danger;
    }
  }

  String get _statusText {
    switch (offer['status'] as OfferStatus) {
      case OfferStatus.pending:
        return 'قيد الانتظار';
      case OfferStatus.accepted:
        return 'مقبولة';
      case OfferStatus.rejected:
        return 'مرفوضة';
    }
  }

  IconData get _statusIcon {
    switch (offer['status'] as OfferStatus) {
      case OfferStatus.pending:
        return Icons.hourglass_top_rounded;
      case OfferStatus.accepted:
        return Icons.check_circle_rounded;
      case OfferStatus.rejected:
        return Icons.cancel_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPending = offer['status'] == OfferStatus.pending;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: cardBg(isDark),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _statusColor.withValues(alpha: isPending ? 0.35 : 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: _statusColor.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.06),
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
                        offer['requestId'] as String,
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: _statusColor.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_statusIcon, size: 13, color: _statusColor),
                          const SizedBox(width: 4),
                          Text(
                            _statusText,
                            style: GoogleFonts.cairo(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  offer['timeAgo'] as String,
                  style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          // ── Body ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Part & Car
                Text(
                  offer['part'] as String,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textPrimary(isDark),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  offer['carType'] as String,
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    color: textSecondary(isDark),
                  ),
                ),
                const SizedBox(height: 12),

                // Price & Delivery
                Row(
                  children: [
                    _InfoChip(
                      icon: Icons.attach_money_rounded,
                      label:
                          '${(offer['price'] as double).toStringAsFixed(0)} ر.س',
                      color: AppPalette.primary,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 10),
                    _InfoChip(
                      icon: Icons.local_shipping_rounded,
                      label: offer['delivery'] as String,
                      color: AppPalette.accent,
                      isDark: isDark,
                    ),
                  ],
                ),

                // Edit Button for Pending only
                if (isPending) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_rounded, size: 16),
                      label: Text(
                        'تعديل العرض',
                        style: GoogleFonts.cairo(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                        side: const BorderSide(color: Colors.orange),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
