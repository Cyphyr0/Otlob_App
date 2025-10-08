import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../buttons/modern_button_variants.dart';

/// Tawseya Voting Interface with 5-Star Rating and Emoji Reactions
///
/// A comprehensive voting system featuring:
/// - 5-star rating system with smooth animations
/// - Emoji reactions for cultural expression
/// - Monthly voting period integration
/// - Community consensus visualization
/// - Cultural motifs and Egyptian styling
/// - Accessibility features for screen readers
///
/// Usage:
/// ```dart
/// TawseyaVotingInterface(
///   item: tawseyaItem,
///   currentVote: userVote,
///   onVoteSubmitted: (rating, reactions) => submitVote(rating, reactions),
///   votingPeriod: currentVotingPeriod,
///   culturalTheme: CulturalTheme.egyptian,
/// )
/// ```
class TawseyaVotingInterface extends StatefulWidget {
  const TawseyaVotingInterface({
    required this.item, required this.onVoteSubmitted, super.key,
    this.currentVote,
    this.votingPeriod,
    this.culturalTheme,
    this.enableEmojiReactions = true,
    this.enableComments = false,
  });

  final TawseyaItem item;
  final Vote? currentVote;
  final Function(double rating, List<String> reactions) onVoteSubmitted;
  final VotingPeriod? votingPeriod;
  final CulturalTheme? culturalTheme;
  final bool enableEmojiReactions;
  final bool enableComments;

  @override
  State<TawseyaVotingInterface> createState() => _TawseyaVotingInterfaceState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TawseyaItem>('item', item));
    properties.add(DiagnosticsProperty<Vote?>('currentVote', currentVote));
    properties.add(ObjectFlagProperty<Function(double rating, List<String> reactions)>.has('onVoteSubmitted', onVoteSubmitted));
    properties.add(DiagnosticsProperty<VotingPeriod?>('votingPeriod', votingPeriod));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
    properties.add(DiagnosticsProperty<bool>('enableEmojiReactions', enableEmojiReactions));
    properties.add(DiagnosticsProperty<bool>('enableComments', enableComments));
  }
}

class _TawseyaVotingInterfaceState extends State<TawseyaVotingInterface>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  double _currentRating = 0;
  List<String> _selectedReactions = [];
  bool _hasVoted = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    // Initialize with current vote if exists
    if (widget.currentVote != null) {
      _currentRating = widget.currentVote!.rating;
      _selectedReactions = widget.currentVote!.reactions;
      _hasVoted = true;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleRatingUpdate(double rating) {
    setState(() {
      _currentRating = rating;
      _hasVoted = false; // Reset vote state when rating changes
    });
  }

  void _handleReactionToggle(String reaction) {
    setState(() {
      if (_selectedReactions.contains(reaction)) {
        _selectedReactions.remove(reaction);
      } else {
        _selectedReactions.add(reaction);
      }
      _hasVoted = false; // Reset vote state when reactions change
    });
  }

  void _submitVote() {
    if (_currentRating == 0) return;

    setState(() => _isSubmitting = true);

    widget.onVoteSubmitted(_currentRating, _selectedReactions);

    setState(() {
      _isSubmitting = false;
      _hasVoted = true;
    });
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with cultural theme
                _VotingHeader(
                  item: widget.item,
                  culturalTheme: widget.culturalTheme,
                ),

                SizedBox(height: AppSpacing.xl),

                // 5-star rating selector
                _StarRatingSelector(
                  currentRating: _currentRating,
                  onRatingChanged: _handleRatingUpdate,
                  size: 40.sp,
                ),

                SizedBox(height: AppSpacing.xl),

                // Emoji reactions
                if (widget.enableEmojiReactions) ...[
                  _EmojiReactionsSelector(
                    selectedReactions: _selectedReactions,
                    onReactionToggle: _handleReactionToggle,
                  ),

                  SizedBox(height: AppSpacing.xl),
                ],

                // Voting period info
                if (widget.votingPeriod != null) ...[
                  _VotingPeriodInfo(
                    votingPeriod: widget.votingPeriod!,
                    culturalTheme: widget.culturalTheme,
                  ),

                  SizedBox(height: AppSpacing.xl),
                ],

                // Submit button
                _VotingSubmitButton(
                  hasVoted: _hasVoted,
                  isSubmitting: _isSubmitting,
                  canSubmit: _currentRating > 0,
                  onSubmit: _submitVote,
                  culturalTheme: widget.culturalTheme,
                ),

                // Previous vote display
                if (_hasVoted && widget.currentVote != null) ...[
                  SizedBox(height: AppSpacing.md),
                  _PreviousVoteDisplay(
                    vote: widget.currentVote!,
                    culturalTheme: widget.culturalTheme,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
}

/// Voting interface header
class _VotingHeader extends StatelessWidget {
  const _VotingHeader({
    required this.item,
    this.culturalTheme,
  });

  final TawseyaItem item;
  final CulturalTheme? culturalTheme;

  @override
  Widget build(BuildContext context) => Column(
      children: [
        // Cultural icon
        if (culturalTheme != null) ...[
          Icon(
            culturalTheme!.icon,
            color: culturalTheme!.color,
            size: 32.sp,
          ),
          SizedBox(height: AppSpacing.sm),
        ],

        // Item name
        Text(
          item.name,
          style: AppTypography.headlineMedium.copyWith(
            color: AppColors.primaryBlack,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: AppSpacing.sm),

        // Item description
        Text(
          item.description,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.gray,
          ),
          textAlign: TextAlign.center,
        ),

        // Current stats
        SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Current rating
            Row(
              children: [
                Icon(Icons.star, color: AppColors.primaryGold, size: 16.sp),
                SizedBox(width: 4.w),
                Text(
                  item.averageRating.toStringAsFixed(1),
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlack,
                  ),
                ),
              ],
            ),

            SizedBox(width: AppSpacing.md),

            // Total votes
            Text(
              '${item.totalVotes} تصويت',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.gray,
              ),
            ),
          ],
        ),
      ],
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TawseyaItem>('item', item));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
  }
}

/// 5-star rating selector with smooth animations
class _StarRatingSelector extends StatefulWidget {
  const _StarRatingSelector({
    required this.currentRating,
    required this.onRatingChanged,
    required this.size,
  });

  final double currentRating;
  final Function(double) onRatingChanged;
  final double size;

  @override
  State<_StarRatingSelector> createState() => _StarRatingSelectorState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('currentRating', currentRating));
    properties.add(ObjectFlagProperty<Function(double p1)>.has('onRatingChanged', onRatingChanged));
    properties.add(DoubleProperty('size', size));
  }
}

class _StarRatingSelectorState extends State<_StarRatingSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _hoveredRating = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
      children: [
        // Rating display text
        Text(
          _getRatingText(widget.currentRating),
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.gray,
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: AppSpacing.md),

        // Interactive stars
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starRating = index + 1;
            final isSelected = starRating <= widget.currentRating;
            final isHovered = starRating <= _hoveredRating;

            return MouseRegion(
              onEnter: (_) {
                setState(() => _hoveredRating = starRating);
                _animationController.forward();
              },
              onExit: (_) {
                setState(() => _hoveredRating = 0);
                _animationController.reverse();
              },
              child: GestureDetector(
                onTap: () => widget.onRatingChanged(starRating.toDouble()),
                child: AnimatedScale(
                  scale: isHovered ? 1.2 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeInOut,
                  child: Icon(
                    isSelected ? Icons.star : Icons.star_border,
                    color: isHovered || isSelected
                        ? AppColors.primaryGold
                        : AppColors.lightGray,
                    size: widget.size,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );

  String _getRatingText(double rating) {
    if (rating == 0) return 'اختر تقييمك';
    if (rating <= 1) return 'ضعيف جداً';
    if (rating <= 2) return 'ضعيف';
    if (rating <= 3) return 'مقبول';
    if (rating <= 4) return 'جيد';
    return 'ممتاز';
  }
}

/// Emoji reactions selector
class _EmojiReactionsSelector extends StatelessWidget {
  const _EmojiReactionsSelector({
    required this.selectedReactions,
    required this.onReactionToggle,
  });

  final List<String> selectedReactions;
  final Function(String) onReactionToggle;

  @override
  Widget build(BuildContext context) {
    final reactions = <ReactionData>[
      const ReactionData(emoji: '😍', label: 'رائع', id: 'amazing'),
      const ReactionData(emoji: '👍', label: 'جيد', id: 'good'),
      const ReactionData(emoji: '👎', label: 'سيء', id: 'bad'),
      const ReactionData(emoji: '🤔', label: 'غريب', id: 'weird'),
      const ReactionData(emoji: '🔥', label: 'حار', id: 'spicy'),
    ];

    return Column(
      children: [
        // Section title
        Text(
          'كيف كان شعورك؟',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.primaryBlack,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: AppSpacing.md),

        // Reaction buttons
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          alignment: WrapAlignment.center,
          children: reactions.map((reaction) {
            final isSelected = selectedReactions.contains(reaction.id);

            return GestureDetector(
              onTap: () => onReactionToggle(reaction.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.logoRed.withOpacity(0.1)
                      : AppColors.offWhite,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.logoRed
                        : AppColors.lightGray,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      reaction.emoji,
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      reaction.label,
                      style: AppTypography.bodySmall.copyWith(
                        color: isSelected
                            ? AppColors.logoRed
                            : AppColors.gray,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<String>('selectedReactions', selectedReactions));
    properties.add(ObjectFlagProperty<Function(String p1)>.has('onReactionToggle', onReactionToggle));
  }
}

/// Voting period information
class _VotingPeriodInfo extends StatelessWidget {
  const _VotingPeriodInfo({
    required this.votingPeriod,
    this.culturalTheme,
  });

  final VotingPeriod votingPeriod;
  final CulturalTheme? culturalTheme;

  @override
  Widget build(BuildContext context) {
    final daysLeft = votingPeriod.daysRemaining;
    final progress = votingPeriod.progress;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.lightGray, width: 1),
      ),
      child: Column(
        children: [
          // Period title
          Row(
            children: [
              Icon(
                culturalTheme?.icon ?? Icons.calendar_today,
                color: culturalTheme?.color ?? AppColors.logoRed,
                size: 20.sp,
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                'فترة التصويت الشهرية',
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlack,
                ),
              ),
            ],
          ),

          SizedBox(height: AppSpacing.md),

          // Progress bar
          Column(
            children: [
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.lightGray,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    culturalTheme?.color ?? AppColors.logoRed,
                  ),
                  minHeight: 8.h,
                ),
              ),

              SizedBox(height: AppSpacing.sm),

              // Progress text
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'يوم ${votingPeriod.currentDay}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.gray,
                    ),
                  ),
                  Text(
                    'يتبقى $daysLeft أيام',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<VotingPeriod>('votingPeriod', votingPeriod));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
  }
}

/// Submit button for voting
class _VotingSubmitButton extends StatelessWidget {
  const _VotingSubmitButton({
    required this.hasVoted,
    required this.isSubmitting,
    required this.canSubmit,
    required this.onSubmit,
    this.culturalTheme,
  });

  final bool hasVoted;
  final bool isSubmitting;
  final bool canSubmit;
  final VoidCallback onSubmit;
  final CulturalTheme? culturalTheme;

  @override
  Widget build(BuildContext context) {
    if (hasVoted) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.success, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 20.sp),
            SizedBox(width: AppSpacing.sm),
            Text(
              'تم تسجيل تصويتك',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return ModernButton.primary(
      text: isSubmitting ? 'جاري التصويت...' : 'تصويت',
      onPressed: canSubmit && !isSubmitting ? onSubmit : null,
      isLoading: isSubmitting,
      fullWidth: true,
      leadingIcon: isSubmitting ? null : Icons.how_to_vote,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('hasVoted', hasVoted));
    properties.add(DiagnosticsProperty<bool>('isSubmitting', isSubmitting));
    properties.add(DiagnosticsProperty<bool>('canSubmit', canSubmit));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onSubmit', onSubmit));
    properties.add(DiagnosticsProperty<CulturalTheme?>('culturalTheme', culturalTheme));
  }
}

/// Previous vote display
class _PreviousVoteDisplay extends StatelessWidget {
  const _PreviousVoteDisplay({
    required this.vote,
    this.culturalTheme,
  });

  final Vote vote;
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
          // Previous rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'تصويتك السابق:',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.gray,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Row(
                children: List.generate(5, (index) => Icon(
                    index < vote.rating ? Icons.star : Icons.star_border,
                    color: AppColors.primaryGold,
                    size: 16.sp,
                  )),
              ),
            ],
          ),

          // Previous reactions
          if (vote.reactions.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              alignment: WrapAlignment.center,
              children: vote.reactions.map((reaction) => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.logoRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    _getReactionEmoji(reaction),
                    style: TextStyle(fontSize: 16.sp),
                  ),
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

/// Reaction data model
class ReactionData {
  const ReactionData({
    required this.emoji,
    required this.label,
    required this.id,
  });

  final String emoji;
  final String label;
  final String id;
}

/// Tawseya item model (simplified for this context)
class TawseyaItem {
  const TawseyaItem({
    required this.id,
    required this.name,
    required this.description,
    required this.averageRating,
    required this.totalVotes,
  });

  final String id;
  final String name;
  final String description;
  final double averageRating;
  final int totalVotes;
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

/// Voting period model (simplified for this context)
class VotingPeriod {
  const VotingPeriod({
    required this.currentDay,
    required this.totalDays,
    required this.daysRemaining,
    required this.progress,
  });

  final int currentDay;
  final int totalDays;
  final int daysRemaining;
  final double progress;
}

/// Cultural theme for Tawseya interface
enum CulturalTheme {
  egyptian._(
    name: 'مصري',
    color: Color(0xFFE74C3C),
    icon: Icons.flag,
  ),
  ramadan._(
    name: 'رمضان',
    color: Color(0xFFF4D06F),
    icon: Icons.star,
  );

  const CulturalTheme._({
    required this.name,
    required this.color,
    required this.icon,
  });

  final String name;
  final Color color;
  final IconData icon;
}