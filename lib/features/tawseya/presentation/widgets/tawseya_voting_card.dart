import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../domain/entities/tawseya_item.dart';
import '../providers/tawseya_provider.dart';

class TawseyaVotingCard extends ConsumerWidget {

  const TawseyaVotingCard({
    required this.tawseyaItem, super.key,
    this.onVote,
  });
  final TawseyaItem tawseyaItem;
  final VoidCallback? onVote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canVote = ref.watch(canVoteProvider);
    final isLoading = ref.watch(tawseyaLoadingProvider);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              image: DecorationImage(
                image: NetworkImage(tawseyaItem.imageUrl),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  // Handle image loading error
                },
              ),
            ),
          ),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Category
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tawseyaItem.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(tawseyaItem.category).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getCategoryColor(tawseyaItem.category),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        tawseyaItem.category,
                        style: TextStyle(
                          color: _getCategoryColor(tawseyaItem.category),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Description
                Text(
                  tawseyaItem.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 16),

                // Vote Count and Rating
                Row(
                  children: [
                    Icon(
                      Icons.how_to_vote,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${tawseyaItem.totalVotes} votes',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.star,
                      size: 20,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      tawseyaItem.averageRating.toStringAsFixed(1),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Vote Button
                if (canVote && tawseyaItem.canVote)
                  PrimaryButton(
                    onPressed: isLoading ? null : () => _handleVote(context, ref),
                    text: 'Vote for this Tawseya',
                    isLoading: isLoading,
                    icon: Icons.how_to_vote,
                  )
                else if (tawseyaItem.canVote == false)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tawseyaItem.isExpired ? 'Voting period ended' : 'Not available',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Already voted this month',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleVote(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(tawseyaProvider.notifier).castVote(tawseyaItem);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully voted for ${tawseyaItem.name}!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      onVote?.call();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to vote: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'restaurant':
        return Colors.red;
      case 'service':
        return Colors.blue;
      case 'experience':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TawseyaItem>('tawseyaItem', tawseyaItem));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onVote', onVote));
  }
}