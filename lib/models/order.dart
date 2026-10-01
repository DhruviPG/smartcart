class OrderModel {
  final String id;
  final String userId;
  final List<Map<String, dynamic>> items;
  final double total;
  final String address;
  final String paymentMethod;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.address,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });
}
