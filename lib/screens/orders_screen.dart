import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';
import '../services/auth_service.dart';
import '../services/local_data_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future<List<OrderModel>> _futureOrders;

  @override
  void initState() {
    super.initState();
    final userId = AuthService.instance.currentUser?.uid ?? 'demo-user';
    _futureOrders = LocalDataService.instance.fetchOrders(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: FutureBuilder<List<OrderModel>>(
        future: _futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data ?? const <OrderModel>[];

          if (orders.isEmpty) {
            return const Center(child: Text('No orders yet.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: orders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final order = orders[index];
              final createdDate = DateFormat(
                'dd MMM yyyy',
              ).format(order.createdAt);

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order ID: ${order.id.substring(0, 8)}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(order.status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(createdDate),
                    const SizedBox(height: 12),
                    ...order.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('${item['name']} x ${item['quantity']}'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Total: ₹${order.total.toStringAsFixed(0)}'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Expanded(child: Text('Placed')),
                        const Expanded(child: Text('Confirmed')),
                        const Expanded(child: Text('Shipped')),
                        Expanded(
                          child: Text('Delivered', textAlign: TextAlign.right),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: order.status == 'Placed'
                          ? 0.25
                          : order.status == 'Confirmed'
                          ? 0.5
                          : order.status == 'Shipped'
                          ? 0.75
                          : 1,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
