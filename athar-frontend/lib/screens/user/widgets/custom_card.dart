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

  @override
  Widget build(BuildContext context) {
    final valueText = _valueText();
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
      child: Card(
        elevation: 10, 
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.border.withOpacity(0.5), width: 1),
        ),
        clipBehavior: .antiAlias, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: product.images.isNotEmpty
                        ? Image.network(
                            ProductCard.getImageUrl(product.images.first),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.background,
                              child: const Icon(
                                Icons.image_not_supported_outlined,
                                color: AppColors.textHint,
                              ),
                            ),
                          )
                        : Container(
                            color: AppColors.background,
                            child: const Icon(
                              Icons.image_outlined,
                              color: AppColors.textHint,
                            ),
                          ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () =>
                          context.read<FavoriteProvider>().toggle(product.id),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: isFavorite
                              ? AppColors.error
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
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
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _typeColor(),
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