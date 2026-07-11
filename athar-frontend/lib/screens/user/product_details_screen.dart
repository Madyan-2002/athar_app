import 'package:alkher/models/product_model.dart';
import 'package:alkher/providers/favorite_provider.dart';
import 'package:alkher/screens/seller/widgets/product_card.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:alkher/utils/whatsapp_launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;
  const ProductDetailsScreen({super.key, required this.product});

  String typeLabel() {
    switch (product.type) {
      case 'sell':
        return 'بيع';
      case 'donation':
        return 'تبرع';
      case 'job':
        return 'وظيفة';
      default:
        return 'أخرى';
    }
  }

  Color _typeColor() {
    switch (product.type) {
      case 'sell':
        return const Color(0xFF1976D2);
      case 'donation':
        return AppColors.primaryDark;
      case 'job':
        return const Color(0xFF6A1B9A);
      default:
        return const Color(0xFF4E7C59);
    }
  }

  String _ctaLabel() {
    switch (product.type) {
      case 'job':
        return 'تقديم على الوظيفة';
      case 'donation':
        return 'تواصل مع المتبرع'; // ← بدل "تبرع الآن"
      default:
        return 'تواصل مع البائع';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<FavoriteProvider, bool>(
      (p) => p.isFavorite(product.id),
    );
    final accent = _typeColor();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Header أخضر بالصورة + شريط علوي ملون ──
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  foregroundColor: AppColors.primaryDark,
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                  elevation: 0,
                ),
                child: const Icon(Icons.arrow_back, size: 20),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () =>
                      context.read<FavoriteProvider>().toggle(product.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    foregroundColor: isFavorite
                        ? AppColors.error
                        : AppColors.primaryDark,
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                    elevation: 0,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: AppColors.primaryDark),
                  product.images.isNotEmpty
                      ? Image.network(
                          ProductCard.getImageUrl(product.images.first),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.white38,
                            size: 60,
                          ),
                        )
                      : const Icon(
                          Icons.image_outlined,
                          color: Colors.white38,
                          size: 60,
                        ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.35),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ── المحتوى ──────────────────────────
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -10),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _DetailsSection(product: product, accent: accent),

                    const SizedBox(height: 20),

                    _SectionCard(
                      title: 'الوصف',
                      accent: accent,
                      child: Text(
                        product.description.isNotEmpty
                            ? product.description
                            : 'لا يوجد وصف',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.7,
                        ),
                      ),
                    ),

                    if (product.categoryName != null) ...[
                      const SizedBox(height: 14),
                      _SectionCard(
                        title: 'التصنيف',
                        accent: accent,
                        child: Row(
                          children: [
                            Icon(
                              Icons.category_outlined,
                              size: 16,
                              color: accent,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              product.categoryName!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    if (product.createdByName != null) ...[
                      const SizedBox(height: 14),
                      _SectionCard(
                        title: 'الناشر',
                        accent: accent,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: accent.withOpacity(0.12),
                              child: Icon(
                                Icons.person_outline,
                                color: accent,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              product.createdByName!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // ── شريط سفلي ثابت ──────────────────
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          MediaQuery.of(context).padding.bottom + 12,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            if (product.type == 'sell' && product.price != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '\$${product.price!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: accent,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final success = await WhatsappLauncher.open(
                    product.contactNumber,
                    message:
                        'مرحبًا، أنا مهتم بإعلانك "${product.title}" على تطبيق الخير',
                  );

                  if (!success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'تعذر فتح واتساب، تأكد من تثبيته على جهازك',
                        ),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _ctaLabel(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsSection extends StatelessWidget {
  final ProductModel product;
  final Color accent;

  const _DetailsSection({required this.product, required this.accent});

  @override
  Widget build(BuildContext context) {
    switch (product.type) {
      case 'sell':
        return Row(
          children: [
            Expanded(
              child: _StatBox(
                icon: Icons.sell_outlined,
                label: 'السعر',
                value: product.price != null
                    ? '\$${product.price!.toStringAsFixed(2)}'
                    : '—',
                accent: accent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatBox(
                icon: Icons.inventory_2_outlined,
                label: 'الكمية المتوفرة',
                value: '${product.stock ?? 0}',
                accent: accent,
              ),
            ),
          ],
        );

      case 'donation':
        return Row(
          children: [
            Expanded(
              child: _StatBox(
                icon: Icons.flag_outlined,
                label: 'المبلغ المستهدف',
                value: product.targetAmount != null
                    ? '\$${product.targetAmount!.toStringAsFixed(0)}'
                    : '—',
                accent: accent,
              ),
            ),
            if (product.deadline != null) ...[
              const SizedBox(width: 12),
              Expanded(
                child: _StatBox(
                  icon: Icons.calendar_today_outlined,
                  label: 'آخر موعد',
                  value:
                      '${product.deadline!.day}/${product.deadline!.month}/${product.deadline!.year}',
                  accent: accent,
                ),
              ),
            ],
          ],
        );

      case 'job':
        return Row(
          children: [
            Expanded(
              child: _StatBox(
                icon: Icons.attach_money,
                label: 'الراتب',
                value: product.salary != null
                    ? '\$${product.salary!.toStringAsFixed(0)}'
                    : '—',
                accent: accent,
              ),
            ),
            if (product.location != null && product.location!.isNotEmpty) ...[
              const SizedBox(width: 12),
              Expanded(
                child: _StatBox(
                  icon: Icons.location_on_outlined,
                  label: 'الموقع',
                  value: product.location!,
                  accent: accent,
                ),
              ),
            ],
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  const _StatBox({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: accent),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Color accent;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.accent,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: accent, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
