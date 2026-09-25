import 'package:alkher/providers/product_provider.dart';
import 'package:alkher/screens/user/all_ads_screen.dart';
import 'package:alkher/screens/user/buy_screen.dart';
import 'package:alkher/screens/user/donation_screen.dart';
import 'package:alkher/screens/user/jobs_screen.dart';
import 'package:alkher/screens/user/other_screen.dart';
import 'package:alkher/screens/user/widgets/ad_section.dart';
import 'package:alkher/screens/user/widgets/big_category_card.dart';
import 'package:alkher/screens/user/widgets/header_home_screen.dart';
import 'package:alkher/screens/user/widgets/section_title.dart';
import 'package:alkher/screens/user/widgets/small_category_card.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchAllTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: HeaderHomeScreen()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(title: 'استكشف الأقسام'),
                    const SizedBox(height: 14),
                    _buildCategoriesLayout(context),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SectionTitle(title: 'أحدث الإعلانات'),
                        _ViewAllButton(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AllAdsScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: AdSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: BigCategoryCard(
            title: 'التبرعات',
            subtitle: 'ساهم بمبلغ أو غرض\nوكن جزءًا من الخير',
            icon: Icons.volunteer_activism_rounded,
            colors:  [AppColors.primaryDark, AppColors.primary],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DonationScreen()),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              SmallCategoryCard(
                title: 'الشراء',
                icon: Icons.shopping_bag_rounded,
                colors: const [Color(0xFF1976D2), Color(0xFF42A5F5)],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BuyScreen()),
                ),
              ),
              const SizedBox(height: 12),
              SmallCategoryCard(
                title: 'الوظائف',
                icon: Icons.work_rounded,
                colors: const [Color(0xFF6A1B9A), Color(0xFF9C27B0)],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const JobsScreen()),
                ),
              ),
              const SizedBox(height: 12),
              SmallCategoryCard(
                title: 'الاستكشاف',
                icon: Icons.explore_rounded,
                colors: const [Color(0xFFE65100), Color(0xFFFF9800)],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OtherScreen()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// زر "عرض الكل" — بشكل شريحة (pill) خفيفة بدل نص لينك عادي،
/// عشان يبين بوضوح إنه قابل للضغط
class _ViewAllButton extends StatelessWidget {
  const _ViewAllButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
               Text(
                'عرض الكل',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(width: 3),
               Icon(
                Icons.arrow_back_ios_rounded,
                size: 11,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}