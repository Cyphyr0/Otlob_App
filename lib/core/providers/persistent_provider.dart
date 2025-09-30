import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:otlob_app/features/cart/data/models/cart_model.dart';

class PersistentNotifier extends StateNotifier<AsyncValue<CartModel>> {
  PersistentNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadState();
  }

  final Ref ref;

  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString('cart_state');
      
      if (cartJson != null && cartJson.isNotEmpty) {
        final cartData = jsonDecode(cartJson) as Map<String, dynamic>;
        state = AsyncValue.data(CartModel.fromJson(cartData));
      } else {
        state = AsyncValue.data(CartModel.empty());
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateCart(CartModel newCart) async {
    try {
      state = AsyncValue.data(newCart);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cart_state', jsonEncode(newCart.toJson()));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> clearCart() async {
    try {
      final emptyCart = CartModel.empty();
      state = AsyncValue.data(emptyCart);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cart_state');
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final persistentCartProvider = StateNotifierProvider<PersistentNotifier, AsyncValue<CartModel>>(
  (ref) => PersistentNotifier(ref),
);
