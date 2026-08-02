import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class SubmitQuoteBottomSheet extends StatefulWidget {
  final VoidCallback onQuoteSubmitted;
  final String orderTitle;
  final String? initialPrice;
  final String? initialDelivery;
  final bool isEditing;

  const SubmitQuoteBottomSheet({
    super.key,
    required this.onQuoteSubmitted,
    required this.orderTitle,
    this.initialPrice,
    this.initialDelivery,
    this.isEditing = false,
  });

  @override
  State<SubmitQuoteBottomSheet> createState() => _SubmitQuoteBottomSheetState();
}

class _SubmitQuoteBottomSheetState extends State<SubmitQuoteBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _priceController;
  late final TextEditingController _timeController;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: widget.initialPrice ?? '');
    _timeController = TextEditingController(text: widget.initialDelivery ?? '');
  }

  @override
  void dispose() {
    _priceController.dispose();
    _timeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(20, 8, 20, bottomPadding + 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 42,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            // Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppPalette.accent.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.isEditing ? Icons.edit_rounded : Icons.send_rounded,
                    color: AppPalette.accent,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isEditing ? 'تعديل عرض السعر' : 'تقديم عرض السعر',
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppPalette.primary,
                        ),
                      ),
                      Text(
                        widget.orderTitle,
                        style: GoogleFonts.cairo(fontSize: 13, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Price Field
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'يرجى إدخال السعر' : null,
              style: GoogleFonts.cairo(),
              decoration: InputDecoration(
                labelText: 'السعر المقترح (ر.س)',
                labelStyle: GoogleFonts.cairo(),
                hintText: 'مثال: 450',
                hintStyle: GoogleFonts.cairo(),
                prefixIcon: const Icon(Icons.attach_money_rounded,
                    color: AppPalette.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppPalette.primary, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Delivery Time Field
            TextFormField(
              controller: _timeController,
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'يرجى إدخال وقت التوصيل' : null,
              style: GoogleFonts.cairo(),
              decoration: InputDecoration(
                labelText: 'وقت التوصيل',
                labelStyle: GoogleFonts.cairo(),
                hintText: 'مثال: خلال 24 ساعة، يومان...',
                hintStyle: GoogleFonts.cairo(),
                prefixIcon: const Icon(Icons.local_shipping_rounded,
                    color: AppPalette.accent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppPalette.accent, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Notes Field (optional)
            TextFormField(
              controller: _notesController,
              maxLines: 2,
              style: GoogleFonts.cairo(),
              decoration: InputDecoration(
                labelText: 'ملاحظات إضافية (اختياري)',
                labelStyle: GoogleFonts.cairo(),
                hintText: 'مثال: قطعة أصلية، ضمان سنة...',
                hintStyle: GoogleFonts.cairo(),
                prefixIcon: const Icon(Icons.notes_rounded, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onQuoteSubmitted();
                    Navigator.pop(context);
                  }
                },
                icon: Icon(
                  widget.isEditing ? Icons.check_rounded : Icons.send_rounded,
                  size: 20,
                ),
                label: Text(
                  widget.isEditing ? 'حفظ التعديلات' : 'تأكيد وإرسال العرض',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
