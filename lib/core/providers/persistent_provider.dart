import "dart:convert";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";
import "../../features/cart/data/models/cart_model.dart";

part "persistent_provider.g.dart";

@riverpod
class PersistentNotifier extends _$PersistentNotifier {
  @override
  AsyncValue<CartModel> build() {
    _loadState();
    return const AsyncValue.loading();
  }

  Future<void> _loadState() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var cartJson = prefs.getString("cart_state");

      if (cartJson != null && cartJson.isNotEmpty) {
        var cartData = jsonDecode(cartJson) as Map<String, dynamic>;
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

      var prefs = await SharedPreferences.getInstance();
      await prefs.setString("cart_state", jsonEncode(newCart.toJson()));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> clearCart() async {
    try {
      var emptyCart = CartModel.empty();
      state = AsyncValue.data(emptyCart);

      var prefs = await SharedPreferences.getInstance();
      await prefs.remove("cart_state");
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
