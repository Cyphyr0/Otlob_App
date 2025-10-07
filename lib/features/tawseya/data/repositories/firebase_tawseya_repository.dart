import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/tawseya_item.dart';
import '../../domain/entities/vote.dart';
import '../../domain/entities/voting_period.dart';
import '../../domain/repositories/tawseya_repository.dart';
import '../../domain/services/tawseya_notification_service.dart';
import '../models/tawseya_item_model.dart';
import '../models/vote_model.dart';
import '../models/voting_period_model.dart';

class FirebaseTawseyaRepository implements TawseyaRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  static const String tawseyaItemsCollection = 'tawseya_items';
  static const String votesCollection = 'votes';
  static const String votingPeriodsCollection = 'voting_periods';

  @override
  Future<Vote> castVote(Vote vote) async {
    final voteModel = VoteModel(
      id: vote.id.isEmpty ? _firestore.collection(votesCollection).doc().id : vote.id,
      userId: vote.userId,
      tawseyaItemId: vote.tawseyaItemId,
      votingPeriodId: vote.votingPeriodId,
      createdAt: vote.createdAt,
      comment: vote.comment,
    );

    await _firestore
        .collection(votesCollection)
        .doc(voteModel.id)
        .set(voteModel.toFirestore());

    // Update vote counts
    await _updateVoteCounts(vote.votingPeriodId, vote.tawseyaItemId);

    // Send notification for successful vote
    try {
      await TawseyaNotificationService.sendVotingMilestoneNotification(
        voteCount: await _getUserVoteCount(vote.userId),
        imageUrl: null, // Will be updated when we have tawseya item image
      );
    } catch (e) {
      print('Error sending vote milestone notification: $e');
      // Don't throw error to avoid breaking the vote flow
    }

    return vote.copyWith(id: voteModel.id);
  }

  @override
  Future<Vote?> getUserVoteForPeriod({
    required String userId,
    required String votingPeriodId,
  }) async {
    final snapshot = await _firestore
        .collection(votesCollection)
        .where('userId', isEqualTo: userId)
        .where('votingPeriodId', isEqualTo: votingPeriodId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return _voteModelToEntity(VoteModel.fromFirestore(snapshot.docs.first));
  }

  @override
  Future<List<TawseyaItem>> getActiveTawseyaItems() async {
    final snapshot = await _firestore
        .collection(tawseyaItemsCollection)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map(TawseyaItemModel.fromFirestore)
        .map(_tawseyaItemModelToEntity)
        .toList();
  }

  @override
  Future<List<TawseyaItem>> getTawseyaItemsByCategory(String category) async {
    final snapshot = await _firestore
        .collection(tawseyaItemsCollection)
        .where('category', isEqualTo: category)
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map(TawseyaItemModel.fromFirestore)
        .map(_tawseyaItemModelToEntity)
        .toList();
  }

  @override
  Future<TawseyaItem?> getTawseyaItemById(String id) async {
    final doc = await _firestore.collection(tawseyaItemsCollection).doc(id).get();

    if (!doc.exists) return null;

    return _tawseyaItemModelToEntity(TawseyaItemModel.fromFirestore(doc));
  }

  @override
  Future<VotingPeriod?> getCurrentVotingPeriod() async {
    final currentPeriodId = VotingPeriod.getCurrentPeriodId();

    final doc = await _firestore
        .collection(votingPeriodsCollection)
        .doc(currentPeriodId)
        .get();

    if (!doc.exists) return null;

    return _votingPeriodModelToEntity(VotingPeriodModel.fromFirestore(doc));
  }

  @override
  Future<VotingPeriod?> getVotingPeriodById(String id) async {
    final doc = await _firestore.collection(votingPeriodsCollection).doc(id).get();

    if (!doc.exists) return null;

    return _votingPeriodModelToEntity(VotingPeriodModel.fromFirestore(doc));
  }

  @override
  Future<List<VotingPeriod>> getVotingPeriods() async {
    final snapshot = await _firestore
        .collection(votingPeriodsCollection)
        .orderBy('year', descending: true)
        .orderBy('month', descending: true)
        .get();

    return snapshot.docs
        .map(VotingPeriodModel.fromFirestore)
        .map(_votingPeriodModelToEntity)
        .toList();
  }

  @override
  Future<List<Vote>> getVotesForPeriod(String votingPeriodId) async {
    final snapshot = await _firestore
        .collection(votesCollection)
        .where('votingPeriodId', isEqualTo: votingPeriodId)
        .get();

    return snapshot.docs
        .map(VoteModel.fromFirestore)
        .map(_voteModelToEntity)
        .toList();
  }

  @override
  Future<List<Vote>> getVotesForTawseyaItem(String tawseyaItemId) async {
    final snapshot = await _firestore
        .collection(votesCollection)
        .where('tawseyaItemId', isEqualTo: tawseyaItemId)
        .get();

    return snapshot.docs
        .map(VoteModel.fromFirestore)
        .map(_voteModelToEntity)
        .toList();
  }

  @override
  Future<Map<String, int>> getVotingResults(String votingPeriodId) async {
    final votes = await getVotesForPeriod(votingPeriodId);

    final results = <String, int>{};
    for (final vote in votes) {
      results[vote.tawseyaItemId] = (results[vote.tawseyaItemId] ?? 0) + 1;
    }

    return results;
  }

  @override
  Future<List<Vote>> getUserVotingHistory(String userId) async {
    final snapshot = await _firestore
        .collection(votesCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map(VoteModel.fromFirestore)
        .map(_voteModelToEntity)
        .toList();
  }

  @override
  Future<bool> hasUserVotedInPeriod({
    required String userId,
    required String votingPeriodId,
  }) async {
    final vote = await getUserVoteForPeriod(
      userId: userId,
      votingPeriodId: votingPeriodId,
    );
    return vote != null;
  }

  // Helper methods
  Future<void> _updateVoteCounts(String votingPeriodId, String tawseyaItemId) async {
    // Update tawseya item vote count
    final itemRef = _firestore.collection(tawseyaItemsCollection).doc(tawseyaItemId);
    await _firestore.runTransaction((transaction) async {
      final itemDoc = await transaction.get(itemRef);
      if (itemDoc.exists) {
        final currentVotes = itemDoc.data()?['totalVotes'] ?? 0;
        transaction.update(itemRef, {'totalVotes': currentVotes + 1});
      }
    });

    // Update voting period vote count
    final periodRef = _firestore.collection(votingPeriodsCollection).doc(votingPeriodId);
    await _firestore.runTransaction((transaction) async {
      final periodDoc = await transaction.get(periodRef);
      if (periodDoc.exists) {
        final currentVotes = periodDoc.data()?['totalVotes'] ?? 0;
        transaction.update(periodRef, {'totalVotes': currentVotes + 1});
      }
    });
  }

  Future<int> _getUserVoteCount(String userId) async {
    final snapshot = await _firestore
        .collection(votesCollection)
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.length;
  }

  // Entity converters
  TawseyaItem _tawseyaItemModelToEntity(TawseyaItemModel model) => TawseyaItem(
      id: model.id,
      name: model.name,
      description: model.description,
      imageUrl: model.imageUrl,
      category: model.category,
      isActive: model.isActive,
      createdAt: model.createdAt,
      expiresAt: model.expiresAt,
      totalVotes: model.totalVotes,
      averageRating: model.averageRating,
    );

  Vote _voteModelToEntity(VoteModel model) => Vote(
      id: model.id,
      userId: model.userId,
      tawseyaItemId: model.tawseyaItemId,
      votingPeriodId: model.votingPeriodId,
      createdAt: model.createdAt,
      comment: model.comment,
    );

  VotingPeriod _votingPeriodModelToEntity(VotingPeriodModel model) => VotingPeriod(
      id: model.id,
      month: model.month,
      year: model.year,
      startDate: model.startDate,
      endDate: model.endDate,
      isActive: model.isActive,
      createdAt: model.createdAt,
      totalVotes: model.totalVotes,
    );
}