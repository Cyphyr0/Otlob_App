import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/badges/tawseya_badge.dart';
import '../../domain/entities/tawseya_item.dart';
import '../providers/tawseya_provider.dart';

class TawseyaVotingStatusBadge extends ConsumerWidget {
  final TawseyaItem tawseyaItem;
  final BadgeSize size;

  const TawseyaVotingStatusBadge({
    super.key,
    required this.tawseyaItem,
    this.size = BadgeSize.medium,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tawseyaState = ref.watch(tawseyaProvider);
    final canVote = ref.watch(canVoteProvider);

    return tawseyaState.when(
      data: (state) {
        // Check if user has voted for this specific item
        final hasVotedForThisItem = state.userCurrentVote?.tawseyaItemId == tawseyaItem.id;

        if (hasVotedForThisItem) {
          return _VotedBadge(
            size: size,
            voteCount: tawseyaItem.totalVotes,
          );
        } else if (canVote && tawseyaItem.canVote) {
          return _CanVoteBadge(
            size: size,
            voteCount: tawseyaItem.totalVotes,
          );
        } else {
          return TawseyaBadge(
            count: tawseyaItem.totalVotes,
            size: size,
            animated: false,
          );
        }
      },
      loading: () => TawseyaBadge(
        count: tawseyaItem.totalVotes,
        size: size,
        animated: false,
      ),
      error: (error, stackTrace) => TawseyaBadge(
        count: tawseyaItem.totalVotes,
        size: size,
        animated: false,
      ),
    );
  }
}

class _VotedBadge extends StatelessWidget {
   final BadgeSize size;
   final int voteCount;

   const _VotedBadge({
     required this.size,
     required this.voteCount,
   });

   @override
   Widget build(BuildContext context) {
     return Container(
       padding: _getPaddingForSize(size),
       decoration: BoxDecoration(
         color: Colors.green[100],
         borderRadius: BorderRadius.circular(8),
         border: Border.all(
           color: Colors.green,
           width: 1.5,
         ),
       ),
       child: Row(
         mainAxisSize: MainAxisSize.min,
         children: [
           Icon(
             Icons.check_circle,
             size: _getIconSizeForSize(size),
             color: Colors.green,
           ),
           if (voteCount > 0) ...[
             SizedBox(width: _getSpacingForSize(size)),
             Text(
               _formatCount(voteCount),
               style: TextStyle(
                 fontSize: _getFontSizeForSize(size),
                 color: Colors.green,
                 fontWeight: FontWeight.w700,
               ),
             ),
           ],
         ],
       ),
     );
   }

   static String _formatCount(int count) {
     if (count >= 1000) {
       return "${(count / 1000).toStringAsFixed(1)}k";
     }
     return count.toString();
   }

   static double _getIconSizeForSize(BadgeSize size) {
     switch (size) {
       case BadgeSize.small:
         return 12;
       case BadgeSize.medium:
         return 14;
       case BadgeSize.large:
         return 16;
     }
   }

   static double _getFontSizeForSize(BadgeSize size) {
     switch (size) {
       case BadgeSize.small:
         return 10;
       case BadgeSize.medium:
         return 11;
       case BadgeSize.large:
         return 12;
     }
   }

   static EdgeInsets _getPaddingForSize(BadgeSize size) {
     switch (size) {
       case BadgeSize.small:
         return const EdgeInsets.symmetric(horizontal: 6, vertical: 2);
       case BadgeSize.medium:
         return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
       case BadgeSize.large:
         return const EdgeInsets.symmetric(horizontal: 10, vertical: 6);
     }
   }

   static double _getSpacingForSize(BadgeSize size) {
     switch (size) {
       case BadgeSize.small:
         return 4;
       case BadgeSize.medium:
         return 4;
       case BadgeSize.large:
         return 6;
     }
   }
 }

class _CanVoteBadge extends StatelessWidget {
  final BadgeSize size;
  final int voteCount;

  const _CanVoteBadge({
    required this.size,
    required this.voteCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _getPaddingForSize(size),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFFFD700),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.how_to_vote,
            size: _getIconSizeForSize(size),
            color: const Color(0xFFFFD700),
          ),
          if (voteCount > 0) ...[
            SizedBox(width: _getSpacingForSize(size)),
            Text(
              _formatCount(voteCount),
              style: TextStyle(
                fontSize: _getFontSizeForSize(size),
                color: const Color(0xFFFFD700),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _formatCount(int count) {
    if (count >= 1000) {
      return "${(count / 1000).toStringAsFixed(1)}k";
    }
    return count.toString();
  }

  static double _getIconSizeForSize(BadgeSize size) {
    switch (size) {
      case BadgeSize.small:
        return 12;
      case BadgeSize.medium:
        return 14;
      case BadgeSize.large:
        return 16;
    }
  }

  static double _getFontSizeForSize(BadgeSize size) {
    switch (size) {
      case BadgeSize.small:
        return 10;
      case BadgeSize.medium:
        return 11;
      case BadgeSize.large:
        return 12;
    }
  }

  static EdgeInsets _getPaddingForSize(BadgeSize size) {
    switch (size) {
      case BadgeSize.small:
        return const EdgeInsets.symmetric(horizontal: 6, vertical: 2);
      case BadgeSize.medium:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case BadgeSize.large:
        return const EdgeInsets.symmetric(horizontal: 10, vertical: 6);
    }
  }

  static double _getSpacingForSize(BadgeSize size) {
    switch (size) {
      case BadgeSize.small:
        return 4;
      case BadgeSize.medium:
        return 4;
      case BadgeSize.large:
        return 6;
    }
  }
}