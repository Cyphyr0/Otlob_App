import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Modern Loading States and Skeleton Screens
///
/// A comprehensive loading system featuring:
/// - Smooth skeleton animations
/// - Egyptian cultural loading indicators
/// - Multiple loading variants
/// - Progress indicators with cultural styling
/// - Empty states with call-to-action
///
/// Usage:
/// ```dart
/// // Skeleton loading for restaurant list
/// ListView.builder(
///   itemCount: 5,
///   itemBuilder: (context, index) => SkeletonLoader.restaurantCard(),
/// )
///
/// // Cultural loading spinner
/// CulturalLoadingSpinner.egyptian(
///   size: LoadingSize.large,
///   message: 'Loading Egyptian delicacies...',
/// )
///
/// // Progress with Egyptian styling
/// LoadingProgress.egyptian(
///   progress: 0.7,
///   message: 'Preparing your order...',
/// )
/// ```
class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader._({
    required this.child,
    this.enabled = true,
  });

  /// Restaurant card skeleton
  factory SkeletonLoader.restaurantCard({bool enabled = true}) => SkeletonLoader._(
      enabled: enabled,
      child: Container(
        width: 280.w,
        height: 200.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image skeleton
            Container(
              height: 120.h,
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
              ),
            ),
            // Content skeleton
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title skeleton
                  Container(
                    height: 16.h,
                    width: 180.w,
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  // Subtitle skeleton
                  Container(
                    height: 12.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  // Rating skeleton
                  Row(
                    children: [
                      Container(
                        height: 14.h,
                        width: 60.w,
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 12.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  /// Menu item skeleton
  factory SkeletonLoader.menuItem({bool enabled = true}) => SkeletonLoader._(
      enabled: enabled,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            // Image skeleton
            Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            // Content skeleton
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Container(
                    height: 12.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Container(
                    height: 14.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  /// Text skeleton
  factory SkeletonLoader.text({
    bool enabled = true,
    int lines = 1,
    double width = double.infinity,
  }) => SkeletonLoader._(
      enabled: enabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          lines,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: index < lines - 1 ? 8.h : 0),
            child: Container(
              height: 14.h,
              width: index == lines - 1 ? width * 0.7 : width,
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),
      ),
    );

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return SkeletonAnimation(child: child);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
  }
}

/// Animated skeleton wrapper
class SkeletonAnimation extends StatefulWidget {
  const SkeletonAnimation({
    required this.child, super.key,
    this.duration = const Duration(milliseconds: 1500),
  });

  final Widget child;
  final Duration duration;

  @override
  State<SkeletonAnimation> createState() => _SkeletonAnimationState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Duration>('duration', duration));
  }
}

class _SkeletonAnimationState extends State<SkeletonAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Container(
        foregroundDecoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.lightGray.withOpacity(_animation.value),
              AppColors.lightGray.withOpacity(_animation.value + 0.2),
              AppColors.lightGray.withOpacity(_animation.value),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: widget.child,
      ),
    );
}

/// Cultural Loading Spinner with Egyptian motifs
class CulturalLoadingSpinner extends StatefulWidget {
  const CulturalLoadingSpinner._({
    required this.type,
    required this.size,
    this.message,
    this.color,
  });

  /// Egyptian themed spinner with cultural motifs
  factory CulturalLoadingSpinner.egyptian({
    LoadingSize size = LoadingSize.medium,
    String? message,
    Color? color,
  }) => CulturalLoadingSpinner._(
      type: SpinnerType.egyptian,
      size: size,
      message: message,
      color: color,
    );

  /// Modern spinner with clean design
  factory CulturalLoadingSpinner.modern({
    LoadingSize size = LoadingSize.medium,
    String? message,
    Color? color,
  }) => CulturalLoadingSpinner._(
      type: SpinnerType.modern,
      size: size,
      message: message,
      color: color,
    );

  final SpinnerType type;
  final LoadingSize size;
  final String? message;
  final Color? color;

  @override
  State<CulturalLoadingSpinner> createState() => _CulturalLoadingSpinnerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<SpinnerType>('type', type));
    properties.add(EnumProperty<LoadingSize>('size', size));
    properties.add(StringProperty('message', message));
    properties.add(ColorProperty('color', color));
  }
}

class _CulturalLoadingSpinnerState extends State<CulturalLoadingSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spinnerSize = _getSpinnerSize();
    final spinnerColor = widget.color ?? AppColors.logoRed;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            if (widget.type == SpinnerType.egyptian) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: _EgyptianSpinnerIcon(
                    size: spinnerSize,
                    color: spinnerColor,
                  ),
                ),
              );
            } else {
              return SizedBox(
                width: spinnerSize,
                height: spinnerSize,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
                ),
              );
            }
          },
        ),
        if (widget.message != null) ...[
          SizedBox(height: AppSpacing.md),
          Text(
            widget.message!,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.gray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  double _getSpinnerSize() {
    switch (widget.size) {
      case LoadingSize.small:
        return 24.w;
      case LoadingSize.medium:
        return 40.w;
      case LoadingSize.large:
        return 60.w;
    }
  }
}

/// Egyptian themed spinner icon
class _EgyptianSpinnerIcon extends StatelessWidget {
  const _EgyptianSpinnerIcon({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 3),
      ),
      child: Center(
        child: Icon(
          Icons.star,
          color: color,
          size: size * 0.5,
        ),
      ),
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('size', size));
    properties.add(ColorProperty('color', color));
  }
}

/// Loading progress with Egyptian styling
class LoadingProgress extends StatefulWidget {
  const LoadingProgress._({
    required this.type,
    required this.progress,
    this.message,
    this.color,
  });

  /// Egyptian themed progress bar
  factory LoadingProgress.egyptian({
    required double progress,
    String? message,
    Color? color,
  }) => LoadingProgress._(
      type: ProgressType.egyptian,
      progress: progress,
      message: message,
      color: color,
    );

  final ProgressType type;
  final double progress;
  final String? message;
  final Color? color;

  @override
  State<LoadingProgress> createState() => _LoadingProgressState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<ProgressType>('type', type));
    properties.add(DoubleProperty('progress', progress));
    properties.add(StringProperty('message', message));
    properties.add(ColorProperty('color', color));
  }
}

class _LoadingProgressState extends State<LoadingProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0, end: widget.progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(LoadingProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: widget.progress,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressColor = widget.color ?? AppColors.logoRed;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            if (widget.type == ProgressType.egyptian) {
              return _EgyptianProgressBar(
                progress: _progressAnimation.value,
                color: progressColor,
              );
            } else {
              return LinearProgressIndicator(
                value: _progressAnimation.value,
                backgroundColor: AppColors.lightGray,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              );
            }
          },
        ),
        if (widget.message != null) ...[
          SizedBox(height: AppSpacing.sm),
          Text(
            widget.message!,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.gray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Egyptian themed progress bar
class _EgyptianProgressBar extends StatelessWidget {
  const _EgyptianProgressBar({
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
      height: 8.h,
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color,
                color.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('progress', progress));
    properties.add(ColorProperty('color', color));
  }
}

/// Empty state with call-to-action
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon, required this.title, required this.message, super.key,
    this.actionText,
    this.onActionPressed,
    this.backgroundColor,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => Container(
      color: backgroundColor ?? AppColors.offWhite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80.w,
            color: AppColors.gray,
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            title,
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.primaryBlack,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.gray,
            ),
            textAlign: TextAlign.center,
          ),
          if (actionText != null && onActionPressed != null) ...[
            SizedBox(height: AppSpacing.xl),
            ElevatedButton(
              onPressed: onActionPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.logoRed,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(actionText!),
            ),
          ],
        ],
      ),
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
    properties.add(StringProperty('title', title));
    properties.add(StringProperty('message', message));
    properties.add(StringProperty('actionText', actionText));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onActionPressed', onActionPressed));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
  }
}

/// Loading spinner types
enum SpinnerType {
  egyptian,
  modern,
}

/// Progress bar types
enum ProgressType {
  egyptian,
  modern,
}

/// Loading size variants
enum LoadingSize {
  small,
  medium,
  large,
}