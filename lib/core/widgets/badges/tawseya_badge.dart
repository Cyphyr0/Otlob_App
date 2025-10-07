import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "../../theme/app_colors.dart";
import "../../theme/app_typography.dart";
import "../../theme/app_radius.dart";
import "../../theme/app_spacing.dart";
import "../../theme/app_shadows.dart";
import "../../theme/app_animations.dart";

/// Tawseya Badge Component
///
/// A premium badge displaying Tawseya (recommendation) status with:
/// - Gold background (#F4D06F)
/// - Gem/diamond icon
/// - Optional pulse animation
/// - Count display
/// - Multiple sizes
///
/// Tawseya represents trusted recommendations from local food experts,
/// adding credibility and social proof to restaurant listings.
///
/// Usage Examples:
/// ```dart
/// // Basic usage
/// TawseyaBadge()
///
/// // With count
/// TawseyaBadge(count: 156)
///
/// // With animation
/// TawseyaBadge(
///   count: 234,
///   animated: true,
/// )
///
/// // Different sizes
/// TawseyaBadge(
///   size: BadgeSize.large,
///   count: 89,
/// )
/// ```
class TawseyaBadge extends StatefulWidget {

  const TawseyaBadge({
    super.key,
    this.count,
    this.size = BadgeSize.medium,
    this.animated = false,
  });
  /// Number of Tawseya recommendations (optional)
  final int? count;

  /// Badge size
  final BadgeSize size;

  /// Show pulse animation
  final bool animated;

  @override
  State<TawseyaBadge> createState() => _TawseyaBadgeState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
    properties.add(EnumProperty<BadgeSize>('size', size));
    properties.add(DiagnosticsProperty<bool>('animated', animated));
  }
}

class _TawseyaBadgeState extends State<TawseyaBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    if (widget.animated) {
      _controller = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      );

      _scaleAnimation = Tween<double>(begin: 1, end: 1.05).animate(
        CurvedAnimation(parent: _controller, curve: AppAnimations.easeInOut),
      );

      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    if (widget.animated) {
      _controller.dispose();
    }
    super.dispose();
  }

  double get _iconSize {
    switch (widget.size) {
      case BadgeSize.small:
        return 12.sp;
      case BadgeSize.medium:
        return 14.sp;
      case BadgeSize.large:
        return 16.sp;
    }
  }

  double get _fontSize {
    switch (widget.size) {
      case BadgeSize.small:
        return 10.sp;
      case BadgeSize.medium:
        return 11.sp;
      case BadgeSize.large:
        return 12.sp;
    }
  }

  EdgeInsets get _padding {
    switch (widget.size) {
      case BadgeSize.small:
        return EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2.h);
      case BadgeSize.medium:
        return EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4.h);
      case BadgeSize.large:
        return EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6.h);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget badge = Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: AppColors.primaryGold,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        boxShadow: AppShadows.accentGold,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Gem/diamond icon
          Icon(Icons.diamond, size: _iconSize, color: AppColors.primaryDark),
          if (widget.count != null) ...[
            SizedBox(width: 4.w),
            Text(
              _formatCount(widget.count!),
              style: AppTypography.labelSmall.copyWith(
                fontSize: _fontSize,
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );

    // Wrap with animation if enabled
    if (widget.animated) {
      badge = AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(scale: _scaleAnimation.value, child: child),
        child: badge,
      );
    }

    return badge;
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return "${(count / 1000).toStringAsFixed(1)}k";
    }
    return count.toString();
  }
}

/// Badge size options
enum BadgeSize {
  /// Small badge
  small,

  /// Medium badge (default)
  medium,

  /// Large badge
  large,
}
