class Vote {

  const Vote({
    required this.id,
    required this.userId,
    required this.tawseyaItemId,
    required this.votingPeriodId,
    required this.createdAt,
    this.comment,
  });
  final String id;
  final String userId;
  final String tawseyaItemId;
  final String votingPeriodId;
  final DateTime createdAt;
  final String? comment;

  Vote copyWith({
    String? id,
    String? userId,
    String? tawseyaItemId,
    String? votingPeriodId,
    DateTime? createdAt,
    String? comment,
  }) => Vote(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tawseyaItemId: tawseyaItemId ?? this.tawseyaItemId,
      votingPeriodId: votingPeriodId ?? this.votingPeriodId,
      createdAt: createdAt ?? this.createdAt,
      comment: comment ?? this.comment,
    );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Vote &&
        other.id == id &&
        other.userId == userId &&
        other.tawseyaItemId == tawseyaItemId &&
        other.votingPeriodId == votingPeriodId;
  }

  @override
  int get hashCode => id.hashCode ^
        userId.hashCode ^
        tawseyaItemId.hashCode ^
        votingPeriodId.hashCode;
}