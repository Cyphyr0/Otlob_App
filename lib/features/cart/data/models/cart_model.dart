import "package:freezed_annotation/freezed_annotation.dart";

part "cart_model.freezed.dart";
part "cart_model.g.dart";

@freezed
abstract class CartModel with _$CartModel {
  const factory CartModel({
    required List<CartItem> items,
    required double subtotal,
    required double deliveryFee,
    required double total,
    required String restaurantId,
    required DateTime updatedAt,
  }) = _CartModel;

  factory CartModel.empty() => CartModel(
    items: [],
    subtotal: 0,
    deliveryFee: 0,
    total: 0,
    restaurantId: "",
    updatedAt: DateTime.now(),
  );

  factory CartModel.fromJson(Map<String, dynamic> json) => _$CartModelFromJson(json);
}

@freezed
abstract class CartItem with _$CartItem {
  const factory CartItem({
    required String id,
    required String name,
    required double price,
    required int quantity,
    String? specialInstructions,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
}
