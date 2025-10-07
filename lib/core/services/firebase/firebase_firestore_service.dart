import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../features/auth/domain/entities/user.dart';
import '../../../features/home/domain/entities/restaurant.dart';
import '../../../features/cart/domain/entities/cart_item.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<User?> getUser(String userId) async {
    final doc = await _firestore.collection(usersCollection).doc(userId).get();
    if (!doc.exists) return null;
    return User.fromJson(doc.data()!);
  }

  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    await _firestore.collection(usersCollection).doc(userId).update({
      ...updates,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteUser(String userId) async {
    await _firestore.collection(usersCollection).doc(userId).delete();
  }

  // Restaurants
  Future<void> createRestaurant(Restaurant restaurant) async {
    await _firestore.collection(restaurantsCollection).doc(restaurant.id).set({
      ...restaurant.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Restaurant?> getRestaurant(String restaurantId) async {
    final doc = await _firestore
        .collection(restaurantsCollection)
        .doc(restaurantId)
        .get();
    if (!doc.exists) return null;
    return Restaurant.fromJson(doc.data()!);
  }

  Future<List<Restaurant>> getRestaurants({
    int limit = 20,
    DocumentSnapshot? startAfter,
    String? cuisine,
    double? minRating,
    double? maxDistance,
    String? sortBy = 'rating', // rating, distance, priceLevel, tawseyaCount
    bool descending = true,
  }) async {
    Query query = _firestore.collection(restaurantsCollection);

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

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => Restaurant.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Restaurant>> searchRestaurants(
    String query, {
    int limit = 20,
    DocumentSnapshot? startAfter,
  }) async {
    // Note: Firestore doesn't support full-text search natively
    // For production, consider using Algolia or Elasticsearch
    // This is a basic implementation using array-contains for tags
    final snapshot = await _firestore
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
      {...updates, 'updatedAt': FieldValue.serverTimestamp()},
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
          'addedAt': FieldValue.serverTimestamp(),
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
    final snapshot = await _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(favoritesCollection)
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<bool> isFavorite(String userId, String restaurantId) async {
    final doc = await _firestore
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
        .set({...item.toJson(), 'addedAt': FieldValue.serverTimestamp()});
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
            'updatedAt': FieldValue.serverTimestamp(),
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
    final snapshot = await _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(cartCollection)
        .get();

    return snapshot.docs.map((doc) => CartItem.fromJson(doc.data())).toList();
  }

  Future<void> clearCart(String userId) async {
    final batch = _firestore.batch();
    final snapshot = await _firestore
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
    final docRef = _firestore.collection(ordersCollection).doc();
    await docRef.set({
      ...orderData,
      'id': docRef.id,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  Future<Map<String, dynamic>?> getOrder(String orderId) async {
    final doc = await _firestore
        .collection(ordersCollection)
        .doc(orderId)
        .get();
    return doc.data();
  }

  Future<List<Map<String, dynamic>>> getUserOrders(
    String userId, {
    int limit = 20,
    DocumentSnapshot? startAfter,
  }) async {
    Query query = _firestore
        .collection(ordersCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<void> updateOrder(String orderId, Map<String, dynamic> updates) async {
    await _firestore.collection(ordersCollection).doc(orderId).update({
      ...updates,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Real-time listeners
  Stream<List<Restaurant>> getRestaurantsStream({
    int limit = 20,
    String? cuisine,
    double? minRating,
  }) {
    Query query = _firestore.collection(restaurantsCollection).limit(limit);

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

  Stream<List<CartItem>> getCartStream(String userId) {
    return _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(cartCollection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CartItem.fromJson(doc.data()))
              .toList(),
        );
  }

  Stream<List<String>> getFavoritesStream(String userId) {
    return _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(favoritesCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  // Utility methods
  Future<void> batchWrite(List<WriteBatch> operations) async {
    final batch = _firestore.batch();
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
      final cartSnapshot = await _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection(cartCollection)
          .get();

      for (final doc in cartSnapshot.docs) {
        transaction.delete(doc.reference);
      }

      // Create order
      final orderRef = _firestore.collection(ordersCollection).doc();
      transaction.set(orderRef, {
        'id': orderRef.id,
        'userId': userId,
        'items': items.map((item) => item.toJson()).toList(),
        'total': total,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
