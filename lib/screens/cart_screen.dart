import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final items = cartProvider.cartItems;

    return Scaffold(
      body: SafeArea(
        child: items.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 18),
                    Text('Your cart is empty'),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    item.product.imageUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '₹${item.product.price.toStringAsFixed(0)}',
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              cartProvider.updateQuantity(
                                                item.product.id,
                                                item.quantity - 1,
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.remove_circle_outline,
                                            ),
                                          ),
                                          Text(item.quantity.toString()),
                                          IconButton(
                                            onPressed: () {
                                              cartProvider.updateQuantity(
                                                item.product.id,
                                                item.quantity + 1,
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.add_circle_outline,
                                            ),
                                          ),
                                          const Spacer(),
                                          TextButton(
                                            onPressed: () => cartProvider
                                                .removeProduct(item.product.id),
                                            child: const Text('Remove'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          _SummaryRow(
                            label: 'Subtotal',
                            value:
                                '₹${cartProvider.subtotal.toStringAsFixed(0)}',
                          ),
                          _SummaryRow(
                            label: 'Discount',
                            value:
                                '-₹${cartProvider.discountAmount.toStringAsFixed(0)}',
                          ),
                          _SummaryRow(
                            label: 'Delivery',
                            value:
                                '₹${cartProvider.deliveryFee.toStringAsFixed(0)}',
                          ),
                          const Divider(),
                          _SummaryRow(
                            label: 'Total',
                            value: '₹${cartProvider.total.toStringAsFixed(0)}',
                            bold: true,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'You saved ₹${cartProvider.discountAmount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const CheckoutScreen(),
                                ),
                              );
                            },
                            child: const Text('Proceed to Checkout'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
