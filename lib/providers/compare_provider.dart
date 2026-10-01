import 'package:flutter/foundation.dart';

import '../models/product.dart';

class CompareProvider extends ChangeNotifier {
  final List<Product> _selectedProducts = [];

  List<Product> get selectedProducts => List.unmodifiable(_selectedProducts);

  bool isSelected(Product product) {
    return _selectedProducts.any((item) => item.id == product.id);
  }

  void addProduct(Product product) {
    if (isSelected(product)) {
      return;
    }

    if (_selectedProducts.length >= 3) {
      return;
    }

    _selectedProducts.add(product);
    notifyListeners();
  }

  void removeProduct(Product product) {
    _selectedProducts.removeWhere((item) => item.id == product.id);
    notifyListeners();
  }

  void clear() {
    _selectedProducts.clear();
    notifyListeners();
  }
}
