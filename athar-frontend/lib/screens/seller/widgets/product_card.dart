import 'package:alkher/constants/api_constant.dart';
import 'package:alkher/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  const ProductCard({super.key, required this.product});

  static String getImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }

    if (imagePath.startsWith('/')) {
      imagePath = imagePath.substring(1);
    }

    String baseUrl = ApiConstant.baseUrl;
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }

    if (imagePath.contains('uploads')) {
      return '$baseUrl/$imagePath';
    }
    return '$baseUrl/uploads/$imagePath';
  }

  String _typeLabel() {
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
        return const Color(0xFF2E7D32);
      case 'job':
        return const Color(0xFF6A1B9A);
      default:
        return Colors.grey;
    }
  }

  Widget? _buildValueLabel() {
    switch (product.type) {
      case 'sell':
        if (product.price == null) return null;
        return Text(
          '\$${product.price!.toStringAsFixed(2)}',
          style: const TextStyle(
            color: Color(0xFF1A73E8),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        );

      case 'job':
        if (product.salary == null) return null;
        return Text(
          '\$${product.salary!.toStringAsFixed(0)} / شهريًا',
          style: const TextStyle(
            color: Color(0xFF6A1B9A),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        );

      case 'donation':
        if (product.targetAmount == null) return null;
        return Text(
          'الهدف: \$${product.targetAmount!.toStringAsFixed(0)}',
          style: const TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        );

      default:
        return null; // "أخرى" ما إلها قيمة رقمية تُعرض
    }
  }

  @override
  Widget build(BuildContext context) {
    final valueLabel = _buildValueLabel();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: product.images.isNotEmpty
                        ? Image.network(
                            getImageUrl(product.images[0]),
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, error, ___) {
                              return Container(
                                color: Colors.grey.shade100,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey.shade100,
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                  ),
                ),
                // ── شارة النوع أعلى الصورة ──────────
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _typeColor(),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _typeLabel(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (valueLabel != null) ...[
                  const SizedBox(height: 4),
                  valueLabel,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
