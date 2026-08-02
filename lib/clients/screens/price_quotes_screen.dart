import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_colors.dart';

import '../../theme/responsive_layout.dart';

class PriceQuotesScreen extends StatefulWidget {
  final Function(int count)? onPendingCountChanged;

  const PriceQuotesScreen({super.key, this.onPendingCountChanged});

  @override
  State<PriceQuotesScreen> createState() => _PriceQuotesScreenState();
}

class _PriceQuotesScreenState extends State<PriceQuotesScreen> {
  String _t(bool isArabic, String ar, String en) => isArabic ? ar : en;

  // List of price quotes received for customer requests (Anonymous merchants)
  final List<Map<String, dynamic>> _receivedQuotes = [
    {
      'id': 'Q-701',
      'requestId': '#REQ-8912',
      'partName': 'صدام أمامي + كشافات كامري 2022',
      'partType': 'new', // جديد
      'price': 450.0,
      'currency': 'ر.س',
      'warranty': 'ضمان سنة كاملة',
      'deliveryTime': 'توصيل غداً',
      'notes': 'قطعة جديدة أصلية وكالة بالكامل كرتون مع غطاء الكشافات',
      'timeAgo': 'منذ 10 دقائق',
      'status': 'pending',
    },
    {
      'id': 'Q-702',
      'requestId': '#REQ-8912',
      'partName': 'صدام أمامي كامري 2022',
      'partType': 'scrapy', // تشليح
      'price': 280.0,
      'currency': 'ر.س',
      'warranty': 'ضمان تجربة 15 يوم',
      'deliveryTime': 'توصيل فوري خلال 3 ساعات',
      'notes': 'قطعة تشليح نظيفة جداً صبغة وكالة خالية من الصدمات والخدوش',
      'timeAgo': 'منذ 25 دقيقة',
      'status': 'pending',
    },
    {
      'id': 'Q-703',
      'requestId': '#REQ-8740',
      'partName': 'مساعدات خلفية لكزس ES 2020 (طقم)',
      'partType': 'new', // جديد
      'price': 620.0,
      'currency': 'ر.س',
      'warranty': 'ضمان 6 أشهر',
      'deliveryTime': 'توصيل خلال 48 ساعة',
      'notes': 'طقم مساعدات هيدروليك أصلي ياباني مضموت بالكامل',
      'timeAgo': 'منذ ساعة',
      'status': 'pending',
    },
  ];

  void _notifyCount() {
    final count = _receivedQuotes.where((q) => q['status'] == 'pending').length;
    widget.onPendingCountChanged?.call(count);
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;
    final isArabic = !settings.isEnglish;

    final pendingQuotes =
        _receivedQuotes.where((q) => q['status'] == 'pending').toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _t(isArabic, 'عروض الأسعار الواردة',
                            'Received Price Quotes'),
                        style: GoogleFonts.cairo(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textPrimary(isDark),
                        ),
                      ),
                      Text(
                        _t(
                          isArabic,
                          'العروض المقدمة لطلباتك من محلات وشركاء التطبيق',
                          'Price quotes sent by merchants for your requests',
                        ),
                        style: GoogleFonts.cairo(
                          fontSize: 12.5,
                          color: textSecondary(isDark),
                        ),
                      ),
                    ],
                  ),
                ),
                if (pendingQuotes.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppPalette.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppPalette.primary.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.request_quote_rounded,
                            size: 16, color: AppPalette.primary),
                        const SizedBox(width: 6),
                        Text(
                          _t(isArabic, '${pendingQuotes.length} عروض',
                              '${pendingQuotes.length} Quotes'),
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppPalette.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: pendingQuotes.isEmpty
                  ? _buildEmptyQuotesView(isArabic, isDark)
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: pendingQuotes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final quote = pendingQuotes[index];
                        return _buildQuoteCard(quote, isArabic, isDark);
                      },
                    ),
            ),
          ],
        ),
      );
  }

  /// Single Price Quote Card (Anonymous Merchant Quote Display)
  Widget _buildQuoteCard(
      Map<String, dynamic> quote, bool isArabic, bool isDark) {
    final bool isNew = quote['partType'] == 'new';

    return Container(
      decoration: BoxDecoration(
        color: cardBg(isDark),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorder(isDark)),
        boxShadow: [
          BoxShadow(
            color: cardShadow(isDark),
            blurRadius: 14,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Request Code Header & Time Ago
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.04)
                  : AppPalette.primary.withOpacity(0.05),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppPalette.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _t(isArabic, 'رقم الطلب:', 'Request:'),
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      quote['requestId'] as String,
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: textPrimary(isDark),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded,
                        size: 14, color: textSecondary(isDark)),
                    const SizedBox(width: 4),
                    Text(
                      quote['timeAgo'] as String,
                      style: GoogleFonts.cairo(
                        fontSize: 11.5,
                        color: textSecondary(isDark),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Part Name Title & Condition Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        quote['partName'] as String,
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textPrimary(isDark),
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Part Condition Badge (جديد / تشليح)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isNew
                            ? AppPalette.success.withOpacity(0.15)
                            : AppPalette.accent.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isNew ? AppPalette.success : AppPalette.accent,
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        isNew
                            ? _t(isArabic, '✨ جديد (وكالة)', '✨ New OEM')
                            : _t(isArabic, '📦 تشليح (مستعمل)', '📦 Scrapy'),
                        style: GoogleFonts.cairo(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: isNew ? AppPalette.success : AppPalette.accent,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 3. Price & Thumbnail Row
                Row(
                  children: [
                    // Mock Part Thumbnail Container
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.06)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: cardBorder(isDark)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              isNew
                                  ? Icons.build_rounded
                                  : Icons.car_repair_rounded,
                              size: 34,
                              color: AppPalette.primary.withOpacity(0.7),
                            ),
                            Positioned(
                              bottom: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _t(isArabic, 'صورة القطعة', 'Part Image'),
                                  style: GoogleFonts.cairo(
                                    fontSize: 8.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Price & Warranty Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '${quote['price']}',
                                style: GoogleFonts.cairo(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppPalette.primary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                quote['currency'] as String,
                                style: GoogleFonts.cairo(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppPalette.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.verified_user_outlined,
                                  size: 14, color: AppPalette.success),
                              const SizedBox(width: 4),
                              Text(
                                quote['warranty'] as String,
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  color: textSecondary(isDark),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.local_shipping_outlined,
                                  size: 14, color: AppPalette.secondary),
                              const SizedBox(width: 4),
                              Text(
                                quote['deliveryTime'] as String,
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  color: textSecondary(isDark),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // 4. Merchant Notes Box
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.04)
                        : Colors.grey.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.sticky_note_2_outlined,
                          size: 16, color: textSecondary(isDark)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          quote['notes'] as String,
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: textSecondary(isDark),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 5. Decision Action Buttons (موافقة / إستبعاد)
                Row(
                  children: [
                    // Accept Button (موافقة واعتماد العرض)
                    Expanded(
                      flex: 6,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _acceptQuote(quote['id'] as String, isArabic),
                        icon: const Icon(Icons.check_circle_rounded,
                            size: 18, color: Colors.white),
                        label: Text(
                          _t(isArabic, 'موافقة واعتماد العرض', 'Accept Quote'),
                          style: GoogleFonts.cairo(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPalette.success,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 1,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Dismiss Button (إستبعاد العرض)
                    Expanded(
                      flex: 4,
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            _dismissQuote(quote['id'] as String, isArabic),
                        icon: const Icon(Icons.close_rounded,
                            size: 18, color: AppPalette.danger),
                        label: Text(
                          _t(isArabic, 'إستبعاد', 'Dismiss'),
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppPalette.danger,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppPalette.danger),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyQuotesView(bool isArabic, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppPalette.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.request_quote_rounded,
              size: 54,
              color: AppPalette.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _t(isArabic, 'لا توجد عروض أسعار حالياً', 'No Price Quotes Yet'),
            style: GoogleFonts.cairo(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: textPrimary(isDark),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _t(
                isArabic,
                'عندما تقوم بطلب قطعة مخصصة، ستصلك عروض الأسعار من محلات التطبيق هنا لتتمكن من اختيار الأنسب لك',
                'When you request custom parts, merchant price quotes will appear here for you to accept or dismiss',
              ),
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 13,
                color: textSecondary(isDark),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _acceptQuote(String quoteId, bool isArabic) {
    showResponsiveBottomSheet(
      context: context,
      maxWidth: 550,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: cardBg(context.watch<SettingsProvider>().isDarkMode),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified_rounded,
                  size: 54, color: AppPalette.success),
              const SizedBox(height: 14),
              Text(
                _t(isArabic, 'تأكيد الموافقة على عرض السعر',
                    'Confirm Accepting Quote'),
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _t(
                  isArabic,
                  'سيتم تأكيد العرض والانتقال لتجهيز وتوصيل طلبك فوراً.',
                  'Your acceptance will be sent to process delivery immediately.',
                ),
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 13.5,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPalette.success,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() {
                      final idx =
                          _receivedQuotes.indexWhere((q) => q['id'] == quoteId);
                      if (idx != -1) {
                        _receivedQuotes[idx]['status'] = 'accepted';
                      }
                    });
                    _notifyCount();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _t(
                            isArabic,
                            'تمت الموافقة على عرض السعر بنجاح! جاري تجهيز الطلب.',
                            'Quote accepted successfully! Processing order.',
                          ),
                          style: GoogleFonts.cairo(),
                        ),
                        backgroundColor: AppPalette.success,
                      ),
                    );
                  },
                  child: Text(
                    _t(isArabic, 'تأكيد واعتماد الطلب', 'Confirm Order'),
                    style: GoogleFonts.cairo(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _dismissQuote(String quoteId, bool isArabic) {
    setState(() {
      final idx = _receivedQuotes.indexWhere((q) => q['id'] == quoteId);
      if (idx != -1) {
        _receivedQuotes[idx]['status'] = 'dismissed';
      }
    });
    _notifyCount();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _t(isArabic, 'تم إستبعاد عرض السعر', 'Quote dismissed'),
          style: GoogleFonts.cairo(),
        ),
        action: SnackBarAction(
          label: _t(isArabic, 'تراجع', 'Undo'),
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              final idx = _receivedQuotes.indexWhere((q) => q['id'] == quoteId);
              if (idx != -1) {
                _receivedQuotes[idx]['status'] = 'pending';
              }
            });
            _notifyCount();
          },
        ),
        backgroundColor: AppPalette.danger,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
