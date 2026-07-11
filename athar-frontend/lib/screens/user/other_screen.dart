import 'package:alkher/providers/product_provider.dart';
import 'package:alkher/screens/user/widgets/custom_card.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtherScreen extends StatefulWidget {
  const OtherScreen({super.key});

  @override
  State<OtherScreen> createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {
  static const _type = 'other';

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
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'أخرى',
          style: TextStyle(
            color: AppColors.textOnPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          final status = provider.statusFor(_type);

          switch (status) {
            case LoadStatus.initial:
            case LoadStatus.loading:
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );

            case LoadStatus.error:
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.wifi_off_rounded,
                      size: 50,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(height: 12),
                    Text(provider.errorFor(_type) ?? 'حدث خطأ'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.fetchByType(_type),
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
                      Icon(
                        Icons.category_outlined,
                        size: 60,
                        color: AppColors.textHint,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'لا توجد إعلانات حالياً',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => provider.refresh(_type),
                child: SafeArea(
                  bottom: true,
                  top: false,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.72,
                        ),
                    itemCount: products.length,
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
