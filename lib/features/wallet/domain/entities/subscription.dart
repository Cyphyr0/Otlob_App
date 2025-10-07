enum SubscriptionStatus {
  active,
  cancelled,
  expired,
  paused,
  pending,
}

enum SubscriptionType {
  monthly,
  yearly,
  weekly,
}

class Subscription {
  const Subscription({
    required this.id,
    required this.userId,
    required this.walletId,
    required this.type,
    required this.status,
    required this.amount,
    required this.currency,
    required this.startDate,
    required this.endDate,
    this.nextBillingDate,
    this.cancelledAt,
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
      id: json['id'] as String,
      userId: json['userId'] as String,
      walletId: json['walletId'] as String,
      type: SubscriptionType.values.firstWhere(
        (e) => e.name == json['type'] as String,
      ),
      status: SubscriptionStatus.values.firstWhere(
        (e) => e.name == json['status'] as String,
      ),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      nextBillingDate: json['nextBillingDate'] != null
          ? DateTime.parse(json['nextBillingDate'] as String)
          : null,
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'] as String)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );

  final String id;
  final String userId;
  final String walletId;
  final SubscriptionType type;
  final SubscriptionStatus status;
  final double amount;
  final String currency;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? nextBillingDate;
  final DateTime? cancelledAt;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Subscription copyWith({
    String? id,
    String? userId,
    String? walletId,
    SubscriptionType? type,
    SubscriptionStatus? status,
    double? amount,
    String? currency,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? nextBillingDate,
    DateTime? cancelledAt,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Subscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      walletId: walletId ?? this.walletId,
      type: type ?? this.type,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );

  Map<String, dynamic> toJson() => {
      'id': id,
      'userId': userId,
      'walletId': walletId,
      'type': type.name,
      'status': status.name,
      'amount': amount,
      'currency': currency,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'nextBillingDate': nextBillingDate?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'metadata': metadata,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };

  bool get isActive => status == SubscriptionStatus.active;
  bool get isExpired => endDate.isBefore(DateTime.now());
  bool get isCancelled => status == SubscriptionStatus.cancelled;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Subscription && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Subscription(id: $id, type: $type, status: $status, amount: $amount $currency)';
}