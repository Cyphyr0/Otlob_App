import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../../domain/entities/transaction.dart';

class TransactionModel {
  final String id;
  final String walletId;
  final String userId;
  final String type;
  final double amount;
  final String currency;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? description;
  final String? reference;
  final Map<String, dynamic>? metadata;

  TransactionModel({
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

  factory TransactionModel.fromFirestore(firestore.DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      walletId: data['walletId'] ?? '',
      userId: data['userId'] ?? '',
      type: data['type'] ?? 'payment',
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      currency: data['currency'] ?? 'EGP',
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as firestore.Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as firestore.Timestamp?)?.toDate(),
      description: data['description'],
      reference: data['reference'],
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'walletId': walletId,
      'userId': userId,
      'type': type,
      'amount': amount,
      'currency': currency,
      'status': status,
      'createdAt': firestore.Timestamp.fromDate(createdAt),
      if (updatedAt != null) 'updatedAt': firestore.Timestamp.fromDate(updatedAt!),
      if (description != null) 'description': description,
      if (reference != null) 'reference': reference,
      if (metadata != null) 'metadata': metadata,
    };
  }

  Transaction toEntity() {
    return Transaction(
      id: id,
      walletId: walletId,
      userId: userId,
      type: TransactionType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => TransactionType.payment,
      ),
      amount: amount,
      currency: currency,
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => TransactionStatus.pending,
      ),
      createdAt: createdAt,
      updatedAt: updatedAt,
      description: description,
      reference: reference,
      metadata: metadata,
    );
  }

  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      walletId: transaction.walletId,
      userId: transaction.userId,
      type: transaction.type.name,
      amount: transaction.amount,
      currency: transaction.currency,
      status: transaction.status.name,
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
      description: transaction.description,
      reference: transaction.reference,
      metadata: transaction.metadata,
    );
  }

  TransactionModel copyWith({
    String? id,
    String? walletId,
    String? userId,
    String? type,
    double? amount,
    String? currency,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? description,
    String? reference,
    Map<String, dynamic>? metadata,
  }) {
    return TransactionModel(
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
  }
}