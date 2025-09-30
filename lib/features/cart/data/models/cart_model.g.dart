// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartModel _$CartModelFromJson(Map<String, dynamic> json) => _CartModel(
  items: (json['items'] as List<dynamic>)
      .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  subtotal: (json['subtotal'] as num).toDouble(),
  deliveryFee: (json['deliveryFee'] as num).toDouble(),
  total: (json['total'] as num).toDouble(),
  restaurantId: json['restaurantId'] as String,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$CartModelToJson(_CartModel instance) =>
    <String, dynamic>{
      'items': instance.items,
      'subtotal': instance.subtotal,
      'deliveryFee': instance.deliveryFee,
      'total': instance.total,
      'restaurantId': instance.restaurantId,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_CartItem _$CartItemFromJson(Map<String, dynamic> json) => _CartItem(
  id: json['id'] as String,
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
  quantity: (json['quantity'] as num).toInt(),
  specialInstructions: json['specialInstructions'] as String?,
);

Map<String, dynamic> _$CartItemToJson(_CartItem instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'price': instance.price,
  'quantity': instance.quantity,
  'specialInstructions': instance.specialInstructions,
};
