import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/wallet.dart';

class WalletModel {

  WalletModel({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  factory WalletModel.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return WalletModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      balance: (data['balance'] as num?)?.toDouble() ?? 0.0,
      currency: data['currency'] ?? 'EGP',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: data['isActive'] ?? true,
    );
  }

  factory WalletModel.fromEntity(Wallet wallet) => WalletModel(
      id: wallet.id,
      userId: wallet.userId,
      balance: wallet.balance,
      currency: wallet.currency,
      createdAt: wallet.createdAt,
      updatedAt: wallet.updatedAt,
      isActive: wallet.isActive,
    );
  final String id;
  final String userId;
  final double balance;
  final String currency;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  Map<String, dynamic> toFirestore() => {
      'userId': userId,
      'balance': balance,
      'currency': currency,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
    };

  Wallet toEntity() => Wallet(
      id: id,
      userId: userId,
      balance: balance,
      currency: currency,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isActive: isActive,
    );

  WalletModel copyWith({
    String? id,
    String? userId,
    double? balance,
    String? currency,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) => WalletModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
}