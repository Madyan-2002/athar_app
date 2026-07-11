import 'package:alkher/providers/product_provider.dart';
import 'package:alkher/screens/user/widgets/custom_card.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyScreen extends StatefulWidget {
  const BuyScreen({super.key});

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  static const _type = 'sell';

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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          'الشراء',
          style: TextStyle(
            color: AppColors.textOnPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryDark,
        centerTitle: true,
      ),

      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          final status = provider.statusFor(_type);

          switch (status) {
            case LoadStatus.loading:
            case LoadStatus.initial:
              return const Center(child: CircularProgressIndicator());

            case LoadStatus.error:
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 50),
                    const SizedBox(height: 10),
                    Text(provider.errorFor(_type) ?? 'حدث خطأ'),
                    const SizedBox(height: 10),
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
                return const Center(child: Text('لا توجد منتجات حالياً'));
              }

              return RefreshIndicator(
                onRefresh: () => provider.refresh(_type),

                child: SafeArea(
                  bottom: true,
                  top: false,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
