import '../../../home/domain/entities/restaurant.dart';

class SurpriseMeResult {
  const SurpriseMeResult({
    required this.restaurant,
    required this.message,
    required this.reasoning,
    required this.confidence,
  });

  final Restaurant restaurant;
  final String message;
  final String reasoning;
  final double confidence;

  String get confidenceText {
    if (confidence >= 0.8) return 'Excellent Match';
    if (confidence >= 0.6) return 'Great Match';
    if (confidence >= 0.4) return 'Good Match';
    return 'Try Something New';
  }

  @override
  String toString() {
    return 'SurpriseMeResult(restaurant: ${restaurant.name}, confidence: ${confidence.toStringAsFixed(2)})';
  }
}