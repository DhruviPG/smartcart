import '../models/order.dart';
import '../models/product.dart';

class LocalDataService {
  LocalDataService._();

  static final LocalDataService instance = LocalDataService._();

  final List<OrderModel> _orders = [];

  List<Product> get demoProducts => _allDemoProducts;

  Future<List<Product>> loadProducts() async {
    return List<Product>.from(_allDemoProducts);
  }

  Future<void> saveOrder(OrderModel order) async {
    _orders.add(order);
  }

  Future<List<OrderModel>> fetchOrders(String userId) async {
    final userOrders = _orders
        .where((order) => order.userId == userId)
        .toList();
    userOrders.sort(
      (first, second) => second.createdAt.compareTo(first.createdAt),
    );
    return userOrders;
  }
}

final List<Product> _allDemoProducts = [
  Product(
    id: 'p1',
    name: 'AeroPulse Headphones',
    brand: 'Aero',
    category: 'Electronics',
    description:
        'Wireless over-ear headphones with immersive sound and noise cancellation.',
    price: 2999,
    oldPrice: 3999,
    rating: 4.8,
    reviewCount: 920,
    discount: 25,
    imageUrl:
        'https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=900&q=80',
    deliveryDays: 2,
    stock: 24,
    warranty: '1 year',
    features: [
      'Noise Cancelling',
      'Bluetooth 5.3',
      'Fast Charging',
      'Foldable',
    ],
  ),
  Product(
    id: 'p2',
    name: 'Urban Stitch Jacket',
    brand: 'Urban',
    category: 'Fashion',
    description: 'Lightweight everyday jacket designed for comfort and style.',
    price: 2199,
    oldPrice: 2999,
    rating: 4.6,
    reviewCount: 540,
    discount: 27,
    imageUrl:
        'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=900&q=80',
    deliveryDays: 3,
    stock: 18,
    warranty: '30 day easy return',
    features: ['Water resistant', 'Zip pockets', 'Soft lining', 'Slim fit'],
  ),
  Product(
    id: 'p3',
    name: 'Glow Serum',
    brand: 'Luma',
    category: 'Beauty',
    description:
        'Vitamin-rich serum for hydration and a healthy, radiant glow.',
    price: 1299,
    oldPrice: 1799,
    rating: 4.7,
    reviewCount: 645,
    discount: 28,
    imageUrl:
        'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?auto=format&fit=crop&w=900&q=80',
    deliveryDays: 2,
    stock: 32,
    warranty: '6 months',
    features: ['Paraben free', 'Vitamin C', 'Daily use', 'Travel size'],
  ),
  Product(
    id: 'p4',
    name: 'Smart Nest Lamp',
    brand: 'Nest',
    category: 'Home',
    description: 'Adaptive lighting system that adjusts to your room and mood.',
    price: 3499,
    oldPrice: 4699,
    rating: 4.5,
    reviewCount: 310,
    discount: 25,
    imageUrl:
        'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=900&q=80',
    deliveryDays: 5,
    stock: 12,
    warranty: '2 years',
    features: [
      'App control',
      'Warm to cool tone',
      'Energy saver',
      'Touch dimming',
    ],
  ),
  Product(
    id: 'p5',
    name: 'Voyager Smartwatch',
    brand: 'Voyager',
    category: 'Electronics',
    description: 'Daily fitness and productivity watch with AMOLED display.',
    price: 4999,
    oldPrice: 6499,
    rating: 4.9,
    reviewCount: 812,
    discount: 23,
    imageUrl:
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=900&q=80',
    deliveryDays: 4,
    stock: 40,
    warranty: '1 year',
    features: ['Heart rate', 'Sleep tracking', 'Water resistant', 'GPS'],
  ),
  Product(
    id: 'p6',
    name: 'Saffron Silk Saree',
    brand: 'Saffron',
    category: 'Fashion',
    description: 'Elegant drape with premium texture and rich festive color.',
    price: 2499,
    oldPrice: 3299,
    rating: 4.4,
    reviewCount: 280,
    discount: 24,
    imageUrl:
        'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?auto=format&fit=crop&w=900&q=80',
    deliveryDays: 3,
    stock: 21,
    warranty: '30 day exchange',
    features: [
      'Premium fabric',
      'Festive style',
      'Comfort fit',
      'Traditional design',
    ],
  ),
  Product(
    id: 'p7',
    name: 'Breeze Air Purifier',
    brand: 'Breeze',
    category: 'Home',
    description:
        'Compact purifier for cleaner air and a healthier living space.',
    price: 4599,
    oldPrice: 5999,
    rating: 4.6,
    reviewCount: 510,
    discount: 23,
    imageUrl:
        'https://images.unsplash.com/photo-1585518419759-7fe2e0fbf8a6?auto=format&fit=crop&w=900&q=80',
    deliveryDays: 6,
    stock: 14,
    warranty: '2 years',
    features: ['HEPA filter', 'Silent mode', 'Low power', 'Auto timer'],
  ),
  Product(
    id: 'p8',
    name: 'Nova Wireless Charger',
    brand: 'Nova',
    category: 'Accessories',
    description: 'Fast wireless charging pad for smartphones and earbuds.',
    price: 1599,
    oldPrice: 2299,
    rating: 4.3,
    reviewCount: 180,
    discount: 30,
    imageUrl:
        'https://images.unsplash.com/photo-1583394838336-acd977736f90?auto=format&fit=crop&w=900&q=80',
    deliveryDays: 2,
    stock: 55,
    warranty: '1 year',
    features: ['15W fast charge', 'Non-slip base', 'USB-C', 'Compact design'],
  ),
  Product(
    id: 'p9',
    name: 'Velvet Care Kit',
    brand: 'Velvet',
    category: 'Beauty',
    description: 'Skincare kit for cleansing, hydration and glow care.',
    price: 1899,
    oldPrice: 2599,
    rating: 4.8,
    reviewCount: 700,
    discount: 27,
    imageUrl:
        'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=900&q=80',
    deliveryDays: 2,
    stock: 39,
    warranty: '6 months',
    features: [
      'Gentle cleanse',
      'Hydrating',
      'Skin brightening',
      'Travel pack',
    ],
  ),
  Product(
    id: 'p10',
    name: 'FlexDesk Pro',
    brand: 'FlexDesk',
    category: 'Home',
    description: 'Mainstream ergonomic desk setup for focused work at home.',
    price: 7999,
    oldPrice: 10499,
    rating: 4.7,
    reviewCount: 423,
    discount: 24,
    imageUrl:
        'https://images.unsplash.com/photo-1497366754035-f200968a6e72?auto=format&fit=crop&w=900&q=80',
    deliveryDays: 7,
    stock: 8,
    warranty: '1 year',
    features: ['Ergonomic', 'Large surface', 'Cable tray', 'Foldable'],
  ),
  Product(
    id: 'p11',
    name: 'Orbit Speaker',
    brand: 'Orbit',
    category: 'Electronics',
    description: 'Portable Bluetooth speaker with deep, room-filling sound.',
    price: 2799,
    oldPrice: 3499,
    rating: 4.5,
    reviewCount: 420,
    discount: 20,
    imageUrl:
        'https://images.unsplash.com/photo-1511379938547-c1f69419868d?auto=format&fit=crop&w=900&q=80',
    deliveryDays: 3,
    stock: 28,
    warranty: '1 year',
    features: ['360 sound', 'IPX5', '360-minute battery', 'Voice assistant'],
  ),
  Product(
    id: 'p12',
    name: 'Luna Leather Bag',
    brand: 'Luna',
    category: 'Accessories',
    description:
        'A premium crossbody bag with clean details and everyday style.',
    price: 3299,
    oldPrice: 4499,
    rating: 4.6,
    reviewCount: 390,
    discount: 27,
    imageUrl:
        'https://images.unsplash.com/photo-1584917865442-de89df76afd3?auto=format&fit=crop&w=900&q=80',
    deliveryDays: 2,
    stock: 25,
    warranty: '6 months',
    features: [
      'Leather finish',
      'Adjustable strap',
      'Laptop sleeve',
      'Luxury look',
    ],
  ),
];
