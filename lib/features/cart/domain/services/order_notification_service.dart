import 'package:flutter/material.dart';
import '../../../../core/services/firebase/firebase_messaging_service.dart';
import '../../domain/entities/order.dart';

class OrderNotificationService {
  // Send notification when order status changes
  static Future<void> sendOrderStatusNotification({
    required String orderId,
    required OrderStatus newStatus,
    required String customerName,
    String? restaurantName,
    String? imageUrl,
  }) async {
    String title;
    String body;

    switch (newStatus) {
      case OrderStatus.pending:
        title = 'طلب جديد';
        body = 'تم استلام طلبك وجاري مراجعته';
        break;
      case OrderStatus.confirmed:
        title = 'تم تأكيد الطلب';
        body = 'تم تأكيد طلبك وسيتم تحضيره قريباً';
        break;
      case OrderStatus.preparing:
        title = 'جاري التحضير';
        body = 'مطعم ${restaurantName ?? 'المطعم'} يحضر طلبك الآن';
        break;
      case OrderStatus.ready:
        title = 'الطلب جاهز';
        body = 'طلبك جاهز للاستلام أو التوصيل';
        break;
      case OrderStatus.onTheWay:
        title = 'الطلب في الطريق';
        body = 'مندوب التوصيل في طريقه إليك';
        break;
      case OrderStatus.delivered:
        title = 'تم التوصيل';
        body = 'تم توصيل طلبك بنجاح. نتمنى لك وجبة شهية!';
        break;
      case OrderStatus.cancelled:
        title = 'تم إلغاء الطلب';
        body = 'تم إلغاء طلبك. يمكنك تقديم طلب جديد في أي وقت';
        break;
    }

    await FirebaseMessagingService.showOrderNotification(
      title: title,
      body: body,
      orderId: orderId,
      imageUrl: imageUrl,
    );

    // Also send to Firebase Cloud Messaging for other devices
    await _sendToCloudMessaging(
      title: title,
      body: body,
      orderId: orderId,
      status: newStatus.name,
    );
  }

  // Send notification when order is placed
  static Future<void> sendOrderPlacedNotification({
    required String orderId,
    required String customerName,
    required String restaurantName,
    required double totalAmount,
    String? imageUrl,
  }) async {
    const title = 'طلب جديد تم تقديمه';
    final body = 'تم تقديم طلب بقيمة ${totalAmount.toStringAsFixed(2)} جنيه من $restaurantName';

    await FirebaseMessagingService.showOrderNotification(
      title: title,
      body: body,
      orderId: orderId,
      imageUrl: imageUrl,
    );

    await _sendToCloudMessaging(
      title: title,
      body: body,
      orderId: orderId,
      status: 'placed',
    );
  }

  // Send notification for estimated delivery time
  static Future<void> sendEstimatedDeliveryNotification({
    required String orderId,
    required int estimatedMinutes,
    String? imageUrl,
  }) async {
    const title = 'وقت التوصيل المتوقع';
    final body = 'سيتم توصيل طلبك خلال $estimatedMinutes دقيقة تقريباً';

    await FirebaseMessagingService.showOrderNotification(
      title: title,
      body: body,
      orderId: orderId,
      imageUrl: imageUrl,
    );
  }

  // Send notification for special offers on orders
  static Future<void> sendOrderOfferNotification({
    required String title,
    required String body,
    String? orderId,
    String? imageUrl,
  }) async {
    await FirebaseMessagingService.showOrderNotification(
      title: title,
      body: body,
      orderId: orderId,
      imageUrl: imageUrl,
    );
  }

  // Subscribe user to order notifications
  static Future<void> subscribeToOrderNotifications() async {
    await FirebaseMessagingService.subscribeToOrderNotifications();
  }

  // Unsubscribe user from order notifications
  static Future<void> unsubscribeFromOrderNotifications() async {
    await FirebaseMessagingService.unsubscribeFromOrderNotifications();
  }

  // Send notification to Firebase Cloud Messaging (for cross-device sync)
  static Future<void> _sendToCloudMessaging({
    required String title,
    required String body,
    required String orderId,
    required String status,
  }) async {
    try {
      // TODO: Implement Firebase Cloud Messaging API call
      // This would typically be done through a Cloud Function or your backend
      print('Would send to FCM: $title - $body for order $orderId with status $status');
    } catch (e) {
      print('Error sending to FCM: $e');
    }
  }

  // Get notification icon based on order status
  static IconData getNotificationIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.schedule;
      case OrderStatus.confirmed:
        return Icons.check_circle;
      case OrderStatus.preparing:
        return Icons.restaurant;
      case OrderStatus.ready:
        return Icons.shopping_bag;
      case OrderStatus.onTheWay:
        return Icons.delivery_dining;
      case OrderStatus.delivered:
        return Icons.done_all;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }

  // Get notification color based on order status
  static Color getNotificationColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.amber;
      case OrderStatus.ready:
        return Colors.green;
      case OrderStatus.onTheWay:
        return Colors.purple;
      case OrderStatus.delivered:
        return Colors.green.shade700;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}