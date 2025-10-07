import 'package:cloud_firestore/cloud_firestore.dart';

class VotingPeriodModel {

  VotingPeriodModel({
    required this.id,
    required this.month,
    required this.year,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.createdAt,
    this.totalVotes = 0,
  });

  factory VotingPeriodModel.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return VotingPeriodModel(
      id: doc.id,
      month: data['month'] ?? 1,
      year: data['year'] ?? DateTime.now().year,
      startDate: (data['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (data['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: data['isActive'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      totalVotes: data['totalVotes'] ?? 0,
    );
  }
  final String id;
  final int month;
  final int year;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final DateTime createdAt;
  final int totalVotes;

  Map<String, dynamic> toFirestore() => {
      'month': month,
      'year': year,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'totalVotes': totalVotes,
    };

  // Helper method to get current voting period ID
  static String getCurrentPeriodId() {
    var now = DateTime.now();
    return '${now.year}_${now.month.toString().padLeft(2, '0')}';
  }

  // Helper method to check if a date falls within this voting period
  bool isDateInPeriod(DateTime date) => date.isAfter(startDate.subtract(const Duration(days: 1))) &&
           date.isBefore(endDate.add(const Duration(days: 1)));

  // Helper method to get period display name
  String getDisplayName() => '${_getMonthName(month)} $year';

  String _getMonthName(int month) {
    const monthNames = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    return monthNames[month - 1];
  }

  VotingPeriodModel copyWith({
    String? id,
    int? month,
    int? year,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    DateTime? createdAt,
    int? totalVotes,
  }) => VotingPeriodModel(
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