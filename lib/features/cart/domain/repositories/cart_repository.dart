import "../entities/cart_item.dart";

abstract class CartRepository {
  Future<List<CartItem>> getCartItems(String userId);
  Future<void> addToCart(String userId, CartItem item);
  Future<void> updateCartItem(String userId, String itemId, int quantity);
  Future<void> removeFromCart(String userId, String itemId);
  Future<void> clearCart(String userId);
  Future<double> getCartTotal(String userId);
}
