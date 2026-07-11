import 'package:flutter/material.dart';
import 'package:alkher/models/category_model.dart';
import 'package:alkher/services/category_service.dart';
import 'package:alkher/styles/app_colors.dart';

class SellFieldsWidget extends StatefulWidget {
  final Color accent;
  final TextEditingController priceController;
  final TextEditingController stockController;
  final List<CategoryModel> categories;
  final CategoryModel? selectedCategory;
  final ValueChanged<CategoryModel?> onCategoryChanged;
  final VoidCallback onCategoryAdded;

  const SellFieldsWidget({
    super.key,
    required this.accent,
    required this.priceController,
    required this.stockController,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onCategoryAdded,
  });

  @override
  State<SellFieldsWidget> createState() => _SellFieldsWidgetState();
}

class _SellFieldsWidgetState extends State<SellFieldsWidget> {
  bool _isAddingCategory = false;

  Future<void> _showAddCategoryDialog() async {
    final controller = TextEditingController();

    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('إضافة تصنيف جديد'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'مثلاً: كتب',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: Text('إضافة', style: TextStyle(color: widget.accent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (name == null || name.isEmpty) return;

    setState(() => _isAddingCategory = true);

    final success = await CategoryService().createCategory(name);

    if (!mounted) return;
    setState(() => _isAddingCategory = false);

    if (success) {
      widget.onCategoryAdded();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إضافة "$name" بنجاح'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل إضافة التصنيف'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildCard(
                children: [
                  _buildField(
                    label: 'السعر',
                    hint: '0.00',
                    controller: widget.priceController,
                    prefix: '\$ ',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCard(
                children: [
                  _buildField(
                    label: 'الكمية',
                    hint: '0',
                    controller: widget.stockController,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildCard(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'التصنيف',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: widget.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: _isAddingCategory ? null : _showAddCategoryDialog,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _isAddingCategory
                          ? SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2, color: widget.accent),
                            )
                          : Icon(Icons.add_circle_outline, size: 16, color: widget.accent),
                      const SizedBox(width: 4),
                      Text(
                        'إضافة تصنيف',
                        style: TextStyle(fontSize: 12, color: widget.accent, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            DropdownButtonFormField<CategoryModel>(
              value: widget.selectedCategory,
              hint: const Text('اختر التصنيف'),
              items: widget.categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                  .toList(),
              onChanged: widget.onCategoryChanged,
              validator: (val) => val == null ? 'الرجاء اختيار تصنيف' : null,
              decoration: _inputDecoration(),
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
    TextInputType keyboardType = TextInputType.text,
    String? prefix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            color: widget.accent,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14.5),
          decoration: _inputDecoration(prefix: prefix, hint: hint),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({String? prefix, String? hint}) {
    return InputDecoration(
      hintText: hint,
      prefixText: prefix,
      filled: true,
      fillColor: widget.accent.withOpacity(0.045),
      hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13.5),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: widget.accent.withOpacity(0.35), width: 1.4),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: widget.accent, width: 2),
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