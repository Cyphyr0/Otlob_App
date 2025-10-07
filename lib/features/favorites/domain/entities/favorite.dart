class Favorite {
  const Favorite({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantImageUrl,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final String? restaurantImageUrl;
  final DateTime createdAt;

  Favorite copyWith({
    String? id,
    String? userId,
    String? restaurantId,
    String? restaurantName,
    String? restaurantImageUrl,
    DateTime? createdAt,
  }) {
    return Favorite(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantImageUrl: restaurantImageUrl ?? this.restaurantImageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'restaurantImageUrl': restaurantImageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'] as String,
      userId: json['userId'] as String,
      restaurantId: json['restaurantId'] as String,
      restaurantName: json['restaurantName'] as String,
      restaurantImageUrl: json['restaurantImageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Favorite && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Favorite(id: $id, restaurantId: $restaurantId, restaurantName: $restaurantName)';
  }
}