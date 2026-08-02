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

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCondition = 'all'; // 'all', 'new', 'scrapy'
  String _selectedCoverage = 'all'; // 'all', 'full', 'partial'
  String _sortBy = 'newest'; // 'newest', 'price_asc', 'price_desc', 'coverage'

  // Comprehensive test price quotes received for customer requests (Only Supplier ID & Location shown for privacy/anonymity)
  final List<Map<String, dynamic>> _receivedQuotes = [
    {
      'id': 'Q-701',
      'requestId': '#REQ-8912',
      'shopId': '#SH-4092',
      'shopLocation': 'اليمن - تعز',
      'partName': 'صدام أمامي + كشافات ضباب كامري 2022',
      'partType': 'new', // جديد
      'price': 450.0,
      'currency': 'ر.س',
      'warranty': 'ضمان سنة كاملة',
      'deliveryTime': 'توصيل غداً',
      'notes': 'قطع جديدة أصلية وكالة بالكامل كرتون مع غطاء الكشافات',
      'timeAgo': 'منذ 10 دقائق',
      'status': 'pending',
      'quotedPartsCount': 2,
      'totalPartsCount': 5,
      'items': [
        {
          'name': 'صدام أمامي أصلي',
          'price': 320.0,
          'condition': 'جديد (وكالة)'
        },
        {
          'name': 'كشافات ضباب طقم',
          'price': 130.0,
          'condition': 'جديد (وكالة)'
        },
      ],
    },
    {
      'id': 'Q-702',
      'requestId': '#REQ-8912',
      'shopId': '#SH-8841',
      'shopLocation': 'اليمن - صنعاء',
      'partName': 'صدام أمامي كامري 2022',
      'partType': 'scrapy', // تشليح
      'price': 280.0,
      'currency': 'ر.س',
      'warranty': 'ضمان تجربة 15 يوم',
      'deliveryTime': 'توصيل فوري خلال 3 ساعات',
      'notes': 'قطعة تشليح نظيفة جداً صبغة وكالة خالية من الصدمات والخدوش',
      'timeAgo': 'منذ 25 دقيقة',
      'status': 'pending',
      'quotedPartsCount': 1,
      'totalPartsCount': 5,
      'items': [
        {
          'name': 'صدام أمامي تشليح',
          'price': 280.0,
          'condition': 'تشليح (مستعمل)'
        },
      ],
    },
    {
      'id': 'Q-703',
      'requestId': '#REQ-8912',
      'shopId': '#SH-1050',
      'shopLocation': 'السعودية - الرياض',
      'partName': 'عرض شامل لكافة قطع واجهة كامري 2022',
      'partType': 'new', // جديد
      'price': 1150.0,
      'currency': 'ر.س',
      'warranty': 'ضمان سنة كاملة',
      'deliveryTime': 'توصيل خلال 48 ساعة',
      'notes': 'توفير شامل لجميع القطع الخمسة المطلوبة أصلية وكالة بالكامل',
      'timeAgo': 'منذ 40 دقيقة',
      'status': 'pending',
      'quotedPartsCount': 5,
      'totalPartsCount': 5,
      'items': [
        {
          'name': 'صدام أمامي أصلي',
          'price': 350.0,
          'condition': 'جديد (وكالة)'
        },
        {
          'name': 'كشافات ضباب طقم',
          'price': 150.0,
          'condition': 'جديد (وكالة)'
        },
        {'name': 'شبك أمامي كروم', 'price': 200.0, 'condition': 'جديد (وكالة)'},
        {
          'name': 'بطانة صدام سفلي',
          'price': 120.0,
          'condition': 'جديد (وكالة)'
        },
        {'name': 'رفرف أيمن أصلي', 'price': 330.0, 'condition': 'جديد (وكالة)'},
      ],
    },
    {
      'id': 'Q-704',
      'requestId': '#REQ-8740',
      'shopId': '#SH-3320',
      'shopLocation': 'السعودية - جدة',
      'partName': 'مساعدات خلفية لكزس ES 2020 (طقم كامل)',
      'partType': 'new', // جديد
      'price': 620.0,
      'currency': 'ر.س',
      'warranty': 'ضمان 6 أشهر',
      'deliveryTime': 'توصيل خلال 24 ساعة',
      'notes': 'طقم مساعدات هيدروليك أصلي ياباني مضمون بالكامل',
      'timeAgo': 'منذ ساعة',
      'status': 'pending',
      'quotedPartsCount': 2,
      'totalPartsCount': 2,
      'items': [
        {
          'name': 'مساعد خلفي يمين لكزس',
          'price': 310.0,
          'condition': 'جديد (وكالة)'
        },
        {
          'name': 'مساعد خلفي يسار لكزس',
          'price': 310.0,
          'condition': 'جديد (وكالة)'
        },
      ],
    },
    {
      'id': 'Q-705',
      'requestId': '#REQ-8740',
      'shopId': '#SH-5510',
      'shopLocation': 'اليمن - عدن',
      'partName': 'مساعد خلفي يمين لكزس ES 2020',
      'partType': 'scrapy', // تشليح
      'price': 250.0,
      'currency': 'ر.س',
      'warranty': 'ضمان فحص أسبوعين',
      'deliveryTime': 'توصيل خلال 24 ساعة',
      'notes': 'قطعة تشليح ياباني وكالة بحالة الزيرو',
      'timeAgo': 'منذ ساعتين',
      'status': 'pending',
      'quotedPartsCount': 1,
      'totalPartsCount': 2,
      'items': [
        {
          'name': 'مساعد خلفي يمين لكزس',
          'price': 250.0,
          'condition': 'تشليح (مستعمل)'
        },
      ],
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _notifyCount() {
    final count = _receivedQuotes.where((q) => q['status'] == 'pending').length;
    widget.onPendingCountChanged?.call(count);
  }

  List<Map<String, dynamic>> _getFilteredQuotes() {
    return _receivedQuotes.where((quote) {
      if (quote['status'] != 'pending') return false;

      // Safe field values
      final partName = (quote['partName'] ?? '').toString();
      final reqId = (quote['requestId'] ?? '').toString();
      final shopId = (quote['shopId'] ?? '').toString();
      final shopLoc = (quote['shopLocation'] ?? '').toString();
      final notes = (quote['notes'] ?? '').toString();
      final partType = (quote['partType'] ?? '').toString();

      final quotedParts = (quote['quotedPartsCount'] as num?)?.toInt() ?? 1;
      final totalParts = (quote['totalPartsCount'] as num?)?.toInt() ?? 1;

      // Search Query filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!partName.toLowerCase().contains(query) &&
            !reqId.toLowerCase().contains(query) &&
            !shopId.toLowerCase().contains(query) &&
            !shopLoc.toLowerCase().contains(query) &&
            !notes.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Condition Filter
      if (_selectedCondition != 'all') {
        if (partType != _selectedCondition) return false;
      }

      // Coverage Filter
      if (_selectedCoverage != 'all') {
        final isFull = quotedParts == totalParts;
        if (_selectedCoverage == 'full' && !isFull) return false;
        if (_selectedCoverage == 'partial' && isFull) return false;
      }

      return true;
    }).toList()
      ..sort((a, b) {
        final priceA = (a['price'] as num?)?.toDouble() ?? 0.0;
        final priceB = (b['price'] as num?)?.toDouble() ?? 0.0;

        final qPartsA = (a['quotedPartsCount'] as num?)?.toInt() ?? 1;
        final tPartsA = (a['totalPartsCount'] as num?)?.toInt() ?? 1;
        final qPartsB = (b['quotedPartsCount'] as num?)?.toInt() ?? 1;
        final tPartsB = (b['totalPartsCount'] as num?)?.toInt() ?? 1;

        if (_sortBy == 'price_asc') {
          return priceA.compareTo(priceB);
        } else if (_sortBy == 'price_desc') {
          return priceB.compareTo(priceA);
        } else if (_sortBy == 'coverage') {
          final covA = qPartsA / tPartsA;
          final covB = qPartsB / tPartsB;
          return covB.compareTo(covA);
        }
        return 0; // Default: newest
      });
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;
    final isArabic = !settings.isEnglish;

    final filteredQuotes = _getFilteredQuotes();
    final totalPendingCount =
        _receivedQuotes.where((q) => q['status'] == 'pending').length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
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
              if (totalPendingCount > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppPalette.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: AppPalette.primary.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.request_quote_rounded,
                          size: 16, color: AppPalette.primary),
                      const SizedBox(width: 6),
                      Text(
                        _t(isArabic, '$totalPendingCount عروض',
                            '$totalPendingCount Quotes'),
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
          const SizedBox(height: 14),

          // Search Bar & Filter Options
          _buildSearchAndFilterSection(isArabic, isDark),
          const SizedBox(height: 12),

          // Active Quotes List or Empty View
          Expanded(
            child: filteredQuotes.isEmpty
                ? _buildEmptyQuotesView(isArabic, isDark)
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredQuotes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final quote = filteredQuotes[index];
                      return _buildQuoteCard(quote, isArabic, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// Search Input & Filter Chips bar
  Widget _buildSearchAndFilterSection(bool isArabic, bool isDark) {
    final hasActiveFilter = _searchQuery.isNotEmpty ||
        _selectedCondition != 'all' ||
        _selectedCoverage != 'all' ||
        _sortBy != 'newest';

    return Column(
      children: [
        // Search Input
        Container(
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
            onChanged: (val) {
              setState(() {
                _searchQuery = val.trim();
              });
            },
            style:
                GoogleFonts.cairo(fontSize: 13.5, color: textPrimary(isDark)),
            decoration: InputDecoration(
              hintText: _t(
                isArabic,
                'ابحث باسم القطعة، ID أو رقم الطلب...',
                'Search part, Supplier ID, location or request ID...',
              ),
              hintStyle: GoogleFonts.cairo(
                fontSize: 12.5,
                color: textSecondary(isDark),
              ),
              prefixIcon: const Icon(Icons.search_rounded,
                  color: AppPalette.primary, size: 22),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Horizontal Filter Chips Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              // Clear Filter Button (if active)
              if (hasActiveFilter)
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                        _selectedCondition = 'all';
                        _selectedCoverage = 'all';
                        _sortBy = 'newest';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppPalette.danger.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppPalette.danger.withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.restart_alt_rounded,
                              size: 14, color: AppPalette.danger),
                          const SizedBox(width: 4),
                          Text(
                            _t(isArabic, 'إعادة ضبط', 'Reset'),
                            style: GoogleFonts.cairo(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: AppPalette.danger,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Filter 1: Part Condition (الكل / جديد / تشليح)
              _buildFilterChip(
                label: _t(isArabic, 'الحالة: الكل', 'Condition: All'),
                isSelected: _selectedCondition == 'all',
                onTap: () => setState(() => _selectedCondition = 'all'),
                isDark: isDark,
              ),
              _buildFilterChip(
                label: _t(isArabic, '✨ جديد (وكالة)', '✨ OEM New'),
                isSelected: _selectedCondition == 'new',
                onTap: () => setState(() => _selectedCondition = 'new'),
                isDark: isDark,
              ),
              _buildFilterChip(
                label: _t(isArabic, '📦 تشليح (مستعمل)', '📦 Scrapy'),
                isSelected: _selectedCondition == 'scrapy',
                onTap: () => setState(() => _selectedCondition = 'scrapy'),
                isDark: isDark,
              ),

              const SizedBox(width: 8),

              // Filter 2: Parts Coverage (الكل / عرض شامل / عرض جزئي)
              _buildFilterChip(
                label: _t(isArabic, 'تغطية القطع: الكل', 'Coverage: All'),
                isSelected: _selectedCoverage == 'all',
                onTap: () => setState(() => _selectedCoverage = 'all'),
                isDark: isDark,
              ),
              _buildFilterChip(
                label: _t(isArabic, '🎯 عرض شامل', '🎯 Full Quote'),
                isSelected: _selectedCoverage == 'full',
                onTap: () => setState(() => _selectedCoverage = 'full'),
                isDark: isDark,
              ),
              _buildFilterChip(
                label: _t(isArabic, '🧩 عرض جزئي', '🧩 Partial Quote'),
                isSelected: _selectedCoverage == 'partial',
                onTap: () => setState(() => _selectedCoverage = 'partial'),
                isDark: isDark,
              ),

              const SizedBox(width: 8),

              // Filter 3: Sorting Options Dropdown Chip
              PopupMenuButton<String>(
                onSelected: (val) {
                  setState(() {
                    _sortBy = val;
                  });
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: 'newest',
                    child: Text(_t(isArabic, 'الأحدث', 'Newest'),
                        style: GoogleFonts.cairo(fontSize: 12.5)),
                  ),
                  PopupMenuItem(
                    value: 'price_asc',
                    child: Text(_t(isArabic, 'الأقل سعراً', 'Lowest Price'),
                        style: GoogleFonts.cairo(fontSize: 12.5)),
                  ),
                  PopupMenuItem(
                    value: 'price_desc',
                    child: Text(_t(isArabic, 'الأعلى سعراً', 'Highest Price'),
                        style: GoogleFonts.cairo(fontSize: 12.5)),
                  ),
                  PopupMenuItem(
                    value: 'coverage',
                    child: Text(
                        _t(isArabic, 'الأكثر تغطية للقطع',
                            'Most Parts Covered'),
                        style: GoogleFonts.cairo(fontSize: 12.5)),
                  ),
                ],
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppPalette.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: AppPalette.primary.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.sort_rounded,
                          size: 15, color: AppPalette.primary),
                      const SizedBox(width: 4),
                      Text(
                        _t(isArabic, 'ترتيب: ', 'Sort: ') +
                            _getSortLabel(isArabic),
                        style: GoogleFonts.cairo(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: AppPalette.primary,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down_rounded,
                          size: 18, color: AppPalette.primary),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getSortLabel(bool isArabic) {
    switch (_sortBy) {
      case 'price_asc':
        return _t(isArabic, 'الأقل سعراً', 'Lowest Price');
      case 'price_desc':
        return _t(isArabic, 'الأعلى سعراً', 'Highest Price');
      case 'coverage':
        return _t(isArabic, 'الأكثر تغطية', 'Most Covered');
      case 'newest':
      default:
        return _t(isArabic, 'الأحدث', 'Newest');
    }
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? AppPalette.primary
                : (isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.grey.withOpacity(0.12)),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppPalette.primary
                  : (isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.2)),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 11.5,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : textPrimary(isDark),
            ),
          ),
        ),
      ),
    );
  }

  /// Single Price Quote Card (Redesigned: Sleek Action Buttons with floating Count Badge)
  Widget _buildQuoteCard(
      Map<String, dynamic> quote, bool isArabic, bool isDark) {
    final String partType = (quote['partType'] ?? '').toString();
    final bool isNew = partType == 'new';

    final int quotedParts = (quote['quotedPartsCount'] as num?)?.toInt() ?? 1;
    final int totalParts = (quote['totalPartsCount'] as num?)?.toInt() ?? 1;
    final bool isFullQuote = quotedParts == totalParts;

    final String shopId = (quote['shopId'] ?? '').toString();
    final String shopLocation = (quote['shopLocation'] ?? '').toString();
    final String requestId = (quote['requestId'] ?? '').toString();
    final String timeAgo = (quote['timeAgo'] ?? '').toString();
    final String partName = (quote['partName'] ?? '').toString();
    final String currency = (quote['currency'] ?? 'ر.س').toString();
    final String warranty = (quote['warranty'] ?? '').toString();
    final String deliveryTime = (quote['deliveryTime'] ?? '').toString();
    final double price = (quote['price'] as num?)?.toDouble() ?? 0.0;

    // Count of all quotes received for this specific request ID
    final int totalQuotesForThisRequest = _receivedQuotes
        .where((q) => q['requestId'] == requestId && q['status'] == 'pending')
        .length;

    return Container(
      decoration: BoxDecoration(
        color: cardBg(isDark),
        borderRadius: BorderRadius.circular(20),
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
          // 1. HEADER STRIP: Strictly Request ID & Time Ago ONLY
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.04)
                  : AppPalette.primary.withOpacity(0.05),
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
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppPalette.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _t(isArabic, 'رقم الطلب:', 'Req ID:'),
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      requestId,
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
                        size: 13, color: textSecondary(isDark)),
                    const SizedBox(width: 4),
                    Text(
                      timeAgo,
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

          // 2. MAIN BODY CONTENT (Outside Header)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2.1 Hero Row: Part Image Thumbnail + Part Title + Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Thumbnail Container
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.06)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: cardBorder(isDark)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Center(
                          child: Icon(
                            isNew
                                ? Icons.build_rounded
                                : Icons.car_repair_rounded,
                            size: 30,
                            color: AppPalette.primary.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Part Name & Price Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            partName,
                            style: GoogleFonts.cairo(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: textPrimary(isDark),
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Price Banner
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '$price',
                                style: GoogleFonts.cairo(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppPalette.primary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                currency,
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppPalette.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // 2.2 Supplier ID Line
                Row(
                  children: [
                    const Icon(Icons.storefront_rounded,
                        size: 15, color: AppPalette.secondary),
                    const SizedBox(width: 6),
                    Text(
                      _t(isArabic, 'معرّف المورد:', 'Supplier ID:'),
                      style: GoogleFonts.cairo(
                        fontSize: 11.5,
                        color: textSecondary(isDark),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppPalette.secondary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        shopId,
                        style: GoogleFonts.cairo(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: AppPalette.secondary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // 2.3 Location Line
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 15, color: AppPalette.accent),
                    const SizedBox(width: 6),
                    Text(
                      _t(isArabic, 'الموقع:', 'Location:'),
                      style: GoogleFonts.cairo(
                        fontSize: 11.5,
                        color: textSecondary(isDark),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        shopLocation,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: textPrimary(isDark),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // 2.4 Details Specs Wrap (Condition, Coverage, Warranty, Delivery)
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Condition Badge
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isNew
                              ? Icons.verified_rounded
                              : Icons.build_circle_outlined,
                          size: 14,
                          color: isNew ? AppPalette.success : AppPalette.accent,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isNew
                              ? _t(isArabic, 'جديد وكالة', 'OEM New')
                              : _t(isArabic, 'تشليح مستعمل', 'Scrapy Used'),
                          style: GoogleFonts.cairo(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color:
                                isNew ? AppPalette.success : AppPalette.accent,
                          ),
                        ),
                      ],
                    ),

                    // Parts Coverage
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isFullQuote
                              ? Icons.check_circle_rounded
                              : Icons.pie_chart_outline,
                          size: 14,
                          color: isFullQuote
                              ? AppPalette.success
                              : AppPalette.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isFullQuote
                              ? _t(
                                  isArabic,
                                  '$quotedParts من $totalParts (شامل)',
                                  '$quotedParts/$totalParts Full')
                              : _t(
                                  isArabic,
                                  '$quotedParts من أصل $totalParts قطع',
                                  '$quotedParts of $totalParts parts'),
                          style: GoogleFonts.cairo(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isFullQuote
                                ? AppPalette.success
                                : AppPalette.secondary,
                          ),
                        ),
                      ],
                    ),

                    // Warranty
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.shield_outlined,
                            size: 13, color: AppPalette.success),
                        const SizedBox(width: 3),
                        Text(
                          warranty,
                          style: GoogleFonts.cairo(
                            fontSize: 11,
                            color: textSecondary(isDark),
                          ),
                        ),
                      ],
                    ),

                    // Delivery Time
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_shipping_outlined,
                            size: 13, color: AppPalette.secondary),
                        const SizedBox(width: 3),
                        Text(
                          deliveryTime,
                          style: GoogleFonts.cairo(
                            fontSize: 11,
                            color: textSecondary(isDark),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 2.5 Highly Professional Action Buttons with Floating Count Badge
                Row(
                  children: [
                    // Button 1: View Quote Details (عرض تفاصيل العرض)
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppPalette.primary, Color(0xFF1E3A8A)],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppPalette.primary.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () =>
                              _showQuoteDetailsModal(quote, isArabic, isDark),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.visibility_rounded,
                                  size: 17, color: Colors.white),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  _t(isArabic, 'تفاصيل العرض', 'View Details'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.cairo(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Button 2: View Other Quotes for Request (with Floating Count Badge)
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppPalette.secondary.withOpacity(0.12)
                                  : AppPalette.secondary.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppPalette.secondary.withOpacity(0.5),
                                width: 1.3,
                              ),
                            ),
                            child: OutlinedButton(
                              onPressed: () => _showOtherQuotesModal(
                                  requestId,
                                  (quote['id'] ?? '').toString(),
                                  isArabic,
                                  isDark),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide.none,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.compare_arrows_rounded,
                                      size: 17, color: AppPalette.secondary),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      _t(isArabic, 'العروض الأخرى للطلب',
                                          'Other Quotes'),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.cairo(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.bold,
                                        color: AppPalette.secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Floating Professional Badge showing Count of Available Quotes for this Request
                          Positioned(
                            top: -8,
                            right: isArabic ? null : 8,
                            left: isArabic ? 8 : null,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppPalette.accent,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.white, width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppPalette.accent.withOpacity(0.4),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.layers_rounded,
                                      size: 11, color: Colors.white),
                                  const SizedBox(width: 3),
                                  Text(
                                    _t(
                                        isArabic,
                                        '$totalQuotesForThisRequest عروض',
                                        '$totalQuotesForThisRequest Quotes'),
                                    style: GoogleFonts.cairo(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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

  /// Modal 1: View Detailed Breakdown of Quote (عرض تفاصيل العرض - الملاحظات تفصيلية هنا)
  void _showQuoteDetailsModal(
      Map<String, dynamic> quote, bool isArabic, bool isDark) {
    final List<dynamic> items = (quote['items'] as List<dynamic>?) ?? [];
    final int quotedParts = (quote['quotedPartsCount'] as num?)?.toInt() ?? 1;
    final int totalParts = (quote['totalPartsCount'] as num?)?.toInt() ?? 1;
    final bool isFullQuote = quotedParts == totalParts;

    final String requestId = (quote['requestId'] ?? '').toString();
    final String shopId = (quote['shopId'] ?? '').toString();
    final String shopLocation = (quote['shopLocation'] ?? '').toString();
    final String warranty = (quote['warranty'] ?? '').toString();
    final String deliveryTime = (quote['deliveryTime'] ?? '').toString();
    final String currency = (quote['currency'] ?? 'ر.س').toString();
    final String notes = (quote['notes'] ?? '').toString();
    final double price = (quote['price'] as num?)?.toDouble() ?? 0.0;
    final String quoteId = (quote['id'] ?? '').toString();

    showResponsiveBottomSheet(
      context: context,
      maxWidth: 600,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg(isDark),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Modal Header Title & Request ID
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _t(isArabic, 'تفاصيل عرض السعر', 'Quote Details'),
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textPrimary(isDark),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppPalette.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        requestId,
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppPalette.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Merchant Details (ONLY Shop ID & Location with Country)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.04)
                        : Colors.grey.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.storefront_rounded,
                                  size: 18, color: AppPalette.primary),
                              const SizedBox(width: 6),
                              Text(
                                _t(isArabic, 'معرّف المورد:', 'Supplier ID:'),
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  color: textSecondary(isDark),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppPalette.primary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  shopId,
                                  style: GoogleFonts.cairo(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppPalette.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded,
                              size: 16, color: AppPalette.accent),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              shopLocation,
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                color: textSecondary(isDark),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Quoted Parts Summary Banner
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isFullQuote
                        ? AppPalette.success.withOpacity(0.12)
                        : AppPalette.secondary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isFullQuote
                          ? AppPalette.success.withOpacity(0.4)
                          : AppPalette.secondary.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isFullQuote
                            ? Icons.task_alt_rounded
                            : Icons.inventory_2_rounded,
                        color: isFullQuote
                            ? AppPalette.success
                            : AppPalette.secondary,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isFullQuote
                                  ? _t(
                                      isArabic,
                                      'عرض شامل لكافة قطع الطلب ($quotedParts/$totalParts)',
                                      'Full Order Coverage Quote ($quotedParts/$totalParts)')
                                  : _t(
                                      isArabic,
                                      'عرض جزئي لبعض قطع الطلب ($quotedParts/$totalParts)',
                                      'Partial Order Coverage Quote ($quotedParts/$totalParts)'),
                              style: GoogleFonts.cairo(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isFullQuote
                                    ? AppPalette.success
                                    : AppPalette.secondary,
                              ),
                            ),
                            Text(
                              _t(
                                isArabic,
                                'تم تسعير $quotedParts قطع من أصل $totalParts قطع تم طلبها',
                                '$quotedParts of total $totalParts requested items are quoted',
                              ),
                              style: GoogleFonts.cairo(
                                fontSize: 11.5,
                                color: textSecondary(isDark),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Breakdown of items included in the quote
                Text(
                  _t(isArabic, 'قائمة القطع المشمولة بالعرض:',
                      'Included Items Breakdown:'),
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textPrimary(isDark),
                  ),
                ),
                const SizedBox(height: 10),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, idx) {
                    final item = items[idx] as Map<String, dynamic>;
                    final itemName = (item['name'] ?? '').toString();
                    final itemCondition = (item['condition'] ?? '').toString();
                    final itemPrice =
                        (item['price'] as num?)?.toDouble() ?? 0.0;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.03)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: cardBorder(isDark)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: AppPalette.primary.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${idx + 1}',
                                    style: GoogleFonts.cairo(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppPalette.primary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    itemName,
                                    style: GoogleFonts.cairo(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: textPrimary(isDark),
                                    ),
                                  ),
                                  Text(
                                    itemCondition,
                                    style: GoogleFonts.cairo(
                                      fontSize: 11,
                                      color: textSecondary(isDark),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            '$itemPrice $currency',
                            style: GoogleFonts.cairo(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: AppPalette.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Merchant Notes Box inside modal
                if (notes.isNotEmpty) ...[
                  Text(
                    _t(isArabic, 'ملاحظات وتوصيات المورد:', 'Merchant Notes:'),
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: textPrimary(isDark),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.04)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: cardBorder(isDark)),
                    ),
                    child: Text(
                      notes,
                      style: GoogleFonts.cairo(
                        fontSize: 12.5,
                        color: textSecondary(isDark),
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Terms & Delivery Summary
                Row(
                  children: [
                    Expanded(
                      child: _buildModalInfoTile(
                        icon: Icons.verified_user_outlined,
                        title: _t(isArabic, 'الضمان الموفر', 'Warranty'),
                        subtitle: warranty,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildModalInfoTile(
                        icon: Icons.local_shipping_outlined,
                        title: _t(isArabic, 'وقت التوصيل', 'Delivery Time'),
                        subtitle: deliveryTime,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Total Price Summary Container
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppPalette.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: AppPalette.primary.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _t(isArabic, 'الإجمالي الكلي للعرض:',
                            'Total Quote Amount:'),
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textPrimary(isDark),
                        ),
                      ),
                      Text(
                        '$price $currency',
                        style: GoogleFonts.cairo(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppPalette.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Decision Action Buttons inside Modal
                Row(
                  children: [
                    // Accept Button
                    Expanded(
                      flex: 6,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _acceptQuote(quoteId, isArabic);
                        },
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

                    // Dismiss Button
                    Expanded(
                      flex: 4,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _dismissQuote(quoteId, isArabic);
                        },
                        icon: const Icon(Icons.close_rounded,
                            size: 18, color: AppPalette.danger),
                        label: Text(
                          _t(isArabic, 'إستبعاد العرض', 'Dismiss'),
                          style: GoogleFonts.cairo(
                            fontSize: 12.5,
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
        );
      },
    );
  }

  Widget _buildModalInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.04)
            : Colors.grey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppPalette.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 10.5,
                    color: textSecondary(isDark),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
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

  /// Modal 2: View Other Quotes Received for the Same Request (عرض العروض الأخرى للطلب)
  void _showOtherQuotesModal(
      String requestId, String currentQuoteId, bool isArabic, bool isDark) {
    // Find all quotes for this request ID
    final otherQuotes = _receivedQuotes
        .where((q) => q['requestId'] == requestId && q['status'] == 'pending')
        .toList();

    showResponsiveBottomSheet(
      context: context,
      maxWidth: 650,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg(isDark),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Title & Count Banner
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _t(isArabic, 'العروض المقدمة للطلب',
                            'Quotes Received for Order'),
                        style: GoogleFonts.cairo(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: textPrimary(isDark),
                        ),
                      ),
                      Text(
                        _t(
                          isArabic,
                          'مقارنة العروض البديلة المقدمة لهذا الطلب',
                          'Compare competing merchant offers for $requestId',
                        ),
                        style: GoogleFonts.cairo(
                          fontSize: 11.5,
                          color: textSecondary(isDark),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppPalette.accent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${otherQuotes.length} ${_t(isArabic, 'عروض', 'Quotes')}',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppPalette.accent,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Quotes comparative list
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: otherQuotes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final q = otherQuotes[index];
                    final String qId = (q['id'] ?? '').toString();
                    final bool isCurrent = qId == currentQuoteId;
                    final String qPartType = (q['partType'] ?? '').toString();
                    final bool isNew = qPartType == 'new';
                    final int quotedParts =
                        (q['quotedPartsCount'] as num?)?.toInt() ?? 1;
                    final int totalParts =
                        (q['totalPartsCount'] as num?)?.toInt() ?? 1;

                    final String qShopId = (q['shopId'] ?? '').toString();
                    final String qShopLoc =
                        (q['shopLocation'] ?? '').toString();
                    final String qPartName = (q['partName'] ?? '').toString();
                    final String qWarranty = (q['warranty'] ?? '').toString();
                    final String qCurrency =
                        (q['currency'] ?? 'ر.س').toString();
                    final double qPrice =
                        (q['price'] as num?)?.toDouble() ?? 0.0;

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? AppPalette.primary.withOpacity(0.08)
                            : (isDark
                                ? Colors.white.withOpacity(0.03)
                                : Colors.grey.withOpacity(0.06)),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isCurrent
                              ? AppPalette.primary
                              : cardBorder(isDark),
                          width: isCurrent ? 1.8 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  // Shop ID Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppPalette.secondary
                                          .withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      qShopId,
                                      style: GoogleFonts.cairo(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: AppPalette.secondary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(Icons.location_on_outlined,
                                      size: 13, color: textSecondary(isDark)),
                                  const SizedBox(width: 2),
                                  Text(
                                    qShopLoc,
                                    style: GoogleFonts.cairo(
                                      fontSize: 11,
                                      color: textSecondary(isDark),
                                    ),
                                  ),
                                ],
                              ),
                              if (isCurrent)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppPalette.primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _t(isArabic, 'العرض الحالي', 'Current'),
                                    style: GoogleFonts.cairo(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      qPartName,
                                      style: GoogleFonts.cairo(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                        color: textPrimary(isDark),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _t(
                                        isArabic,
                                        'تغطية $quotedParts من إجمالي $totalParts قطع مطلوبة • $qWarranty',
                                        'Covers $quotedParts of total $totalParts parts • $qWarranty',
                                      ),
                                      style: GoogleFonts.cairo(
                                        fontSize: 11,
                                        color: textSecondary(isDark),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '$qPrice $qCurrency',
                                    style: GoogleFonts.cairo(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppPalette.primary,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isNew
                                          ? AppPalette.success.withOpacity(0.12)
                                          : AppPalette.accent.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      isNew
                                          ? _t(
                                              isArabic, 'جديد وكالة', 'OEM New')
                                          : _t(isArabic, 'تشليح', 'Scrapy'),
                                      style: GoogleFonts.cairo(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: isNew
                                            ? AppPalette.success
                                            : AppPalette.accent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                _showQuoteDetailsModal(q, isArabic, isDark);
                              },
                              style: OutlinedButton.styleFrom(
                                side:
                                    const BorderSide(color: AppPalette.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                              ),
                              child: Text(
                                _t(isArabic, 'معاينة تفاصيل هذا العرض',
                                    'View Details for this Quote'),
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppPalette.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cardBg(isDark),
                    elevation: 0,
                    side: BorderSide(color: cardBorder(isDark)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _t(isArabic, 'إغلاق', 'Close'),
                    style: GoogleFonts.cairo(
                      color: textPrimary(isDark),
                      fontWeight: FontWeight.bold,
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
            _t(isArabic, 'لا توجد عروض أسعار مطابقة',
                'No Matching Price Quotes'),
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
                'جرب البحث بكلمات أخرى أو تغيير إعدادات الفلترة لإظهار باقي عروض المحلات',
                'Try searching with different terms or reset filters to display merchant price quotes',
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
