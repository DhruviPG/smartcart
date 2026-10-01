import 'package:flutter/foundation.dart';

import '../models/product.dart';

class CartItem {
  final Product product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});
}

class CartProvider extends ChangeNotifier {
  final Map<String, Product> _products = {};
  final Map<String, int> _quantities = {};

  void addProduct(Product product) {
    if (_products.containsKey(product.id)) {
      _quantities[product.id] = (_quantities[product.id] ?? 1) + 1;
    } else {
      _products[product.id] = product;
      _quantities[product.id] = 1;
    }
    notifyListeners();
  }

  void removeProduct(String productId) {
    _products.remove(productId);
    _quantities.remove(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeProduct(productId);
      return;
    }
    _quantities[productId] = quantity;
    notifyListeners();
  }

  void clear() {
    _products.clear();
    _quantities.clear();
    notifyListeners();
  }

  List<CartItem> get cartItems {
    return _products.entries.map((entry) {
      final id = entry.key;
      return CartItem(product: entry.value, quantity: _quantities[id] ?? 1);
    }).toList();
  }

  int get itemCount {
    return _quantities.values.fold(0, (sum, count) => sum + count);
  }

  double get subtotal {
    double total = 0;
    for (final item in cartItems) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  double get discountAmount {
    double saved = 0;
    for (final item in cartItems) {
      final oldValue = item.product.oldPrice > 0
          ? item.product.oldPrice * item.quantity
          : item.product.price * item.quantity;
      saved += oldValue - (item.product.price * item.quantity);
    }
    return saved;
  }

  double get deliveryFee {
    if (cartItems.isEmpty) return 0;
    return subtotal > 3000 ? 0 : 149;
  }

  double get total {
    return subtotal + deliveryFee;
  }

  bool get isEmpty => cartItems.isEmpty;
}
