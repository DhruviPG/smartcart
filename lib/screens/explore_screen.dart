import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/local_data_service.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';
import 'product_details_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late Future<List<Product>> _futureProducts;
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _futureProducts = LocalDataService.instance.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Product>>(
          future: _futureProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final products =
                snapshot.data ?? LocalDataService.instance.demoProducts;
            final categories = [
              'All',
              'Electronics',
              'Fashion',
              'Beauty',
              'Home',
              'Accessories',
            ];
            final filteredProducts = products.where((product) {
              final matchCategory =
                  selectedCategory == 'All' ||
                  product.category == selectedCategory;
              return matchCategory;
            }).toList();

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search products, brands & categories',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 110,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: categories.map((category) {
                        final isSelected = category == selectedCategory;
                        final icon = switch (category) {
                          'Electronics' => Icons.devices,
                          'Fashion' => Icons.checkroom,
                          'Beauty' => Icons.face_2_outlined,
                          'Home' => Icons.home_outlined,
                          'Accessories' => Icons.watch,
                          _ => Icons.apps,
                        };

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                          child: CategoryCard(
                            title: category,
                            icon: icon,
                            isSelected: isSelected,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${filteredProducts.length} results',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      DropdownButton<String>(
                        value: 'Sort',
                        items: const [
                          DropdownMenuItem(value: 'Sort', child: Text('Sort')),
                          DropdownMenuItem(
                            value: 'Price low to high',
                            child: Text('Price low to high'),
                          ),
                          DropdownMenuItem(
                            value: 'Price high to low',
                            child: Text('Price high to low'),
                          ),
                          DropdownMenuItem(
                            value: 'Rating',
                            child: Text('Rating'),
                          ),
                        ],
                        onChanged: (_) {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: GridView.builder(
                      itemCount: filteredProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.7,
                          ),
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return ProductCard(
                          product: product,
                          showMatch: false,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailsScreen(product: product),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
