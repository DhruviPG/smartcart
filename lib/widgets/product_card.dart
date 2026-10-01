import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/compare_provider.dart';
import '../services/auth_service.dart';
import '../services/recommendation_service.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.showMatch = true,
    this.onTap,
  });

  final Product product;
  final bool showMatch;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final recommendation = const RecommendationService();
    final preference =
        context.watch<AuthService>().currentUser?.preference ?? 'Budget';
    final compareProvider = context.watch<CompareProvider>();
    final isSelectedForCompare = compareProvider.isSelected(product);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.05 * 255).round()),
              spreadRadius: 1,
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    product.imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${product.discount}% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.favorite_border, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text('${product.rating} (${product.reviewCount})'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '₹${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '₹${product.oldPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.local_shipping_outlined,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text('Delivery in ${product.deliveryDays} days'),
              ],
            ),
            const SizedBox(height: 12),
            if (showMatch)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Smart Match ${recommendation.calculateMatchScore(product, [preference])}%',
                  style: const TextStyle(
                    color: Color(0xFF1B7F53),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      if (compareProvider.selectedProducts.length >= 3 &&
                          !isSelectedForCompare) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('You can compare up to 3 products.'),
                          ),
                        );
                        return;
                      }

                      if (isSelectedForCompare) {
                        compareProvider.removeProduct(product);
                      } else {
                        compareProvider.addProduct(product);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isSelectedForCompare
                          ? Colors.green
                          : Theme.of(context).colorScheme.primary,
                      side: BorderSide(
                        color: isSelectedForCompare
                            ? Colors.green
                            : Theme.of(context).colorScheme.primary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(isSelectedForCompare ? 'Selected' : 'Compare'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<CartProvider>().addProduct(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to cart'),
                        ),
                      );
                    },
                    child: const Text('Add'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
