
// ═══════════════════════════════════════════════
// قسم "أحدث الإعلانات" — سحب أفقي من بيانات حقيقية
// ═══════════════════════════════════════════════
import 'package:alkher/providers/product_provider.dart';
import 'package:alkher/screens/user/widgets/custom_card.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        final products = provider.allProductsCombined;
        final isLoading = ProductProvider.allTypes.any(
          (t) =>
              provider.statusFor(t) == LoadStatus.loading ||
              provider.statusFor(t) == LoadStatus.initial,
        );

        if (isLoading) {
          return const SizedBox(
            height: 220,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (products.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: Text(
                'لا توجد إعلانات بعد',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          );
        }

        final recent = products.take(10).toList();

        return SizedBox(
          height: 232,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            itemCount: recent.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) =>
                SizedBox(width: 150, child: CustomCard(product: recent[index])),
          ),
        );
      },
    );
  }
}
