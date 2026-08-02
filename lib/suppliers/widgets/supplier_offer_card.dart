import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

enum OfferStatus { pending, accepted, rejected }

class SupplierOfferCard extends StatelessWidget {
  final String price;
  final String partDetails;
  final OfferStatus status;

  const SupplierOfferCard({
    super.key,
    required this.price,
    required this.partDetails,
    required this.status,
  });

  Color _getStatusColor() {
    switch (status) {
      case OfferStatus.pending:
        return Colors.orange; // Yellow/Orange for Pending
      case OfferStatus.accepted:
        return AppPalette.success; // Green for Accepted
      case OfferStatus.rejected:
        return AppPalette.danger; // Red for Rejected
    }
  }

  String _getStatusText() {
    switch (status) {
      case OfferStatus.pending:
        return 'قيد الانتظار';
      case OfferStatus.accepted:
        return 'مقبولة';
      case OfferStatus.rejected:
        return 'مرفوضة';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'السعر: $price ر.س',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppPalette.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'القطعة: $partDetails',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _getStatusColor()),
              ),
              child: Text(
                _getStatusText(),
                style: TextStyle(
                  color: _getStatusColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
