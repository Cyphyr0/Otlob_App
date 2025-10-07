// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartItemImpl _$$CartItemImplFromJson(Map<String, dynamic> json) =>
    _$CartItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
      specialInstructions: json['specialInstructions'] as String?,
      restaurantId: json['restaurantId'] as String?,
      restaurantName: json['restaurantName'] as String?,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );

Map<String, dynamic> _$$CartItemImplToJson(_$CartItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'imageUrl': instance.imageUrl,
      'specialInstructions': instance.specialInstructions,
      'restaurantId': instance.restaurantId,
      'restaurantName': instance.restaurantName,
      'addedAt': instance.addedAt.toIso8601String(),
    };
