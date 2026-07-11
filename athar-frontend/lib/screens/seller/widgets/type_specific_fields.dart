import 'package:flutter/material.dart';
import 'package:alkher/models/category_model.dart';

// استيراد الـ Widgets الفرعية الجديدة
import 'sell_fields_widget.dart';
import 'donation_fields_widget.dart';
import 'job_fields_widget.dart';

class TypeSpecificFields extends StatelessWidget {
  final String selectedType;
  final Color accent;

  // حقول البيع
  final TextEditingController priceController;
  final TextEditingController stockController;
  final List<CategoryModel> categories;
  final CategoryModel? selectedCategory;
  final ValueChanged<CategoryModel?> onCategoryChanged;
  final VoidCallback onCategoryAdded;

  // حقول التبرع
  final TextEditingController targetAmountController;
  final DateTime? deadline;
  final VoidCallback onPickDeadline;

  // حقول الوظيفة
  final TextEditingController salaryController;
  final TextEditingController locationController;

  const TypeSpecificFields({
    super.key,
    required this.selectedType,
    required this.accent,
    required this.priceController,
    required this.stockController,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.targetAmountController,
    required this.deadline,
    required this.onPickDeadline,
    required this.salaryController,
    required this.locationController,
    required this.onCategoryAdded,
  });

  @override
  Widget build(BuildContext context) {
    switch (selectedType) {
      case 'sell':
        return SellFieldsWidget(
          key: const ValueKey('sell_widget'),
          accent: accent,
          priceController: priceController,
          stockController: stockController,
          categories: categories,
          selectedCategory: selectedCategory,
          onCategoryChanged: onCategoryChanged,
          onCategoryAdded: onCategoryAdded ,
        );
      case 'donation':
        return DonationFieldsWidget(
          key: const ValueKey('donation_widget'),
          accent: accent,
          deadline: deadline,
          onPickDeadline: onPickDeadline,
          targetAmountController: targetAmountController,
        );
      case 'job':
        return JobFieldsWidget(
          key: const ValueKey('job_widget'),
          accent: accent,
          salaryController: salaryController,
          locationController: locationController,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
