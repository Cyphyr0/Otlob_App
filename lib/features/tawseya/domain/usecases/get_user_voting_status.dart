import '../entities/vote.dart';
import '../entities/voting_period.dart';
import '../repositories/tawseya_repository.dart';

class GetUserVotingStatus {

  const GetUserVotingStatus(this.repository);
  final TawseyaRepository repository;

  Future<UserVotingStatus> call(String userId) async {
    final currentPeriod = await repository.getCurrentVotingPeriod();

    if (currentPeriod == null) {
      throw const NoActiveVotingPeriodException(
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

  const UserVotingStatus({
    required this.currentPeriod,
    required this.hasVotedInCurrentPeriod,
    required this.totalVotesCast, this.currentVote,
  });
  final VotingPeriod currentPeriod;
  final bool hasVotedInCurrentPeriod;
  final Vote? currentVote;
  final int totalVotesCast;

  bool get canVote => currentPeriod.isCurrentPeriod && !hasVotedInCurrentPeriod;
}

class NoActiveVotingPeriodException implements Exception {
  const NoActiveVotingPeriodException(this.message);
  final String message;
}