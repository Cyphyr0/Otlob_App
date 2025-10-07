 import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required String id,
    required String name,
    required double price,
    required int quantity,
    required String imageUrl,
    required DateTime addedAt, String? specialInstructions,
    String? restaurantId,
    String? restaurantName,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
}
