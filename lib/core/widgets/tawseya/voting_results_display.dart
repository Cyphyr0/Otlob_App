import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Tawseya Voting Results Display with Animated Progress
///
/// A comprehensive results visualization featuring:
/// - Animated progress bars for each rating level
/// - Emoji reaction statistics
/// - Community consensus indicators
/// - Monthly voting trends
/// - Cultural badge system integration
/// - Real-time result updates
///
/// Usage:
/// ```dart
/// TawseyaVotingResultsDisplay(
///   results: votingResults,
///   totalVotes: 1250,
///   userVote: currentUserVote,
///   showTrends: true,
///   culturalTheme: CulturalTheme.egyptian,
/// )
/// ```
class TawseyaVotingResultsDisplay extends StatefulWidget {
  const TawseyaVotingResultsDisplay({
    required this.results, required this.totalVotes, super.key,
    this.userVote,
    this.showTrends = true,
    this.culturalTheme,
    this.animationDuration = const Duration(milliseconds: 1000),
  });

  final VotingResults results;
  final int totalVotes;
  final Vote? userVote;
  final bool showTrends;
  final CulturalTheme? culturalTheme;
  final Duration animationDuration;

  @override
  State<TawseyaVotingResultsDisplay> createState() =>
      _TawseyaVotingResultsDisplayState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<VotingResults>('results', results));
    properties.add(IntProperty('totalVotes', totalVotes));
    properties.add(DiagnosticsProperty<Vote?>('userVote', userVote));
    properties.add(DiagnosticsProperty<bool>('showTrends', showTrends));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
    properties.add(DiagnosticsProperty<Duration>('animationDuration', animationDuration));
  }
}

class _TawseyaVotingResultsDisplayState
    extends State<TawseyaVotingResultsDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _progressAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _progressAnimations = List.generate(5, (index) => Tween<double>(
        begin: 0,
        end: widget.results.ratingDistribution[index] / widget.totalVotes,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.1,
            (index * 0.1) + 0.6,
            curve: Curves.easeOut,
          ),
        ),
      ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          _ResultsHeader(
            results: widget.results,
            totalVotes: widget.totalVotes,
            culturalTheme: widget.culturalTheme,
          ),

          SizedBox(height: AppSpacing.xl),

          // Rating distribution
          _RatingDistributionChart(
            results: widget.results,
            totalVotes: widget.totalVotes,
            animations: _progressAnimations,
            culturalTheme: widget.culturalTheme,
          ),

          SizedBox(height: AppSpacing.xl),

          // Emoji reactions summary
          _ReactionsSummary(
            results: widget.results,
            culturalTheme: widget.culturalTheme,
          ),

          // User vote indicator
          if (widget.userVote != null) ...[
            SizedBox(height: AppSpacing.lg),
            _UserVoteIndicator(
              vote: widget.userVote!,
              culturalTheme: widget.culturalTheme,
            ),
          ],

          // Voting trends (if enabled)
          if (widget.showTrends) ...[
            SizedBox(height: AppSpacing.lg),
            _VotingTrendsChart(
              results: widget.results,
              culturalTheme: widget.culturalTheme,
            ),
          ],
        ],
      ),
    );
}

/// Results header with overall stats
class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader({
    required this.results,
    required this.totalVotes,
    this.culturalTheme,
  });

  final VotingResults results;
  final int totalVotes;
  final CulturalTheme? culturalTheme;

  @override
  Widget build(BuildContext context) => Column(
      children: [
        // Cultural badge
        if (culturalTheme != null) ...[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: culturalTheme!.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: culturalTheme!.color,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  culturalTheme!.icon,
                  color: culturalTheme!.color,
                  size: 16.sp,
                ),
                SizedBox(width: AppSpacing.sm),
                Text(
                  'نتائج التوصية',
                  style: AppTypography.bodyMedium.copyWith(
                    color: culturalTheme!.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: AppSpacing.md),
        ],

        // Overall rating
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              results.averageRating.toStringAsFixed(1),
              style: AppTypography.displaySmall.copyWith(
                color: AppColors.primaryBlack,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Icon(
              Icons.star,
              color: AppColors.primaryGold,
              size: 32.sp,
            ),
          ],
        ),

        SizedBox(height: AppSpacing.sm),

        // Total votes
        Text(
          '$totalVotes تصويت من المجتمع',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.gray,
          ),
        ),

        // Consensus indicator
        SizedBox(height: AppSpacing.md),
        _ConsensusIndicator(
          consensus: results.consensus,
          culturalTheme: culturalTheme,
        ),
      ],
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<VotingResults>('results', results));
    properties.add(IntProperty('totalVotes', totalVotes));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
  }
}

/// Consensus strength indicator
class _ConsensusIndicator extends StatelessWidget {
  const _ConsensusIndicator({
    required this.consensus,
    this.culturalTheme,
  });

  final ConsensusStrength consensus;
  final CulturalTheme? culturalTheme;

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;
    IconData icon;

    switch (consensus) {
      case ConsensusStrength.strong:
        color = AppColors.success;
        text = 'إجماع قوي';
        icon = Icons.thumb_up;
        break;
      case ConsensusStrength.moderate:
        color = AppColors.warning;
        text = 'إجماع متوسط';
        icon = Icons.thumbs_up_down;
        break;
      case ConsensusStrength.weak:
        color = AppColors.gray;
        text = 'إجماع ضعيف';
        icon = Icons.help;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16.sp),
          SizedBox(width: AppSpacing.sm),
          Text(
            text,
            style: AppTypography.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<ConsensusStrength>('consensus', consensus));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
  }
}

/// Animated rating distribution chart
class _RatingDistributionChart extends StatelessWidget {
  const _RatingDistributionChart({
    required this.results,
    required this.totalVotes,
    required this.animations,
    this.culturalTheme,
  });

  final VotingResults results;
  final int totalVotes;
  final List<Animation<double>> animations;
  final CulturalTheme? culturalTheme;

  @override
  Widget build(BuildContext context) => Column(
      children: [
        // Section title
        Text(
          'توزيع التقييمات',
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.primaryBlack,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: AppSpacing.lg),

        // Rating bars
        Column(
          children: List.generate(5, (index) {
            final rating = 5 - index; // Reverse order (5 stars first)
            final count = results.ratingDistribution[index];
            final percentage = count / totalVotes;

            return AnimatedBuilder(
              animation: animations[index],
              builder: (context, child) => _RatingBar(
                rating: rating,
                count: count,
                percentage: percentage,
                animatedPercentage: animations[index].value,
                culturalTheme: culturalTheme,
              ),
            );
          }),
        ),
      ],
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<VotingResults>('results', results));
    properties.add(IntProperty('totalVotes', totalVotes));
    properties.add(IterableProperty<Animation<double>>('animations', animations));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
  }
}

/// Individual rating bar
class _RatingBar extends StatelessWidget {
  const _RatingBar({
    required this.rating,
    required this.count,
    required this.percentage,
    required this.animatedPercentage,
    this.culturalTheme,
  });

  final int rating;
  final int count;
  final double percentage;
  final double animatedPercentage;
  final CulturalTheme? culturalTheme;

  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          // Rating stars
          Row(
            children: List.generate(5, (index) => Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: AppColors.primaryGold,
                size: 16.sp,
              )),
          ),

          SizedBox(width: AppSpacing.md),

          // Rating label
          Text(
            rating.toString(),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.primaryBlack,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(width: AppSpacing.md),

          // Progress bar
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: animatedPercentage,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            culturalTheme?.color ?? AppColors.logoRed,
                            (culturalTheme?.color ?? AppColors.logoRed).withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: AppSpacing.md),

          // Count and percentage
          SizedBox(
            width: 60.w,
            child: Text(
              '${(percentage * 100).toStringAsFixed(1)}%',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.gray,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('rating', rating));
    properties.add(IntProperty('count', count));
    properties.add(DoubleProperty('percentage', percentage));
    properties.add(DoubleProperty('animatedPercentage', animatedPercentage));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
  }
}

/// Emoji reactions summary
class _ReactionsSummary extends StatelessWidget {
  const _ReactionsSummary({
    required this.results,
    this.culturalTheme,
  });

  final VotingResults results;
  final CulturalTheme? culturalTheme;

  @override
  Widget build(BuildContext context) {
    if (results.reactionCounts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Section title
        Text(
          'ردود الفعل',
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.primaryBlack,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: AppSpacing.md),

        // Reaction stats
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          alignment: WrapAlignment.center,
          children: results.reactionCounts.entries.map((entry) => _ReactionStat(
              reactionId: entry.key,
              count: entry.value,
              culturalTheme: culturalTheme,
            )).toList(),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<VotingResults>('results', results));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
  }
}

/// Individual reaction statistic
class _ReactionStat extends StatelessWidget {
  const _ReactionStat({
    required this.reactionId,
    required this.count,
    this.culturalTheme,
  });

  final String reactionId;
  final int count;
  final CulturalTheme? culturalTheme;

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.lightGray, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _getReactionEmoji(reactionId),
            style: TextStyle(fontSize: 20.sp),
          ),
          SizedBox(width: AppSpacing.sm),
          Text(
            count.toString(),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.primaryBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

  String _getReactionEmoji(String reactionId) {
    switch (reactionId) {
      case 'amazing':
        return '😍';
      case 'good':
        return '👍';
      case 'bad':
        return '👎';
      case 'weird':
        return '🤔';
      case 'spicy':
        return '🔥';
      default:
        return '👍';
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('reactionId', reactionId));
    properties.add(IntProperty('count', count));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
  }
}

/// User vote indicator
class _UserVoteIndicator extends StatelessWidget {
  const _UserVoteIndicator({
    required this.vote,
    this.culturalTheme,
  });

  final Vote vote;
  final CulturalTheme? culturalTheme;

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: (culturalTheme?.color ?? AppColors.logoRed).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: culturalTheme?.color ?? AppColors.logoRed,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.person,
            color: culturalTheme?.color ?? AppColors.logoRed,
            size: 20.sp,
          ),
          SizedBox(width: AppSpacing.sm),
          Text(
            'تصويتك:',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.primaryBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          // User rating
          Row(
            children: List.generate(5, (index) => Icon(
                index < vote.rating ? Icons.star : Icons.star_border,
                color: AppColors.primaryGold,
                size: 16.sp,
              )),
          ),
          if (vote.reactions.isNotEmpty) ...[
            SizedBox(width: AppSpacing.md),
            // User reactions
            Wrap(
              spacing: AppSpacing.xs,
              children: vote.reactions.map((reaction) => Text(
                  _getReactionEmoji(reaction),
                  style: TextStyle(fontSize: 16.sp),
                )).toList(),
            ),
          ],
        ],
      ),
    );

  String _getReactionEmoji(String reactionId) {
    switch (reactionId) {
      case 'amazing':
        return '😍';
      case 'good':
        return '👍';
      case 'bad':
        return '👎';
      case 'weird':
        return '🤔';
      case 'spicy':
        return '🔥';
      default:
        return '👍';
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Vote>('vote', vote));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
  }
}

/// Voting trends chart (simplified)
class _VotingTrendsChart extends StatelessWidget {
  const _VotingTrendsChart({
    required this.results,
    this.culturalTheme,
  });

  final VotingResults results;
  final CulturalTheme? culturalTheme;

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.lightGray, width: 1),
      ),
      child: Column(
        children: [
          // Section title
          Text(
            'اتجاهات التصويت',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.primaryBlack,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: AppSpacing.md),

          // Trend indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _TrendIndicator(
                label: 'هذا الشهر',
                value: results.monthlyTrend,
                trend: results.trendDirection,
                culturalTheme: culturalTheme,
              ),
              _TrendIndicator(
                label: 'المجموع',
                value: results.totalTrend,
                trend: results.totalTrendDirection,
                culturalTheme: culturalTheme,
              ),
            ],
          ),
        ],
      ),
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<VotingResults>('results', results));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
  }
}

/// Trend indicator widget
class _TrendIndicator extends StatelessWidget {
  const _TrendIndicator({
    required this.label,
    required this.value,
    required this.trend,
    this.culturalTheme,
  });

  final String label;
  final double value;
  final TrendDirection trend;
  final CulturalTheme? culturalTheme;

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (trend) {
      case TrendDirection.up:
        color = AppColors.success;
        icon = Icons.trending_up;
        break;
      case TrendDirection.down:
        color = AppColors.error;
        icon = Icons.trending_down;
        break;
      case TrendDirection.stable:
        color = AppColors.gray;
        icon = Icons.trending_flat;
        break;
    }

    return Column(
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.gray,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Icon(icon, color: color, size: 16.sp),
            SizedBox(width: 4.w),
            Text(
              value.toStringAsFixed(1),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.primaryBlack,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('label', label));
    properties.add(DoubleProperty('value', value));
    properties.add(EnumProperty<TrendDirection>('trend', trend));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
  }
}

/// Voting results data model
class VotingResults {
  const VotingResults({
    required this.averageRating,
    required this.ratingDistribution,
    required this.reactionCounts,
    required this.consensus,
    required this.monthlyTrend,
    required this.totalTrend,
    required this.trendDirection,
    required this.totalTrendDirection,
  });

  final double averageRating;
  final List<int> ratingDistribution; // [5-star, 4-star, 3-star, 2-star, 1-star]
  final Map<String, int> reactionCounts;
  final ConsensusStrength consensus;
  final double monthlyTrend;
  final double totalTrend;
  final TrendDirection trendDirection;
  final TrendDirection totalTrendDirection;
}

/// Consensus strength enum
enum ConsensusStrength {
  strong,
  moderate,
  weak,
}

/// Trend direction enum
enum TrendDirection {
  up,
  down,
  stable,
}

/// Vote model (simplified for this context)
class Vote {
  const Vote({
    required this.rating,
    required this.reactions,
    required this.timestamp,
  });

  final double rating;
  final List<String> reactions;
  final DateTime timestamp;
}

/// Cultural theme for results display
class CulturalTheme {
  const CulturalTheme._({
    required this.name,
    required this.color,
    required this.icon,
  });

  static const CulturalTheme egyptian = CulturalTheme._(
    name: 'مصري',
    color: Color(0xFFE74C3C),
    icon: Icons.flag,
  );

  final String name;
  final Color color;
  final IconData icon;
}