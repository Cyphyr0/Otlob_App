import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

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

  const CuisineTag({
    required this.name, super.key,
    this.backgroundColor,
    this.textColor,
  });
  /// Cuisine name (e.g., "Egyptian", "Italian", "Fast Food")
  final String name;

  /// Custom background color (overrides default peach)
  final Color? backgroundColor;

  /// Custom text color (overrides default dark)
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    // Get dynamic color based on cuisine type
    var cuisineColor = AppColors.getCuisineColor(name);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? cuisineColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: cuisineColor.withOpacity(0.3), width: 1),
      ),
      child: Text(
        name,
        style: AppTypography.labelSmall.copyWith(
          color: textColor ?? cuisineColor,
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('name', name));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('textColor', textColor));
  }
}
