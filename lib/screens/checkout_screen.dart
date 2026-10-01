import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../providers/cart_provider.dart';
import '../services/auth_service.dart';
import '../services/local_data_service.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final items = cartProvider.cartItems;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery address',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 8),
                    Text('123 Green Avenue, Bengaluru, Karnataka'),
                    SizedBox(height: 6),
                    Text('Phone: +91 98765 43210'),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              ...items.map(
                (item) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
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
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text('Qty: ${item.quantity}'),
                          ],
                        ),
                      ),
                      Text(
                        '₹${(item.product.price * item.quantity).toStringAsFixed(0)}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Payment Method'),
                        Text(
                          'Cash on Delivery',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _SummaryRow(
                      label: 'Subtotal',
                      value: '₹${cartProvider.subtotal.toStringAsFixed(0)}',
                    ),
                    _SummaryRow(
                      label: 'Discount',
                      value:
                          '-₹${cartProvider.discountAmount.toStringAsFixed(0)}',
                    ),
                    _SummaryRow(
                      label: 'Delivery',
                      value: '₹${cartProvider.deliveryFee.toStringAsFixed(0)}',
                    ),
                    const Divider(),
                    _SummaryRow(
                      label: 'Total',
                      value: '₹${cartProvider.total.toStringAsFixed(0)}',
                      bold: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () async {
                  final orderId = DateTime.now().millisecondsSinceEpoch
                      .toString();
                  final order = OrderModel(
                    id: orderId,
                    userId:
                        AuthService.instance.currentUser?.uid ?? 'demo-user',
                    items: items
                        .map(
                          (item) => {
                            'productId': item.product.id,
                            'name': item.product.name,
                            'price': item.product.price,
                            'quantity': item.quantity,
                            'imageUrl': item.product.imageUrl,
                          },
                        )
                        .toList(),
                    total: cartProvider.total,
                    address: '123 Green Avenue, Bengaluru, Karnataka',
                    paymentMethod: 'Cash on Delivery',
                    status: 'Placed',
                    createdAt: DateTime.now(),
                  );

                  await LocalDataService.instance.saveOrder(order);
                  cartProvider.clear();

                  if (context.mounted) {
                    final date = DateFormat(
                      'dd MMM yyyy',
                    ).format(DateTime.now().add(const Duration(days: 3)));
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Order placed successfully'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order ID: $orderId'),
                            const SizedBox(height: 8),
                            Text('Expected delivery: $date'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Done'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Place Order'),
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
