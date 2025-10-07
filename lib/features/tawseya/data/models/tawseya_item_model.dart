import 'package:cloud_firestore/cloud_firestore.dart';

class TawseyaItemModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String category;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final int totalVotes;
  final double averageRating;

  TawseyaItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.isActive,
    required this.createdAt,
    this.expiresAt,
    this.totalVotes = 0,
    this.averageRating = 0.0,
  });

  factory TawseyaItemModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TawseyaItemModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiresAt: data['expiresAt'] != null ? (data['expiresAt'] as Timestamp).toDate() : null,
      totalVotes: data['totalVotes'] ?? 0,
      averageRating: (data['averageRating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      if (expiresAt != null) 'expiresAt': Timestamp.fromDate(expiresAt!),
      'totalVotes': totalVotes,
      'averageRating': averageRating,
    };
  }

  TawseyaItemModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? category,
    bool? isActive,
    DateTime? createdAt,
    DateTime? expiresAt,
    int? totalVotes,
    double? averageRating,
  }) {
    return TawseyaItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      totalVotes: totalVotes ?? this.totalVotes,
      averageRating: averageRating ?? this.averageRating,
    );
  }
}