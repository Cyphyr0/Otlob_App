import '../entities/tawseya_item.dart';
import '../entities/vote.dart';
import '../entities/voting_period.dart';

abstract class TawseyaRepository {
  // Voting operations
  Future<Vote> castVote(Vote vote);
  Future<Vote?> getUserVoteForPeriod({
    required String userId,
    required String votingPeriodId,
  });

  // Tawseya items operations
  Future<List<TawseyaItem>> getActiveTawseyaItems();
  Future<List<TawseyaItem>> getTawseyaItemsByCategory(String category);
  Future<TawseyaItem?> getTawseyaItemById(String id);

  // Voting periods operations
  Future<VotingPeriod?> getCurrentVotingPeriod();
  Future<VotingPeriod?> getVotingPeriodById(String id);
  Future<List<VotingPeriod>> getVotingPeriods();

  // Results and statistics
  Future<List<Vote>> getVotesForPeriod(String votingPeriodId);
  Future<List<Vote>> getVotesForTawseyaItem(String tawseyaItemId);
  Future<Map<String, int>> getVotingResults(String votingPeriodId);

  // User voting history
  Future<List<Vote>> getUserVotingHistory(String userId);
  Future<bool> hasUserVotedInPeriod({
    required String userId,
    required String votingPeriodId,
  });
}