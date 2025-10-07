import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  onTheWay,
  delivered,
  cancelled,
}

enum PaymentMethod {
  cash,
  card,
  wallet,
  stripe,
  fawry,
  vodafoneCash,
  meeza,
}

enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded,
}

@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    required String userId,
    required List<OrderItem> items,
    required OrderAddress deliveryAddress,
    required PaymentMethod paymentMethod,
    required PaymentStatus paymentStatus,
    required OrderStatus status,
    required double subtotal,
    required double deliveryFee,
    required double tax,
    required double discount,
    required double total,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? estimatedDeliveryTime,
    String? specialInstructions,
    String? orderNotes,
    String? promoCode,
    String? trackingId,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String id,
    required String name,
    required double price,
    required int quantity,
    required String imageUrl,
    String? specialInstructions,
    String? restaurantId,
    String? restaurantName,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);
}

@freezed
class OrderAddress with _$OrderAddress {
  const factory OrderAddress({
    required String street,
    required String city,
    required String governorate,
    required String postalCode,
    String? apartment,
    String? building,
    String? floor,
    double? latitude,
    double? longitude,
    String? instructions,
  }) = _OrderAddress;

  factory OrderAddress.fromJson(Map<String, dynamic> json) => _$OrderAddressFromJson(json);
}