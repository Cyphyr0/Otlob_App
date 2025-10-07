import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_animations.dart';

/// Secondary Button Component
///
/// An outlined button with transparent background and gold border.
/// Used for secondary actions and alternative options.
///
/// Features:
/// - Outlined style with gold border
/// - Transparent background
/// - Gold text
/// - Hover effects for web
/// - Scale-down tap animation
/// - Loading state support
/// - Responsive sizing with flutter_screenutil
///
/// Usage Examples:
/// ```dart
/// // Basic usage
/// SecondaryButton(
///   text: 'Cancel',
///   onPressed: () => Navigator.pop(context),
/// )
///
/// // With icon
/// SecondaryButton(
///   text: 'Learn More',
///   icon: Icons.info_outline,
///   onPressed: _showInfo,
/// )
///
/// // Loading state
/// SecondaryButton(
///   text: 'Loading...',
///   isLoading: true,
///   onPressed: null,
/// )
///
/// // Full width
/// SecondaryButton(
///   text: 'Skip',
///   fullWidth: true,
///   onPressed: _skip,
/// )
/// ```
class SecondaryButton extends StatefulWidget {
  /// Button text label
  final String text;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Optional icon to display before text
  final IconData? icon;

  /// Show loading spinner instead of text
  final bool isLoading;

  /// Expand button to full width of parent
  final bool fullWidth;

  /// Custom button height (defaults to 48.h)
  final double? height;

  /// Custom text style (overrides default)
  final TextStyle? textStyle;

  /// Border color (defaults to primaryGold)
  final Color? borderColor;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.height,
    this.textStyle,
    this.borderColor,
  });

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.buttonPress,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.buttonCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      _controller.reverse();
      setState(() => _isPressed = false);
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      _controller.reverse();
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null || widget.isLoading;
    final buttonHeight = widget.height ?? 48.h;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: AnimatedContainer(
            duration: AppAnimations.fast,
            height: buttonHeight,
            width: widget.fullWidth ? double.infinity : null,
            padding: widget.fullWidth
                ? null
                : EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: BoxDecoration(
              color: _isHovered && !isDisabled
                  ? (widget.borderColor ?? AppColors.primaryGold).withOpacity(
                      0.05,
                    )
                  : Colors.transparent,
              border: Border.all(
                color: isDisabled
                    ? AppColors.gray.withOpacity(0.5)
                    : (widget.borderColor ?? AppColors.primaryGold),
                width: 1.5,
              ),
              borderRadius: AppRadius.buttonRadius,
            ),
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDisabled
                              ? AppColors.gray
                              : (widget.borderColor ?? AppColors.primaryGold),
                        ),
                      ),
                    )
                  : FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: isDisabled
                                  ? AppColors.gray
                                  : (widget.borderColor ??
                                        AppColors.primaryGold),
                              size: 20.sp,
                            ),
                            SizedBox(width: AppSpacing.sm),
                          ],
                          Flexible(
                            child: Text(
                              widget.text,
                              style:
                                  widget.textStyle ??
                                  AppTypography.labelLarge.copyWith(
                                    color: isDisabled
                                        ? AppColors.gray
                                        : (widget.borderColor ??
                                              AppColors.primaryGold),
                                    fontWeight: FontWeight.w600,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
