class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String description;
  final double price;
  final double oldPrice;
  final double rating;
  final int reviewCount;
  final int discount;
  final String imageUrl;
  final int deliveryDays;
  final int stock;
  final String warranty;
  final List<String> features;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.description,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.reviewCount,
    required this.discount,
    required this.imageUrl,
    required this.deliveryDays,
    required this.stock,
    required this.warranty,
    required this.features,
  });
}
