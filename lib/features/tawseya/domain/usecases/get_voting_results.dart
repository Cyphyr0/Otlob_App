import '../entities/tawseya_item.dart';
import '../entities/voting_period.dart';
import '../repositories/tawseya_repository.dart';

class GetVotingResults {
  final TawseyaRepository repository;

  const GetVotingResults(this.repository);

  Future<VotingResults> call({String? votingPeriodId}) async {
    final periodId = votingPeriodId ?? VotingPeriod.getCurrentPeriodId();
    final period = await repository.getVotingPeriodById(periodId);

    if (period == null) {
      throw VotingPeriodNotFoundException(
        'Voting period with ID $periodId not found',
      );
    }

    final results = await repository.getVotingResults(periodId);
    final votes = await repository.getVotesForPeriod(periodId);
    final items = await repository.getActiveTawseyaItems();

    return VotingResults(
      votingPeriod: period,
      results: results,
      totalVotes: votes.length,
      tawseyaItems: items,
    );
  }
}

class VotingResults {
  final VotingPeriod votingPeriod;
  final Map<String, int> results;
  final int totalVotes;
  final List<TawseyaItem> tawseyaItems;

  const VotingResults({
    required this.votingPeriod,
    required this.results,
    required this.totalVotes,
    required this.tawseyaItems,
  });

  List<VotingResultItem> getSortedResults() {
    final resultItems = results.entries.map((entry) {
      final item = tawseyaItems.where((item) => item.id == entry.key).firstOrNull;
      return VotingResultItem(
        tawseyaItem: item,
        voteCount: entry.value,
      );
    }).where((item) => item.tawseyaItem != null).toList();

    resultItems.sort((a, b) => b.voteCount.compareTo(a.voteCount));
    return resultItems;
  }
}

class VotingResultItem {
  final TawseyaItem? tawseyaItem;
  final int voteCount;

  const VotingResultItem({
    this.tawseyaItem,
    required this.voteCount,
  });
}

class VotingPeriodNotFoundException implements Exception {
  final String message;
  const VotingPeriodNotFoundException(this.message);
}

extension FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}