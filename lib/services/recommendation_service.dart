import '../models/product.dart';

class RecommendationService {
  const RecommendationService();

  int calculateMatchScore(Product product, List<String> priorities) {
    if (priorities.isEmpty) {
      priorities = ['Budget'];
    }

    double score = 0;
    final normalizedPriority = priorities
        .map((item) => item.toLowerCase())
        .toList();

    if (normalizedPriority.contains('budget')) {
      final budgetScore = _calculateBudgetScore(product.price);
      score += budgetScore;
    }

    if (normalizedPriority.contains('rating')) {
      score += _calculateRatingScore(product.rating);
    }

    if (normalizedPriority.contains('fast delivery')) {
      score += _calculateDeliveryScore(product.deliveryDays);
    }

    if (normalizedPriority.contains('features')) {
      score += _calculateFeatureScore(product.features.length);
    }

    double weight = normalizedPriority.length.toDouble();
    if (weight == 0) {
      weight = 1;
    }

    return (score / weight).clamp(0, 100).round();
  }

  List<String> generateReasons(Product product, List<String> priorities) {
    final selected = priorities.isEmpty ? ['Budget'] : priorities;
    final reasons = <String>[];

    if (selected.any((item) => item.toLowerCase() == 'budget')) {
      if (product.price <= 3000) {
        reasons.add('✓ Fits your budget');
      } else {
        reasons.add('✓ Good value choice');
      }
    }

    if (selected.any((item) => item.toLowerCase() == 'rating')) {
      reasons.add('✓ ${product.rating.toStringAsFixed(1)}★ rating');
    }

    if (selected.any((item) => item.toLowerCase() == 'fast delivery')) {
      reasons.add('✓ Delivery in ${product.deliveryDays} days');
    }

    if (selected.any((item) => item.toLowerCase() == 'features')) {
      reasons.add('✓ ${product.features.length} useful features');
    }

    return reasons;
  }

  String generateReason(Product product, List<String> priorities) {
    final reasons = generateReasons(product, priorities);
    if (reasons.isEmpty) {
      return 'This product is a strong fit for your selection.';
    }
    return reasons.join(' • ');
  }

  double _calculateBudgetScore(double price) {
    if (price <= 2000) return 100;
    if (price <= 4000) return 85;
    if (price <= 7000) return 70;
    return 55;
  }

  double _calculateRatingScore(double rating) {
    if (rating >= 4.8) return 100;
    if (rating >= 4.5) return 88;
    if (rating >= 4.2) return 75;
    return 60;
  }

  double _calculateDeliveryScore(int deliveryDays) {
    if (deliveryDays <= 2) return 100;
    if (deliveryDays <= 4) return 82;
    if (deliveryDays <= 6) return 68;
    return 55;
  }

  double _calculateFeatureScore(int featuresCount) {
    if (featuresCount >= 5) return 100;
    if (featuresCount >= 3) return 80;
    if (featuresCount >= 2) return 65;
    return 50;
  }
}
