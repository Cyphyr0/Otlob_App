import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../../domain/entities/subscription.dart';

class SubscriptionModel {
  final String id;
  final String userId;
  final String walletId;
  final String type;
  final String status;
  final double amount;
  final String currency;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? nextBillingDate;
  final DateTime? cancelledAt;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SubscriptionModel({
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

  factory SubscriptionModel.fromFirestore(firestore.DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SubscriptionModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      walletId: data['walletId'] ?? '',
      type: data['type'] ?? 'monthly',
      status: data['status'] ?? 'active',
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      currency: data['currency'] ?? 'EGP',
      startDate: (data['startDate'] as firestore.Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (data['endDate'] as firestore.Timestamp?)?.toDate() ?? DateTime.now(),
      nextBillingDate: (data['nextBillingDate'] as firestore.Timestamp?)?.toDate(),
      cancelledAt: (data['cancelledAt'] as firestore.Timestamp?)?.toDate(),
      metadata: data['metadata'] as Map<String, dynamic>?,
      createdAt: (data['createdAt'] as firestore.Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as firestore.Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'walletId': walletId,
      'type': type,
      'status': status,
      'amount': amount,
      'currency': currency,
      'startDate': firestore.Timestamp.fromDate(startDate),
      'endDate': firestore.Timestamp.fromDate(endDate),
      if (nextBillingDate != null) 'nextBillingDate': firestore.Timestamp.fromDate(nextBillingDate!),
      if (cancelledAt != null) 'cancelledAt': firestore.Timestamp.fromDate(cancelledAt!),
      if (metadata != null) 'metadata': metadata,
      if (createdAt != null) 'createdAt': firestore.Timestamp.fromDate(createdAt!),
      if (updatedAt != null) 'updatedAt': firestore.Timestamp.fromDate(updatedAt!),
    };
  }

  Subscription toEntity() {
    return Subscription(
      id: id,
      userId: userId,
      walletId: walletId,
      type: SubscriptionType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => SubscriptionType.monthly,
      ),
      status: SubscriptionStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => SubscriptionStatus.active,
      ),
      amount: amount,
      currency: currency,
      startDate: startDate,
      endDate: endDate,
      nextBillingDate: nextBillingDate,
      cancelledAt: cancelledAt,
      metadata: metadata,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory SubscriptionModel.fromEntity(Subscription subscription) {
    return SubscriptionModel(
      id: subscription.id,
      userId: subscription.userId,
      walletId: subscription.walletId,
      type: subscription.type.name,
      status: subscription.status.name,
      amount: subscription.amount,
      currency: subscription.currency,
      startDate: subscription.startDate,
      endDate: subscription.endDate,
      nextBillingDate: subscription.nextBillingDate,
      cancelledAt: subscription.cancelledAt,
      metadata: subscription.metadata,
      createdAt: subscription.createdAt,
      updatedAt: subscription.updatedAt,
    );
  }

  SubscriptionModel copyWith({
    String? id,
    String? userId,
    String? walletId,
    String? type,
    String? status,
    double? amount,
    String? currency,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? nextBillingDate,
    DateTime? cancelledAt,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionModel(
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
  }
}