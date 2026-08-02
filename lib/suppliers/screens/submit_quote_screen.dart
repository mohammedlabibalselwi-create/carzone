import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class SubmitQuoteScreen extends StatefulWidget {
  final String orderId;
  final String carType;
  final String carModel;
  final String partName;

  const SubmitQuoteScreen({
    super.key,
    required this.orderId,
    required this.carType,
    required this.carModel,
    required this.partName,
  });

  @override
  State<SubmitQuoteScreen> createState() => _SubmitQuoteScreenState();
}

class _SubmitQuoteScreenState extends State<SubmitQuoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedCurrency = 'YER';
  String _selectedCondition = 'جديد';
  String _selectedQuality = 'وكالة';
  final List<String> _attachedImages = [];

  @override
  void dispose() {
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7F9),

        // ─── AppBar ───
        appBar: AppBar(
          backgroundColor: AppPalette.primary,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            'تقديم عرض سعر',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        // ─── Fixed Submit Button at Bottom ───
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _submitQuote,
                icon: const Icon(Icons.send_rounded, size: 20),
                label: Text(
                  'إرسال العرض',
                  style: GoogleFonts.cairo(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.accent,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
        ),

        // ─── Scrollable Body ───
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            physics: const BouncingScrollPhysics(),
            children: [
              // ════════════════════════════════════
              // 1. Order Details Card
              // ════════════════════════════════════
              _buildSectionTitle(
                icon: Icons.receipt_long_rounded,
                label: 'تفاصيل الطلب',
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppPalette.primary.withValues(alpha: 0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppPalette.primary.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildOrderDetailRow(
                      icon: Icons.tag_rounded,
                      label: 'رقم الطلب',
                      value: widget.orderId,
                      isId: true,
                    ),
                    _buildDivider(),
                    _buildOrderDetailRow(
                      icon: Icons.directions_car_rounded,
                      label: 'السيارة',
                      value: '${widget.carType} - ${widget.carModel}',
                    ),
                    _buildDivider(),
                    _buildOrderDetailRow(
                      icon: Icons.build_rounded,
                      label: 'القطعة المطلوبة',
                      value: widget.partName,
                      isHighlighted: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ════════════════════════════════════
              // 2. Financial Details
              // ════════════════════════════════════
              _buildSectionTitle(
                icon: Icons.account_balance_wallet_rounded,
                label: 'بيانات العرض المالي',
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Price Field (flex 2)
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppPalette.primary,
                        ),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'أدخل السعر' : null,
                        decoration: _inputDecoration(
                          label: 'السعر المقترح',
                          hint: 'أدخل السعر',
                          prefixIcon: Icons.attach_money_rounded,
                          prefixColor: AppPalette.accent,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Currency Dropdown (flex 1)
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        value: _selectedCurrency,
                        isExpanded: true,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: AppPalette.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: _inputDecoration(
                          label: 'العملة',
                          hint: '',
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'YER',
                            child: Text('ريال يمني', style: GoogleFonts.cairo(fontSize: 13)),
                          ),
                          DropdownMenuItem(
                            value: 'SAR',
                            child: Text('ريال سعودي', style: GoogleFonts.cairo(fontSize: 13)),
                          ),
                          DropdownMenuItem(
                            value: 'USD',
                            child: Text('دولار أمريكي', style: GoogleFonts.cairo(fontSize: 13)),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => _selectedCurrency = v!),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ════════════════════════════════════
              // 3. Part Specifications
              // ════════════════════════════════════
              _buildSectionTitle(
                icon: Icons.tune_rounded,
                label: 'مواصفات القطعة المعروضة',
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Condition Dropdown
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCondition,
                        isExpanded: true,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: AppPalette.primary,
                        ),
                        decoration: _inputDecoration(
                          label: 'حالة القطعة',
                          hint: '',
                          prefixIcon: Icons.fiber_new_rounded,
                          prefixColor: AppPalette.success,
                        ),
                        items: ['جديد', 'تشليح']
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e,
                                      style: GoogleFonts.cairo(fontSize: 13)),
                                ))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _selectedCondition = v!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Quality Dropdown
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedQuality,
                        isExpanded: true,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: AppPalette.primary,
                        ),
                        decoration: _inputDecoration(
                          label: 'جودة القطعة',
                          hint: '',
                          prefixIcon: Icons.star_rounded,
                          prefixColor: AppPalette.accent,
                        ),
                        items: ['وكالة', 'تايوان', 'صيني', 'محلي', 'آخر']
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e,
                                      style: GoogleFonts.cairo(fontSize: 13)),
                                ))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _selectedQuality = v!),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ════════════════════════════════════
              // 4. Photo Upload + Notes
              // ════════════════════════════════════
              _buildSectionTitle(
                icon: Icons.camera_alt_rounded,
                label: 'مرفقات إضافية (اختياري)',
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dashed Upload Area
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        decoration: BoxDecoration(
                          color: AppPalette.primary.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppPalette.primary.withValues(alpha: 0.3),
                            width: 1.5,
                            strokeAlign: BorderSide.strokeAlignInside,
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppPalette.primary.withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add_a_photo_rounded,
                                size: 34,
                                color: AppPalette.primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'اضغط لإرفاق صور للقطعة',
                              style: GoogleFonts.cairo(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppPalette.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'حتى 6 صور • JPG, PNG',
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Attached Images Grid (if any)
                    if (_attachedImages.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _attachedImages.asMap().entries.map((e) {
                          return Stack(
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: AppPalette.primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: AppPalette.primary
                                          .withValues(alpha: 0.2)),
                                ),
                                child: const Icon(Icons.image_rounded,
                                    color: AppPalette.primary),
                              ),
                              Positioned(
                                top: 2,
                                left: 2,
                                child: GestureDetector(
                                  onTap: () => setState(() =>
                                      _attachedImages.removeAt(e.key)),
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: AppPalette.danger,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close,
                                        size: 12, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],

                    const SizedBox(height: 16),

                    // Notes Field
                    TextFormField(
                      controller: _notesController,
                      maxLines: 4,
                      style: GoogleFonts.cairo(fontSize: 14),
                      decoration: InputDecoration(
                        labelText: 'ملاحظات للعميل',
                        labelStyle: GoogleFonts.cairo(
                          color: textSecondary(false),
                          fontSize: 14,
                        ),
                        hintText:
                            'مثال: السعر يشمل الضريبة، القطعة بضمان 6 شهور...',
                        hintStyle: GoogleFonts.cairo(
                          fontSize: 13,
                          color: Colors.grey.shade400,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: AppPalette.primary, width: 2),
                        ),
                        contentPadding: const EdgeInsets.all(14),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Helpers ───

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    IconData? prefixIcon,
    Color? prefixColor,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.cairo(fontSize: 13, color: Colors.grey.shade600),
      hintText: hint,
      hintStyle: GoogleFonts.cairo(fontSize: 13, color: Colors.grey.shade400),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, size: 20, color: prefixColor ?? AppPalette.primary)
          : null,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppPalette.primary, width: 2),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  Widget _buildSectionTitle({required IconData icon, required String label}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppPalette.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppPalette.primary, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppPalette.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isId = false,
    bool isHighlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppPalette.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 17, color: AppPalette.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
                if (isId)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppPalette.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      value,
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                else
                  Text(
                    value,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: isHighlighted
                          ? FontWeight.bold
                          : FontWeight.w600,
                      color: isHighlighted
                          ? AppPalette.accent
                          : AppPalette.primary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey.shade100,
        indent: 16,
        endIndent: 16,
      );

  void _pickImage() {
    if (_attachedImages.length < 6) {
      setState(() => _attachedImages.add('image_${_attachedImages.length}'));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم إرفاق صورة (${_attachedImages.length}/6)',
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: AppPalette.success,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _submitQuote() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (ctx) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            icon: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppPalette.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: AppPalette.success, size: 40),
            ),
            title: Text('تم إرسال العرض!',
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
            content: Text(
              'تم إرسال عرض سعرك بنجاح للطلب ${widget.orderId}. سيتم إشعارك عند رد العميل.',
              style: GoogleFonts.cairo(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: Text('حسناً',
                    style: GoogleFonts.cairo(
                        color: AppPalette.primary,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    }
  }
}

