import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_animations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_shadows.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Primary Button Component
///
/// A branded call-to-action button with logo red background, shadows, and animations.
/// Uses the unified Otlob color system for consistency.
///
/// Features:
/// - Solid logo red background (or gold for success actions)
/// - Elevated shadow effect
/// - Loading state with spinner
/// - Disabled state with reduced opacity
/// - Scale-down tap animation
/// - Responsive sizing with flutter_screenutil
///
/// Usage Examples:
/// ```dart
/// // Basic usage
/// PrimaryButton(
///   text: 'Continue',
///   onPressed: () => print('Pressed'),
/// )
///
/// // With icon
/// PrimaryButton(
///   text: 'Add to Cart',
///   icon: Icons.shopping_cart,
///   onPressed: _addToCart,
/// )
///
/// // Loading state
/// PrimaryButton(
///   text: 'Processing...',
///   isLoading: true,
///   onPressed: null,
/// )
///
/// // Disabled state
/// PrimaryButton(
///   text: 'Submit',
///   onPressed: null, // Null = disabled
/// )
///
/// // Full width
/// PrimaryButton(
///   text: 'Continue',
///   fullWidth: true,
///   onPressed: _continue,
/// )
/// ```
class PrimaryButton extends StatefulWidget {

  const PrimaryButton({
    required this.text, required this.onPressed, super.key,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.height,
    this.textStyle,
    this.backgroundColor,
  });
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

  /// Background color (defaults to logoRed, can be changed to primaryGold for success actions)
  final Color? backgroundColor;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('text', text));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed));
    properties.add(DiagnosticsProperty<IconData?>('icon', icon));
    properties.add(DiagnosticsProperty<bool>('isLoading', isLoading));
    properties.add(DiagnosticsProperty<bool>('fullWidth', fullWidth));
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<TextStyle?>('textStyle', textStyle));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
  }
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  late bool isDisabled;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.buttonPress,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(
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
    isDisabled = widget.onPressed == null || widget.isLoading;
    var buttonHeight = widget.height ?? 48.h;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(scale: _scaleAnimation.value, child: child),
        child: AnimatedOpacity(
          opacity: isDisabled ? 0.6 : 1.0,
          duration: AppAnimations.fast,
          child: Container(
            height: buttonHeight,
            width: widget.fullWidth ? double.infinity : null,
            padding: widget.fullWidth
                ? null
                : EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: BoxDecoration(
              color: isDisabled
                  ? AppColors.gray
                  : (widget.backgroundColor ?? AppColors.logoRed),
              borderRadius: AppRadius.buttonRadius,
              boxShadow: isDisabled ? null : AppShadows.md,
            ),
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.white,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: AppColors.white,
                              size: 20.sp,
                            ),
                            SizedBox(width: AppSpacing.sm),
                          ],
                          Text(
                            widget.text,
                            style:
                                widget.textStyle ??
                                AppTypography.labelLarge.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isDisabled', isDisabled));
  }
}
