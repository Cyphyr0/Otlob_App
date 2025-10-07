enum TransactionType {
  topUp,
  payment,
  refund,
  subscription,
  cashback,
}

enum TransactionStatus {
  pending,
  completed,
  failed,
  cancelled,
}

class Transaction {
  const Transaction({
    required this.id,
    required this.walletId,
    required this.userId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.description,
    this.reference,
    this.metadata,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
      id: json['id'] as String,
      walletId: json['walletId'] as String,
      userId: json['userId'] as String,
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'] as String,
      ),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == json['status'] as String,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      description: json['description'] as String?,
      reference: json['reference'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

  final String id;
  final String walletId;
  final String userId;
  final TransactionType type;
  final double amount;
  final String currency;
  final TransactionStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? description;
  final String? reference;
  final Map<String, dynamic>? metadata;

  Transaction copyWith({
    String? id,
    String? walletId,
    String? userId,
    TransactionType? type,
    double? amount,
    String? currency,
    TransactionStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? description,
    String? reference,
    Map<String, dynamic>? metadata,
  }) => Transaction(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      description: description ?? this.description,
      reference: reference ?? this.reference,
      metadata: metadata ?? this.metadata,
    );

  Map<String, dynamic> toJson() => {
      'id': id,
      'walletId': walletId,
      'userId': userId,
      'type': type.name,
      'amount': amount,
      'currency': currency,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'description': description,
      'reference': reference,
      'metadata': metadata,
    };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Transaction && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Transaction(id: $id, type: $type, amount: $amount $currency, status: $status)';
}