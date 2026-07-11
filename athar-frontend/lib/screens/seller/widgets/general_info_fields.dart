import 'package:flutter/material.dart';
import 'package:alkher/styles/app_colors.dart';

class GeneralInfoFields extends StatelessWidget {
  final Color accent;
  final TextEditingController nameController;
  final TextEditingController descController;
  final TextEditingController contactController;

  const GeneralInfoFields({
    super.key,
    required this.accent,
    required this.nameController,
    required this.descController,
    required this.contactController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCard(
          children: [
            _buildField(
              label: 'اسم الإعلان',
              hint: 'مثلاً:  ملابس',
              controller: nameController,
              validator: (val) =>
                  val == null || val.trim().isEmpty ? 'هذا الحقل مطلوب' : null,
            ),
            const SizedBox(height: 14),
            _buildField(
              label: 'الوصف',
              hint: 'اكتب تفاصيل أكثر...',
              controller: descController,
              maxLines: 3,
              maxLength: 300,
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildCard(
          children: [
            Row(
              children: [
                Icon(Icons.chat_outlined, size: 16, color: const Color(0xFF25D366)),
                const SizedBox(width: 6),
                Text(
                  'رقم التواصل (واتساب)',
                  style: TextStyle(fontSize: 12.5, color: accent, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 7),
            TextFormField(
              controller: contactController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14.5),
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'رقم التواصل مطلوب';
                final digitsOnly = val.replaceAll(RegExp(r'[^0-9]'), '');
                if (digitsOnly.length < 9) return 'الرجاء إدخال رقم صحيح مع رمز الدولة';
                return null;
              },
              decoration: _inputDecoration(
                hint: 'مثال: 962791234567 (بدون + أو 00)',
                accent: accent,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'أدخل الرقم مع رمز الدولة بدون + أو أصفار البداية',
              style: TextStyle(fontSize: 10.5, color: AppColors.textHint),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12.5, color: accent, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          validator: validator,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14.5),
          decoration: _inputDecoration(hint: hint, accent: accent, maxLength: maxLength),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required Color accent,
    int? maxLength,
  }) {
    return InputDecoration(
      hintText: hint,
      counterText: maxLength != null ? null : '',
      hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13.5),
      filled: true,
      fillColor: accent.withOpacity(0.045),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: accent.withOpacity(0.35), width: 1.4),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: accent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1.4),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}