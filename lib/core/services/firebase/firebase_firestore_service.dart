import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import '../../../features/auth/domain/entities/user.dart';
import '../../../features/cart/domain/entities/cart_item.dart';
import '../../../features/cart/domain/entities/order.dart';
import '../../../features/home/domain/entities/restaurant.dart';

class FirebaseFirestoreService {
  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;

  firestore.FirebaseFirestore get firestoreInstance => _firestore;

  // Collections
  static const String usersCollection = 'users';
  static const String restaurantsCollection = 'restaurants';
  static const String ordersCollection = 'orders';
  static const String cartCollection = 'cart';
  static const String favoritesCollection = 'favorites';
  static const String reviewsCollection = 'reviews';

  // Users
  Future<void> createUser(User user) async {
    await _firestore.collection(usersCollection).doc(user.id).set({
      ...user.toJson(),
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    });
  }

  Future<User?> getUser(String userId) async {
    var doc = await _firestore.collection(usersCollection).doc(userId).get();
    if (!doc.exists) return null;
    return User.fromJson(doc.data()!);
  }

  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    await _firestore.collection(usersCollection).doc(userId).update({
      ...updates,
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteUser(String userId) async {
    await _firestore.collection(usersCollection).doc(userId).delete();
  }

  // Restaurants
  Future<void> createRestaurant(Restaurant restaurant) async {
    await _firestore.collection(restaurantsCollection).doc(restaurant.id).set({
      ...restaurant.toJson(),
      'createdAt': firestore.FieldValue.serverTimestamp(),
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    });
  }

  Future<Restaurant?> getRestaurant(String restaurantId) async {
    var doc = await _firestore
        .collection(restaurantsCollection)
        .doc(restaurantId)
        .get();
    if (!doc.exists) return null;
    return Restaurant.fromJson(doc.data()!);
  }

  Future<List<Restaurant>> getRestaurants({
    int limit = 20,
    firestore.DocumentSnapshot? startAfter,
    String? cuisine,
    double? minRating,
    double? maxDistance,
    String? sortBy = 'rating', // rating, distance, priceLevel, tawseyaCount
    bool descending = true,
  }) async {
    firestore.Query query = _firestore.collection(restaurantsCollection);

    // Apply filters
    if (cuisine != null && cuisine.isNotEmpty) {
      query = query.where('cuisine', isEqualTo: cuisine);
    }
    if (minRating != null) {
      query = query.where('rating', isGreaterThanOrEqualTo: minRating);
    }
    if (maxDistance != null) {
      query = query.where('distance', isLessThanOrEqualTo: maxDistance);
    }

    // Apply sorting
    switch (sortBy) {
      case 'distance':
        query = query.orderBy('distance', descending: descending);
        break;
      case 'priceLevel':
        query = query.orderBy('priceLevel', descending: descending);
        break;
      case 'tawseyaCount':
        query = query.orderBy('tawseyaCount', descending: descending);
        break;
      case 'rating':
      default:
        query = query.orderBy('rating', descending: descending);
        break;
    }

    // Apply pagination
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    } else {
      query = query.limit(limit);
    }

    var snapshot = await query.get();
    return snapshot.docs
        .map((doc) => Restaurant.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Restaurant>> searchRestaurants(
    String query, {
    int limit = 20,
    firestore.DocumentSnapshot? startAfter,
  }) async {
    // Note: Firestore doesn't support full-text search natively
    // For production, consider using Algolia or Elasticsearch
    // This is a basic implementation using array-contains for tags
    var snapshot = await _firestore
        .collection(restaurantsCollection)
        .where('searchKeywords', arrayContains: query.toLowerCase())
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) => Restaurant.fromJson(doc.data())).toList();
  }

  Future<void> updateRestaurant(
    String restaurantId,
    Map<String, dynamic> updates,
  ) async {
    await _firestore.collection(restaurantsCollection).doc(restaurantId).update(
      {...updates, 'updatedAt': firestore.FieldValue.serverTimestamp()},
    );
  }

  Future<void> deleteRestaurant(String restaurantId) async {
    await _firestore
        .collection(restaurantsCollection)
        .doc(restaurantId)
        .delete();
  }

  // Favorites
  Future<void> addToFavorites(String userId, String restaurantId) async {
    await _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(favoritesCollection)
        .doc(restaurantId)
        .set({
          'restaurantId': restaurantId,
          'addedAt': firestore.FieldValue.serverTimestamp(),
        });
  }

  Future<void> removeFromFavorites(String userId, String restaurantId) async {
    await _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(favoritesCollection)
        .doc(restaurantId)
        .delete();
  }

  Future<List<String>> getFavoriteIds(String userId) async {
    var snapshot = await _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(favoritesCollection)
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<bool> isFavorite(String userId, String restaurantId) async {
    var doc = await _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(favoritesCollection)
        .doc(restaurantId)
        .get();

    return doc.exists;
  }

  // Cart
  Future<void> addToCart(String userId, CartItem item) async {
    await _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(cartCollection)
        .doc(item.id)
        .set({...item.toJson(), 'addedAt': firestore.FieldValue.serverTimestamp()});
  }

  Future<void> updateCartItem(
    String userId,
    String itemId,
    int quantity,
  ) async {
    if (quantity <= 0) {
      await removeFromCart(userId, itemId);
    } else {
      await _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection(cartCollection)
          .doc(itemId)
          .update({
            'quantity': quantity,
            'updatedAt': firestore.FieldValue.serverTimestamp(),
          });
    }
  }

  Future<void> removeFromCart(String userId, String itemId) async {
    await _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(cartCollection)
        .doc(itemId)
        .delete();
  }

  Future<List<CartItem>> getCartItems(String userId) async {
    var snapshot = await _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(cartCollection)
        .get();

    return snapshot.docs.map((doc) => CartItem.fromJson(doc.data())).toList();
  }

  Future<void> clearCart(String userId) async {
    var batch = _firestore.batch();
    var snapshot = await _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(cartCollection)
        .get();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  // Orders
  Future<String> createOrder(
    String userId,
    Map<String, dynamic> orderData,
  ) async {
    var docRef = _firestore.collection(ordersCollection).doc();
    await docRef.set({
      ...orderData,
      'id': docRef.id,
      'userId': userId,
      'createdAt': firestore.FieldValue.serverTimestamp(),
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  Future<Map<String, dynamic>?> getOrder(String orderId) async {
    var doc = await _firestore
        .collection(ordersCollection)
        .doc(orderId)
        .get();
    return doc.data();
  }

  Future<List<Map<String, dynamic>>> getUserOrders(
    String userId, {
    int limit = 20,
    firestore.DocumentSnapshot? startAfter,
  }) async {
    firestore.Query query = _firestore
        .collection(ordersCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    var snapshot = await query.get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<void> updateOrder(String orderId, Map<String, dynamic> updates) async {
    await _firestore.collection(ordersCollection).doc(orderId).update({
      ...updates,
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    });
  }

  // Enhanced Order Methods
  Future<void> placeOrder(Order order) async {
    await _firestore.collection(ordersCollection).doc(order.id).set({
      ...order.toJson(),
      'createdAt': firestore.FieldValue.serverTimestamp(),
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    });
  }

  Future<Order?> getOrderById(String orderId) async {
    var doc = await _firestore.collection(ordersCollection).doc(orderId).get();
    if (!doc.exists) return null;
    return Order.fromJson(doc.data()!);
  }

  Future<List<Order>> getUserOrdersList(String userId) async {
    var snapshot = await _firestore
        .collection(ordersCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => Order.fromJson(doc.data())).toList();
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _firestore.collection(ordersCollection).doc(orderId).update({
      'status': status.name,
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    });
  }

  Future<List<Order>> getOrdersByStatus(String userId, OrderStatus status) async {
    var snapshot = await _firestore
        .collection(ordersCollection)
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: status.name)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => Order.fromJson(doc.data())).toList();
  }

  Future<List<Order>> getRestaurantOrders(String restaurantId) async {
    var snapshot = await _firestore
        .collection(ordersCollection)
        .where('items', arrayContains: {'restaurantId': restaurantId})
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => Order.fromJson(doc.data())).toList();
  }

  // Real-time listeners
  Stream<List<Restaurant>> getRestaurantsStream({
    int limit = 20,
    String? cuisine,
    double? minRating,
  }) {
    firestore.Query query = _firestore.collection(restaurantsCollection).limit(limit);

    if (cuisine != null && cuisine.isNotEmpty) {
      query = query.where('cuisine', isEqualTo: cuisine);
    }
    if (minRating != null) {
      query = query.where('rating', isGreaterThanOrEqualTo: minRating);
    }

    return query.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Restaurant.fromJson(doc.data() as Map<String, dynamic>))
          .toList(),
    );
  }

  Stream<List<CartItem>> getCartStream(String userId) => _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(cartCollection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CartItem.fromJson(doc.data()))
              .toList(),
        );

  Stream<List<String>> getFavoritesStream(String userId) => _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(favoritesCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());

  // Generic document methods
  Future<firestore.DocumentSnapshot> getDocument(String path) async => _firestore.doc(path).get();

  Future<void> setDocument(String path, Map<String, dynamic> data) async {
    await _firestore.doc(path).set({
      ...data,
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateDocument(String path, Map<String, dynamic> updates) async {
    await _firestore.doc(path).update({
      ...updates,
      'updatedAt': firestore.FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteDocument(String path) async {
    await _firestore.doc(path).delete();
  }

  Future<firestore.QuerySnapshot> getCollection(String path) async => _firestore.collection(path).get();

  // Utility methods
  Future<void> batchWrite(List<firestore.WriteBatch> operations) async {
    var batch = _firestore.batch();
    for (final operation in operations) {
      // Apply operations to batch
    }
    await batch.commit();
  }

  // Transaction example for order processing
  Future<void> processOrder(
    String userId,
    List<CartItem> items,
    double total,
  ) async {
    await _firestore.runTransaction((transaction) async {
      // Clear cart
      var cartSnapshot = await _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection(cartCollection)
          .get();

      for (final doc in cartSnapshot.docs) {
        transaction.delete(doc.reference);
      }

      // Create order
      var orderRef = _firestore.collection(ordersCollection).doc();
      transaction.set(orderRef, {
        'id': orderRef.id,
        'userId': userId,
        'items': items.map((item) => item.toJson()).toList(),
        'total': total,
        'status': 'pending',
        'createdAt': firestore.FieldValue.serverTimestamp(),
      });
    });
  }
}
