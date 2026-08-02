import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class SupplierStatisticsScreen extends StatefulWidget {
  const SupplierStatisticsScreen({super.key});

  @override
  State<SupplierStatisticsScreen> createState() => _SupplierStatisticsScreenState();
}

class _SupplierStatisticsScreenState extends State<SupplierStatisticsScreen> {
  String _selectedPeriod = 'يومية';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPeriodToggle(),
            const SizedBox(height: 24),
            _buildSalesSummary(),
            const SizedBox(height: 24),
            const Text(
              'نظرة عامة على الطلبات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildOrdersOverview(),
            const SizedBox(height: 24),
            const Text(
              'أكثر القطع طلباً',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildTopProducts(),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodToggle() {
    return Center(
      child: ToggleButtons(
        isSelected: [
          _selectedPeriod == 'يومية',
          _selectedPeriod == 'أسبوعية',
          _selectedPeriod == 'شهرية',
        ],
        onPressed: (index) {
          setState(() {
            _selectedPeriod = ['يومية', 'أسبوعية', 'شهرية'][index];
          });
        },
        borderRadius: BorderRadius.circular(8),
        selectedColor: Colors.white,
        fillColor: AppPalette.primary,
        color: AppPalette.primary,
        children: const [
          Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text('يومية')),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text('أسبوعية')),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text('شهرية')),
        ],
      ),
    );
  }

  Widget _buildSalesSummary() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [AppPalette.primary, AppPalette.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Column(
          children: [
            Text(
              'إجمالي الأرباح',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '4,250 ر.س',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'تم بيع 15 قطعة',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersOverview() {
    return Row(
      children: [
        _buildStatCard('مكتملة', '12', AppPalette.success),
        const SizedBox(width: 12),
        _buildStatCard('قيد التجهيز', '3', Colors.orange),
        const SizedBox(width: 12),
        _buildStatCard('ملغية', '1', AppPalette.danger),
      ],
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopProducts() {
    final topProducts = [
      'فحمات فرامل - تويوتا كامري',
      'فلتر زيت - هونداي سوناتا',
      'بواجي - نيسان التيما',
      'صدام أمامي - فورد تورس',
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: topProducts.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppPalette.badgeBg,
            child: Text(
              '${index + 1}',
              style: const TextStyle(color: AppPalette.primary, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(topProducts[index]),
          trailing: const Icon(Icons.trending_up, color: AppPalette.success),
        );
      },
    );
  }
}
