class VotingPeriod {
  final String id;
  final int month;
  final int year;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final DateTime createdAt;
  final int totalVotes;

  const VotingPeriod({
    required this.id,
    required this.month,
    required this.year,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.createdAt,
    this.totalVotes = 0,
  });

  VotingPeriod copyWith({
    String? id,
    int? month,
    int? year,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    DateTime? createdAt,
    int? totalVotes,
  }) {
    return VotingPeriod(
      id: id ?? this.id,
      month: month ?? this.month,
      year: year ?? this.year,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      totalVotes: totalVotes ?? this.totalVotes,
    );
  }

  bool get isCurrentPeriod {
    DateTime now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  bool get hasEnded {
    return DateTime.now().isAfter(endDate);
  }

  bool get isUpcoming {
    return DateTime.now().isBefore(startDate);
  }

  String get displayName {
    const monthNames = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return '${monthNames[month - 1]} $year';
  }

  static String getCurrentPeriodId() {
    DateTime now = DateTime.now();
    return '${now.year}_${now.month.toString().padLeft(2, '0')}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VotingPeriod && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}