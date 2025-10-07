import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:otlob_app/core/services/service_locator.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/repositories/firebase_cart_repository.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(
  CartNotifier.new,
);

class CartNotifier extends Notifier<List<CartItem>> {
  String? _promoCode;
  static const String _cartKey = 'cart_items';
  static const String _promoKey = 'promo_code';
  bool _isInitialized = false;
  bool _isLoading = true;
  CartRepository? _cartRepository;

  @override
  List<CartItem> build() {
    _cartRepository ??= getIt<FirebaseCartRepository>();
    if (!_isInitialized) {
      _isInitialized = true;
      _initializeCart();
      _loadPromoFromStorage();
    }
    return [];
  }

  Future<void> _initializeCart() async {
    // Load cart from Firebase if user is authenticated
    final authState = ref.watch(authProvider);
    if (authState.hasValue && authState.value != null) {
      final userId = authState.value!.id;
      try {
        final cartItems = await _cartRepository!.getCartItems(userId);
        state = cartItems;
      } catch (e) {
        // Fallback to local storage if Firebase fails
        _loadCartFromStorage();
      }
    } else {
      // Fallback to local storage for unauthenticated users
      _loadCartFromStorage();
    }
  }

  bool get isLoading => _isLoading;

  Future<void> _loadCartFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_cartKey);
      if (raw == null || raw.isEmpty) {
        state = [];
      } else {
        final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
        final cartItems = decoded.map((m) {
          final map = m as Map<String, dynamic>;
          return CartItem(
            id: map['id'] as String,
            name: map['name'] as String,
            price: (map['price'] as num).toDouble(),
            quantity: map['quantity'] as int,
            imageUrl: map['imageUrl'] as String? ?? '',
          );
        }).toList();
        state = cartItems;
      }
    } catch (e) {
      // If loading fails, start with empty cart
      state = [];
    } finally {
      _isLoading = false;
      // ensure UI updates after loading
      state = [...state];
    }
  }

  Future<void> _saveCartToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(
        state
            .map(
              (item) => {
                'id': item.id,
                'name': item.name,
                'price': item.price,
                'quantity': item.quantity,
                'imageUrl': item.imageUrl,
              },
            )
            .toList(),
      );
      await prefs.setString(_cartKey, encoded);
    } catch (e) {
      // Silently fail if saving fails
    }
  }

  void addItem({
    required String name,
    required double price,
    String? imageUrl,
  }) async {
    final authState = ref.read(authProvider);
    if (authState.hasValue && authState.value != null) {
      final userId = authState.value!.id;
      // Find existing by name+price OR same image if provided
      final existingIndex = state.indexWhere(
        (item) =>
            item.name == name &&
            item.price == price &&
            (imageUrl == null || item.imageUrl == (imageUrl)),
      );

      if (existingIndex != -1) {
        // increment quantity
        final updatedItem = state[existingIndex].copyWith(
          quantity: state[existingIndex].quantity + 1,
        );
        await _cartRepository!.updateCartItem(
          userId,
          updatedItem.id,
          updatedItem.quantity,
        );
        state = [
          for (int i = 0; i < state.length; i++)
            if (i == existingIndex) updatedItem else state[i],
        ];
      } else {
        final id = const Uuid().v4();
        final newItem = CartItem(
          id: id,
          name: name,
          price: price,
          quantity: 1,
          imageUrl: imageUrl ?? '',
        );
        await _cartRepository!.addToCart(userId, newItem);
        state = [...state, newItem];
      }
    } else {
      // Fallback to local storage for unauthenticated users
      // Find existing by name+price OR same image if provided
      final existingIndex = state.indexWhere(
        (item) =>
            item.name == name &&
            item.price == price &&
            (imageUrl == null || item.imageUrl == (imageUrl)),
      );

      if (existingIndex != -1) {
        // increment quantity
        final updated = [
          for (int i = 0; i < state.length; i++)
            if (i == existingIndex)
              state[i].copyWith(quantity: state[i].quantity + 1)
            else
              state[i],
        ];
        state = updated;
      } else {
        final id = const Uuid().v4();
        final newItem = CartItem(
          id: id,
          name: name,
          price: price,
          quantity: 1,
          imageUrl: imageUrl ?? '',
        );
        state = [...state, newItem];
      }

      // persist locally as fallback and ensure immediate UI update
      _saveCartToStorage();
    }
    state = [...state];
  }

  void updateQuantity(String id, int quantity) async {
    final authState = ref.read(authProvider);
    if (authState.hasValue && authState.value != null) {
      final userId = authState.value!.id;
      if (quantity > 0) {
        await _cartRepository!.updateCartItem(userId, id, quantity);
      } else {
        await _cartRepository!.removeFromCart(userId, id);
      }
    }

    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(quantity: quantity) else item,
    ].where((item) => item.quantity > 0).toList();

    if (authState.hasValue && authState.value != null) {
      // Already saved to Firebase above
    } else {
      _saveCartToStorage();
    }
  }

  void removeItem(String id) async {
    final authState = ref.read(authProvider);
    if (authState.hasValue && authState.value != null) {
      final userId = authState.value!.id;
      await _cartRepository!.removeFromCart(userId, id);
    }

    state = state.where((item) => item.id != id).toList();

    if (authState.hasValue && authState.value != null) {
      // Already saved to Firebase above
    } else {
      _saveCartToStorage();
    }
  }

  void clearCart() async {
    final authState = ref.read(authProvider);
    if (authState.hasValue && authState.value != null) {
      final userId = authState.value!.id;
      await _cartRepository!.clearCart(userId);
    }

    state = [];
    _promoCode = null;

    if (authState.hasValue && authState.value != null) {
      // Already saved to Firebase above
    } else {
      _saveCartToStorage();
    }
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
    _savePromoToStorage();
  }

  void clearPromo() {
    _promoCode = null;
    state = [...state];
    _savePromoToStorage();
  }

  Future<void> _savePromoToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_promoCode != null) {
        await prefs.setString('promo_code', _promoCode!);
      } else {
        await prefs.remove('promo_code');
      }
    } catch (e) {
      // Silently fail if saving fails
    }
  }

  Future<void> _loadPromoFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _promoCode = prefs.getString('promo_code');
    } catch (e) {
      _promoCode = null;
    }
  }
}
