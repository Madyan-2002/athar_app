import 'package:flutter/material.dart';
import 'package:alkher/styles/app_colors.dart';

class DonationFieldsWidget extends StatelessWidget {
  final Color accent;
  final TextEditingController targetAmountController;
  final DateTime? deadline;
  final VoidCallback onPickDeadline;

  const DonationFieldsWidget({
    super.key,
    required this.accent,
    required this.targetAmountController,
    required this.deadline,
    required this.onPickDeadline,
  });

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildField(
            label: 'المبلغ المستهدف',
            hint: '0.00',
            controller: targetAmountController,
            prefix: '\$ ',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 14),
          Text(
            'آخر موعد',
            style: TextStyle(fontSize: 12.5, color: accent, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 7),
          FormField<DateTime>(
            initialValue: deadline,
            validator: (_) =>
                deadline == null ? 'الرجاء اختيار التاريخ النهائي' : null,
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: onPickDeadline,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.045),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: state.hasError
                              ? AppColors.error
                              : accent.withOpacity(0.35),
                          width: 1.4,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 18, color: accent),
                          const SizedBox(width: 10),
                          Text(
                            deadline == null
                                ? 'اختر التاريخ'
                                : '${deadline!.day}/${deadline!.month}/${deadline!.year}',
                            style: TextStyle(
                              color: deadline == null
                                  ? AppColors.textHint
                                  : AppColors.textPrimary,
                              fontSize: 14.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, right: 8),
                      child: Text(
                        state.errorText!,
                        style: const TextStyle(color: AppColors.error, fontSize: 12),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? prefix,
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
          keyboardType: keyboardType,
          validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14.5),
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
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
          ),
        ),
      ],
    );
  }
}