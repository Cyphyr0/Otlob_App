import 'package:otlob_app/core/services/firebase/firebase_firestore_service.dart';
import 'package:otlob_app/features/cart/domain/entities/cart_item.dart';
import 'package:otlob_app/features/cart/domain/repositories/cart_repository.dart';

class FirebaseCartRepository implements CartRepository {
  final FirebaseFirestoreService _firestoreService;

  FirebaseCartRepository(this._firestoreService);

  @override
  Future<List<CartItem>> getCartItems(String userId) async {
    return await _firestoreService.getCartItems(userId);
  }

  @override
  Future<void> addToCart(String userId, CartItem item) async {
    await _firestoreService.addToCart(userId, item);
  }

  @override
  Future<void> updateCartItem(
    String userId,
    String itemId,
    int quantity,
  ) async {
    await _firestoreService.updateCartItem(userId, itemId, quantity);
  }

  @override
  Future<void> removeFromCart(String userId, String itemId) async {
    await _firestoreService.removeFromCart(userId, itemId);
  }

  @override
  Future<void> clearCart(String userId) async {
    await _firestoreService.clearCart(userId);
  }

  @override
  Future<double> getCartTotal(String userId) async {
    final items = await getCartItems(userId);
    return items.fold<double>(
      0.0,
      (total, item) => total + (item.price * item.quantity),
    );
  }
}
