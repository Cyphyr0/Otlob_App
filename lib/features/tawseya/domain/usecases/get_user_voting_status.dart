import '../entities/vote.dart';
import '../entities/voting_period.dart';
import '../repositories/tawseya_repository.dart';

class GetUserVotingStatus {
  final TawseyaRepository repository;

  const GetUserVotingStatus(this.repository);

  Future<UserVotingStatus> call(String userId) async {
    final currentPeriod = await repository.getCurrentVotingPeriod();

    if (currentPeriod == null) {
      throw NoActiveVotingPeriodException(
        'No active voting period found',
      );
    }

    final userVote = await repository.getUserVoteForPeriod(
      userId: userId,
      votingPeriodId: currentPeriod.id,
    );

    final userHistory = await repository.getUserVotingHistory(userId);

    return UserVotingStatus(
      currentPeriod: currentPeriod,
      hasVotedInCurrentPeriod: userVote != null,
      currentVote: userVote,
      totalVotesCast: userHistory.length,
    );
  }
}

class UserVotingStatus {
  final VotingPeriod currentPeriod;
  final bool hasVotedInCurrentPeriod;
  final Vote? currentVote;
  final int totalVotesCast;

  const UserVotingStatus({
    required this.currentPeriod,
    required this.hasVotedInCurrentPeriod,
    this.currentVote,
    required this.totalVotesCast,
  });

  bool get canVote => currentPeriod.isCurrentPeriod && !hasVotedInCurrentPeriod;
}

class NoActiveVotingPeriodException implements Exception {
  final String message;
  const NoActiveVotingPeriodException(this.message);
}