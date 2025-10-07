import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_voting_results.dart';
import '../providers/tawseya_provider.dart';

class TawseyaResultsDisplay extends ConsumerStatefulWidget {
  const TawseyaResultsDisplay({super.key});

  @override
  ConsumerState<TawseyaResultsDisplay> createState() =>
      _TawseyaResultsDisplayState();
}

class _TawseyaResultsDisplayState extends ConsumerState<TawseyaResultsDisplay> {
  VotingResults? _votingResults;

  @override
  void initState() {
    super.initState();
    _loadVotingResults();
  }

  Future<void> _loadVotingResults() async {
    try {
      final repository = ref.read(tawseyaRepositoryProvider);
      final getVotingResults = GetVotingResults(repository);
      final results = await getVotingResults();

      setState(() {
        _votingResults = results;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load voting results: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_votingResults == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Voting Results',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${_votingResults!.votingPeriod.displayName} • ${_votingResults!.totalVotes} total votes',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        // Results List
        if (_votingResults!.getSortedResults().isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: Text('No votes yet for this period')),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _votingResults!.getSortedResults().length,
            itemBuilder: (context, index) {
              final resultItem = _votingResults!.getSortedResults()[index];
              return TawseyaResultCard(
                resultItem: resultItem,
                rank: index + 1,
                totalVotes: _votingResults!.totalVotes,
              );
            },
          ),
      ],
    );
  }
}

class TawseyaResultCard extends StatelessWidget {
  final VotingResultItem resultItem;
  final int rank;
  final int totalVotes;

  const TawseyaResultCard({
    super.key,
    required this.resultItem,
    required this.rank,
    required this.totalVotes,
  });

  @override
  Widget build(BuildContext context) {
    final item = resultItem.tawseyaItem;
    final voteCount = resultItem.voteCount;
    final percentage = totalVotes > 0 ? (voteCount / totalVotes) * 100 : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: _getRankColor(rank),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getRankBorderColor(rank), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Rank
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getRankIconColor(rank),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  rank.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item?.name ?? 'Unknown Item',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (item?.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      item!.description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Vote Count and Progress
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$voteCount votes',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getRankIconColor(rank),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFF3E0); // Light gold
      case 2:
        return const Color(0xFFF3E5F5); // Light silver
      case 3:
        return const Color(0xFFE8F5E8); // Light bronze
      default:
        return Colors.grey[50]!;
    }
  }

  Color _getRankBorderColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.grey[300]!;
    }
  }

  Color _getRankIconColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.grey[400]!;
    }
  }
}
