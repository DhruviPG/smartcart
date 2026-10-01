import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/compare_provider.dart';
import '../services/recommendation_service.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  final List<String> _priorities = [
    'Budget',
    'Rating',
    'Fast Delivery',
    'Features',
  ];
  final Set<String> _selectedPriorities = {'Budget'};

  @override
  Widget build(BuildContext context) {
    final compareProvider = context.watch<CompareProvider>();
    final products = compareProvider.selectedProducts;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: products.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.compare_arrows,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'No products selected',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text('Choose up to 3 products to compare.'),
                    ],
                  ),
                )
              : ListView(
                  children: [
                    Text(
                      'Smart Compare',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Compare products based on what matters to you.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    ...products.map(
                      (product) => _buildProductComparisonCard(product),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'What matters most to you?',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _priorities.map((priority) {
                        final selected = _selectedPriorities.contains(priority);
                        return ChoiceChip(
                          label: Text(priority),
                          selected: selected,
                          onSelected: (_) {
                            setState(() {
                              if (selected) {
                                _selectedPriorities.remove(priority);
                              } else {
                                _selectedPriorities.add(priority);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    ...products.map((product) {
                      final score = const RecommendationService()
                          .calculateMatchScore(
                            product,
                            _selectedPriorities.toList(),
                          );
                      final reasons = const RecommendationService()
                          .generateReasons(
                            product,
                            _selectedPriorities.toList(),
                          );

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$score% Match',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1F5EFF),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Best match for your selected priorities.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 10),
                            ...reasons.map(
                              (reason) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(reason),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildProductComparisonCard(Product product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              product.imageUrl,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text('₹${product.price.toStringAsFixed(0)}'),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('${product.rating}'),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.local_shipping_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text('${product.deliveryDays} days'),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: product.features
                      .take(2)
                      .map((feature) => Chip(label: Text(feature)))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
