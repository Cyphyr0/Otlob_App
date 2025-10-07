class TawseyaItem {

  const TawseyaItem({
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

  TawseyaItem copyWith({
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
  }) => TawseyaItem(
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

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool get canVote => isActive && !isExpired;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TawseyaItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}