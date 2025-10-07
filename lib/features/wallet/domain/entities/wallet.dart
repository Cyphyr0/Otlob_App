class Wallet {
  const Wallet({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
      id: json['id'] as String,
      userId: json['userId'] as String,
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );

  final String id;
  final String userId;
  final double balance;
  final String currency;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  Wallet copyWith({
    String? id,
    String? userId,
    double? balance,
    String? currency,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) => Wallet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );

  Map<String, dynamic> toJson() => {
      'id': id,
      'userId': userId,
      'balance': balance,
      'currency': currency,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
    };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Wallet && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Wallet(id: $id, userId: $userId, balance: $balance $currency)';
}