import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../branding/otlob_logo.dart';

/// Loading Indicator Component
///
/// Branded loading indicators with multiple variants:
/// - Spinner with Otlob logo
/// - Simple circular progress
/// - Linear progress bar
///
/// Usage Examples:
/// ```dart
/// // Logo spinner (default)
/// LoadingIndicator()
///
/// // With message
/// LoadingIndicator(
///   message: 'Loading restaurants...',
/// )
///
/// // Simple spinner
/// LoadingIndicator.simple()
///
/// // Linear progress
/// LoadingIndicator.linear()
/// ```
class LoadingIndicator extends StatelessWidget {

  const LoadingIndicator({
    super.key,
    this.message,
    this.size = LoadingSize.medium,
    this.color,
  });

  /// Simple circular progress indicator without logo
  const LoadingIndicator.simple({
    super.key,
    this.message,
    this.size = LoadingSize.medium,
    this.color,
  });

  /// Linear progress indicator
  const LoadingIndicator.linear({super.key, this.message, this.color})
    : size = LoadingSize.medium;
  /// Loading message to display below indicator
  final String? message;

  /// Size of the loading indicator
  final LoadingSize size;

  /// Color of the spinner (defaults to accentOrange)
  final Color? color;

  @override
  Widget build(BuildContext context) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIndicator(),
          if (message != null) ...[
            SizedBox(height: AppSpacing.md),
            Text(
              message!,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.gray),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );

  Widget _buildIndicator() {
    var indicatorColor = color ?? AppColors.accentOrange;
    var indicatorSize = _getSize();

    return SizedBox(
      width: indicatorSize,
      height: indicatorSize,
      child: CircularProgressIndicator(
        strokeWidth: _getStrokeWidth(),
        valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
      ),
    );
  }

  double _getSize() {
    switch (size) {
      case LoadingSize.small:
        return 24.r;
      case LoadingSize.medium:
        return 36.r;
      case LoadingSize.large:
        return 48.r;
    }
  }

  double _getStrokeWidth() {
    switch (size) {
      case LoadingSize.small:
        return 2;
      case LoadingSize.medium:
        return 3;
      case LoadingSize.large:
        return 4;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('message', message));
    properties.add(EnumProperty<LoadingSize>('size', size));
    properties.add(ColorProperty('color', color));
  }
}

/// Loading Indicator with Otlob Logo
///
/// Shows an animated Otlob logo with loading message
class LogoLoadingIndicator extends StatelessWidget {

  const LogoLoadingIndicator({super.key, this.message});
  /// Loading message
  final String? message;

  @override
  Widget build(BuildContext context) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const OtlobLogo(size: LogoSize.large, animated: true),
          SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: 48.w,
            height: 48.h,
            child: const CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentOrange),
            ),
          ),
          if (message != null) ...[
            SizedBox(height: AppSpacing.md),
            Text(
              message!,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.gray),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('message', message));
  }
}

/// Linear Progress Indicator
///
/// A thin progress bar, typically used at the top of screens
class LinearLoadingIndicator extends StatelessWidget {

  const LinearLoadingIndicator({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
  });
  /// Progress value (0.0 to 1.0), null for indeterminate
  final double? value;

  /// Color of the progress bar
  final Color? color;

  /// Background color
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => LinearProgressIndicator(
      value: value,
      valueColor: AlwaysStoppedAnimation<Color>(
        color ?? AppColors.accentOrange,
      ),
      backgroundColor: backgroundColor ?? AppColors.lightGray.withOpacity(0.3),
      minHeight: 3.h,
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('value', value));
    properties.add(ColorProperty('color', color));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
  }
}

/// Loading size options
enum LoadingSize {
  /// Small - 24x24
  small,

  /// Medium - 36x36 (default)
  medium,

  /// Large - 48x48
  large,
}
