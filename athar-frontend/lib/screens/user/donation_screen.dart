import 'package:alkher/providers/product_provider.dart';
import 'package:alkher/screens/user/widgets/custom_card.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  static const _type = 'donation';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchByType(_type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textOnPrimary, size: 20),
        ),
        title: const Text(
          'التبرعات',
          style: TextStyle(
            color: AppColors.textOnPrimary, 
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppColors.border.withOpacity(0.2),
          ),
        ),
      ),

      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          final status = provider.statusFor(_type);
          switch (status) {
            case LoadStatus.loading:
            case LoadStatus.initial:
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );

            case LoadStatus.error:
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off_rounded, color: AppColors.textHint, size: 50),
                    const SizedBox(height: 12),
                    Text(
                      provider.errorFor(_type) ?? 'حدث خطأ أثناء التحميل',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.fetchByType(_type),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        foregroundColor: AppColors.textOnPrimary,
                      ),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );

            case LoadStatus.loaded:
              final products = provider.productsFor(_type);

              if (products.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.volunteer_activism_outlined, size: 56, color: AppColors.textHint),
                      SizedBox(height: 12),
                      Text(
                        'لا توجد حملات تبرع حالياً',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => provider.refresh(_type),
                // ── هنا الحل: استخدام SafeArea مخصص للأسفل فقط لحماية الكروت من أزرار النظام ──
                child: SafeArea(
                  top: false, // تعطيل الأعلى لأن الـ AppBar يتعامل معه
                  bottom: true, // تفعيل الأسفل ليدفع الكروت فوق أزرار الخروج والرجوع للهاتف
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24), // زيادة الحافة السفلية للراحة البصرية
                    itemCount: products.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) {
                      return CustomCard(product: products[index]);
                    },
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}