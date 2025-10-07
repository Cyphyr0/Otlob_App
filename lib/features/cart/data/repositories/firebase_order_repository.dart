import '../../../../core/services/firebase/firebase_firestore_service.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/services/order_notification_service.dart';

class FirebaseOrderRepository implements OrderRepository {
  FirebaseOrderRepository(this._firestoreService);

  final FirebaseFirestoreService _firestoreService;

  @override
  Future<void> placeOrder(Order order) async {
    await _firestoreService.placeOrder(order);
  }

  @override
  Future<Order?> getOrderById(String orderId) async => _firestoreService.getOrderById(orderId);

  @override
  Future<List<Order>> getUserOrders(String userId) async => _firestoreService.getUserOrdersList(userId);

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _firestoreService.updateOrderStatus(orderId, status);

    // Send notification for status update
    try {
      final order = await _firestoreService.getOrderById(orderId);
      if (order != null && order.items.isNotEmpty) {
        final restaurantName = order.items.first.restaurantName ?? 'المطعم';
        final imageUrl = order.items.first.imageUrl;

        await OrderNotificationService.sendOrderStatusNotification(
          orderId: orderId,
          newStatus: status,
          customerName: 'العميل', // Default name since not stored in Order entity
          restaurantName: restaurantName,
          imageUrl: imageUrl,
        );
      }
    } catch (e) {
      print('Error sending order status notification: $e');
      // Don't throw error to avoid breaking the order update flow
    }
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    await _firestoreService.updateOrderStatus(orderId, OrderStatus.cancelled);
  }

  @override
  Future<List<Order>> getOrdersByStatus(String userId, OrderStatus status) async => _firestoreService.getOrdersByStatus(userId, status);

  @override
  Future<List<Order>> getRestaurantOrders(String restaurantId) async => _firestoreService.getRestaurantOrders(restaurantId);
}