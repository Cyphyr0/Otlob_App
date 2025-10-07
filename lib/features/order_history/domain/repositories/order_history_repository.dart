import '../entities/order_history.dart';

abstract class OrderHistoryRepository {
  Future<List<OrderHistory>> getUserOrderHistory(String userId);
  Future<OrderHistory?> getOrderById(String orderId);
  Future<void> saveOrderHistory(OrderHistory order);
  Future<void> updateOrderHistory(OrderHistory order);
  Future<void> deleteOrderHistory(String orderId);
  Future<List<String>> getUserFavoriteCuisines(String userId);
  Future<List<String>> getUserPreferredRestaurants(String userId);
  Future<Map<String, int>> getCuisineFrequency(String userId);
  Future<double> getAverageOrderRating(String userId);
}