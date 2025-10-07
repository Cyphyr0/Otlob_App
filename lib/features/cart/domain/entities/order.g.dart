// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  deliveryAddress: OrderAddress.fromJson(
    json['deliveryAddress'] as Map<String, dynamic>,
  ),
  paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
  paymentStatus: $enumDecode(_$PaymentStatusEnumMap, json['paymentStatus']),
  status: $enumDecode(_$OrderStatusEnumMap, json['status']),
  subtotal: (json['subtotal'] as num).toDouble(),
  deliveryFee: (json['deliveryFee'] as num).toDouble(),
  tax: (json['tax'] as num).toDouble(),
  discount: (json['discount'] as num).toDouble(),
  total: (json['total'] as num).toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  estimatedDeliveryTime: json['estimatedDeliveryTime'] == null
      ? null
      : DateTime.parse(json['estimatedDeliveryTime'] as String),
  specialInstructions: json['specialInstructions'] as String?,
  orderNotes: json['orderNotes'] as String?,
  promoCode: json['promoCode'] as String?,
  trackingId: json['trackingId'] as String?,
);

Map<String, dynamic> _$$OrderImplToJson(
  _$OrderImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'items': instance.items,
  'deliveryAddress': instance.deliveryAddress,
  'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
  'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
  'status': _$OrderStatusEnumMap[instance.status]!,
  'subtotal': instance.subtotal,
  'deliveryFee': instance.deliveryFee,
  'tax': instance.tax,
  'discount': instance.discount,
  'total': instance.total,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'estimatedDeliveryTime': instance.estimatedDeliveryTime?.toIso8601String(),
  'specialInstructions': instance.specialInstructions,
  'orderNotes': instance.orderNotes,
  'promoCode': instance.promoCode,
  'trackingId': instance.trackingId,
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.card: 'card',
  PaymentMethod.wallet: 'wallet',
  PaymentMethod.stripe: 'stripe',
  PaymentMethod.fawry: 'fawry',
  PaymentMethod.vodafoneCash: 'vodafoneCash',
  PaymentMethod.meeza: 'meeza',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.completed: 'completed',
  PaymentStatus.failed: 'failed',
  PaymentStatus.refunded: 'refunded',
};

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.preparing: 'preparing',
  OrderStatus.ready: 'ready',
  OrderStatus.onTheWay: 'onTheWay',
  OrderStatus.delivered: 'delivered',
  OrderStatus.cancelled: 'cancelled',
};

_$OrderItemImpl _$$OrderItemImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
      specialInstructions: json['specialInstructions'] as String?,
      restaurantId: json['restaurantId'] as String?,
      restaurantName: json['restaurantName'] as String?,
    );

Map<String, dynamic> _$$OrderItemImplToJson(_$OrderItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'imageUrl': instance.imageUrl,
      'specialInstructions': instance.specialInstructions,
      'restaurantId': instance.restaurantId,
      'restaurantName': instance.restaurantName,
    };

_$OrderAddressImpl _$$OrderAddressImplFromJson(Map<String, dynamic> json) =>
    _$OrderAddressImpl(
      street: json['street'] as String,
      city: json['city'] as String,
      governorate: json['governorate'] as String,
      postalCode: json['postalCode'] as String,
      apartment: json['apartment'] as String?,
      building: json['building'] as String?,
      floor: json['floor'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      instructions: json['instructions'] as String?,
    );

Map<String, dynamic> _$$OrderAddressImplToJson(_$OrderAddressImpl instance) =>
    <String, dynamic>{
      'street': instance.street,
      'city': instance.city,
      'governorate': instance.governorate,
      'postalCode': instance.postalCode,
      'apartment': instance.apartment,
      'building': instance.building,
      'floor': instance.floor,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'instructions': instance.instructions,
    };
