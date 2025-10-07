class OrderHistory {
  const OrderHistory({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantCuisine,
    required this.orderItems,
    required this.totalAmount,
    required this.orderDate,
    required this.rating,
    this.review,
  });

  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final String restaurantCuisine;
  final List<OrderItem> orderItems;
  final double totalAmount;
  final DateTime orderDate;
  final double? rating;
  final String? review;

  OrderHistory copyWith({
    String? id,
    String? userId,
    String? restaurantId,
    String? restaurantName,
    String? restaurantCuisine,
    List<OrderItem>? orderItems,
    double? totalAmount,
    DateTime? orderDate,
    double? rating,
    String? review,
  }) {
    return OrderHistory(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantCuisine: restaurantCuisine ?? this.restaurantCuisine,
      orderItems: orderItems ?? this.orderItems,
      totalAmount: totalAmount ?? this.totalAmount,
      orderDate: orderDate ?? this.orderDate,
      rating: rating ?? this.rating,
      review: review ?? this.review,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'restaurantCuisine': restaurantCuisine,
      'orderItems': orderItems.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(),
      'rating': rating,
      'review': review,
    };
  }

  factory OrderHistory.fromJson(Map<String, dynamic> json) {
    return OrderHistory(
      id: json['id'] as String,
      userId: json['userId'] as String,
      restaurantId: json['restaurantId'] as String,
      restaurantName: json['restaurantName'] as String,
      restaurantCuisine: json['restaurantCuisine'] as String,
      orderItems: (json['orderItems'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      orderDate: DateTime.parse(json['orderDate'] as String),
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      review: json['review'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderHistory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'OrderHistory(id: $id, restaurantId: $restaurantId, restaurantName: $restaurantName, totalAmount: $totalAmount)';
  }
}

class OrderItem {
  const OrderItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.category,
  });

  final String id;
  final String name;
  final double price;
  final int quantity;
  final String? category;

  double get totalPrice => price * quantity;

  OrderItem copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? category,
  }) {
    return OrderItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'category': category,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      category: json['category'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'OrderItem(id: $id, name: $name, price: $price, quantity: $quantity)';
  }
}