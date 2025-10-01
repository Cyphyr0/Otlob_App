import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item.freezed.dart';

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required String id,
    required String name,
    required double price,
    required int quantity,
    required String imageUrl,
  }) = _CartItem;
}
