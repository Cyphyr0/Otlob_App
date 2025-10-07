import '../entities/order.dart';

abstract class OrderRepository {
  Future<void> placeOrder(Order order);
  Future<Order?> getOrderById(String orderId);
  Future<List<Order>> getUserOrders(String userId);
  Future<void> updateOrderStatus(String orderId, OrderStatus status);
  Future<void> cancelOrder(String orderId);
  Future<List<Order>> getOrdersByStatus(String userId, OrderStatus status);
  Future<List<Order>> getRestaurantOrders(String restaurantId);
}