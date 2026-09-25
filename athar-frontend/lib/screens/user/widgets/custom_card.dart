import 'package:alkher/models/product_model.dart';
import 'package:alkher/providers/favorite_provider.dart';
import 'package:alkher/screens/seller/widgets/product_card.dart';
import 'package:alkher/screens/user/product_details_screen.dart';
import 'package:alkher/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomCard extends StatelessWidget {
  final ProductModel product;

  const CustomCard({super.key, required this.product});

  String? _valueText() {
    switch (product.type) {
      case 'sell':
        return product.price != null
            ? '\$${product.price!.toStringAsFixed(2)}'
            : null;
      case 'job':
        return product.salary != null
            ? '\$${product.salary!.toStringAsFixed(0)} / شهريًا'
            : null;
      case 'donation':
        return product.targetAmount != null
            ? 'الهدف: \$${product.targetAmount!.toStringAsFixed(0)}'
            : null;
      default:
        return null;
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
        return Colors.grey.shade600;
    }
  }

  String _typeLabel() {
    switch (product.type) {
      case 'sell':
        return 'للبيع';
      case 'donation':
        return 'تبرع';
      case 'job':
        return 'وظيفة';
      default:
        return 'أخرى';
    }
  }

  @override
  Widget build(BuildContext context) {
    final valueText = _valueText();
    final typeColor = _typeColor();
    final isFavorite = context.select<FavoriteProvider, bool>(
      (p) => p.isFavorite(product.id),
    );

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailsScreen(product: product),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // الصورة
                  product.images.isNotEmpty
                      ? Image.network(
                          ProductCard.getImageUrl(product.images.first),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _ImagePlaceholder(
                            icon: Icons.image_not_supported_outlined,
                          ),
                        )
                      : const _ImagePlaceholder(icon: Icons.image_outlined),

                  // تدرج خفيف أسفل الصورة يحسّن وضوح شارة النوع
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 44,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0),
                            Colors.black.withOpacity(0.35),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // شارة نوع الإعلان
                  Positioned(
                    bottom: 8,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _typeLabel(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // زر المفضلة
                  Positioned(
                    top: 10,
                    right: 10,
                    child: _FavoriteButton(
                      isFavorite: isFavorite,
                      onTap: () =>
                          context.read<FavoriteProvider>().toggle(product.id),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (valueText != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      valueText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: typeColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Center(
        child: Icon(icon, color: AppColors.textHint, size: 32),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.isFavorite, required this.onTap});

  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Icon(
            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            key: ValueKey(isFavorite),
            size: 17,
            color: isFavorite ? AppColors.error : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}