import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

/// Cuisine Tag Component
///
/// A chip-style badge displaying cuisine type with:
/// - Rounded corners
/// - Accent peach background
/// - Dark text
/// - Compact size
///
/// Used to categorize and display cuisine types (Egyptian, Italian, etc.)
/// in restaurant cards and detail views.
///
/// Usage Examples:
/// ```dart
/// // Basic usage
/// CuisineTag(name: 'Egyptian')
///
/// // Multiple tags
/// Row(
///   children: [
///     CuisineTag(name: 'Egyptian'),
///     SizedBox(width: 8),
///     CuisineTag(name: 'Grill'),
///   ],
/// )
///
/// // In a Wrap
/// Wrap(
///   spacing: 8,
///   children: cuisines.map((c) => CuisineTag(name: c)).toList(),
/// )
/// ```
class CuisineTag extends StatelessWidget {
  /// Cuisine name (e.g., "Egyptian", "Italian", "Fast Food")
  final String name;

  /// Custom background color (overrides default peach)
  final Color? backgroundColor;

  /// Custom text color (overrides default dark)
  final Color? textColor;

  const CuisineTag({
    super.key,
    required this.name,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.accentPeach.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        name,
        style: AppTypography.labelSmall.copyWith(
          color: textColor ?? AppColors.primaryDark,
          fontWeight: FontWeight.w500,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}
