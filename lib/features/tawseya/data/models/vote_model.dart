import 'package:cloud_firestore/cloud_firestore.dart';

class VoteModel {

  VoteModel({
    required this.id,
    required this.userId,
    required this.tawseyaItemId,
    required this.votingPeriodId,
    required this.createdAt,
    this.comment,
  });

  factory VoteModel.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return VoteModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      tawseyaItemId: data['tawseyaItemId'] ?? '',
      votingPeriodId: data['votingPeriodId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      comment: data['comment'],
    );
  }
  final String id;
  final String userId;
  final String tawseyaItemId;
  final String votingPeriodId;
  final DateTime createdAt;
  final String? comment;

  Map<String, dynamic> toFirestore() => {
      'userId': userId,
      'tawseyaItemId': tawseyaItemId,
      'votingPeriodId': votingPeriodId,
      'createdAt': Timestamp.fromDate(createdAt),
      if (comment != null) 'comment': comment,
    };

  VoteModel copyWith({
    String? id,
    String? userId,
    String? tawseyaItemId,
    String? votingPeriodId,
    DateTime? createdAt,
    String? comment,
  }) => VoteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tawseyaItemId: tawseyaItemId ?? this.tawseyaItemId,
      votingPeriodId: votingPeriodId ?? this.votingPeriodId,
      createdAt: createdAt ?? this.createdAt,
      comment: comment ?? this.comment,
    );
}