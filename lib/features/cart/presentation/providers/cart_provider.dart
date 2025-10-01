import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/cart_item.dart';

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(
  CartNotifier.new,
);

class CartNotifier extends Notifier<List<CartItem>> {
  String? _promoCode;

  @override
  List<CartItem> build() => [];

  void addItem({
    required String name,
    required double price,
    required String imageUrl,
  }) {
    final id = const Uuid().v4();
    final existingItem = state.firstWhere(
      (item) => item.name == name && item.price == price,
      orElse: () =>
          CartItem(id: '', name: '', price: 0, quantity: 0, imageUrl: ''),
    );

    if (existingItem.id.isNotEmpty) {
      state = [
        for (final item in state)
          if (item.id == existingItem.id)
            item.copyWith(quantity: item.quantity + 1)
          else
            item,
      ];
    } else {
      final newItem = CartItem(
        id: id,
        name: name,
        price: price,
        quantity: 1,
        imageUrl: imageUrl,
      );
      state = [...state, newItem];
    }
  }

  void updateQuantity(String id, int quantity) {
    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(quantity: quantity) else item,
    ].where((item) => item.quantity > 0).toList();
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void clearCart() {
    state = [];
    _promoCode = null;
  }

  double get subtotal => state.fold<double>(
    0.0,
    (previousValue, item) => previousValue + (item.price * item.quantity),
  );

  double get deliveryFee => 2.0;

  double get discount {
    if (_promoCode == 'mock10') {
      return subtotal * 0.1;
    }
    return 0.0;
  }

  double get total => subtotal + deliveryFee - discount;

  bool get hasValidPromo => _promoCode == 'mock10';

  String? get promoError => _promoCode != null && _promoCode != 'mock10'
      ? 'Invalid promo code'
      : null;

  void applyPromo(String code) {
    _promoCode = code;
    state = [...state]; // Trigger rebuild
  }

  void clearPromo() {
    _promoCode = null;
    state = [...state];
  }
}
