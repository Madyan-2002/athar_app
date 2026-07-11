import 'package:alkher/providers/product_provider.dart';
import 'package:alkher/screens/user/widgets/custom_card.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  static const _type = 'job';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'الوظائف',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
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
                    Text(provider.errorFor(_type) ?? 'خطأ'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => provider.fetchByType(_type),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );

            case LoadStatus.loaded:
              final jobs = provider.productsFor(_type);

              if (jobs.isEmpty) {
                return const Center(child: Text('لا توجد وظائف حالياً'));
              }

              return RefreshIndicator(
                onRefresh: () => provider.refresh(_type),
                child: SafeArea(
                  bottom: true,
                  top: false,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: jobs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.72,
                        ),
                    itemBuilder: (context, index) {
                      return CustomCard(product: jobs[index]);
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
