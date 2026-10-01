import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/compare_provider.dart';
import '../services/local_data_service.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';
import 'compare_screen.dart';
import 'explore_screen.dart';
import 'product_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> _futureProducts;

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
            final trending = products.take(4).toList();
            final picks = products.skip(4).take(4).toList();

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Good morning 👋',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Find something you\'ll love.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withAlpha((0.1 * 255).round()),
                      child: const Icon(
                        Icons.notifications_none,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search products, brands & categories',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.tune_outlined),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 110,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      CategoryCard(title: 'Electronics', icon: Icons.devices),
                      CategoryCard(title: 'Fashion', icon: Icons.checkroom),
                      CategoryCard(
                        title: 'Beauty',
                        icon: Icons.face_2_outlined,
                      ),
                      CategoryCard(title: 'Home', icon: Icons.home_outlined),
                      CategoryCard(title: 'Accessories', icon: Icons.watch),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1F5EFF), Color(0xFF4B7CFF)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SHOP SMARTER',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 26,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Compare before you buy.',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton(
                        onPressed: () {
                          final hasProducts = context
                              .read<CompareProvider>()
                              .selectedProducts
                              .isNotEmpty;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => hasProducts
                                  ? const CompareScreen()
                                  : const ExploreScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                        ),
                        child: const Text('Try Smart Compare'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trending Products',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(onPressed: () {}, child: const Text('See all')),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 410,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: trending.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final product = trending[index];
                      return ProductCard(
                        product: product,
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
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Smart Picks For You',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(onPressed: () {}, child: const Text('See all')),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 410,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: picks.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final product = picks[index];
                      return ProductCard(
                        product: product,
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
            );
          },
        ),
      ),
    );
  }
}
