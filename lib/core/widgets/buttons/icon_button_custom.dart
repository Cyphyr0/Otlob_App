import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_animations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_shadows.dart';

/// Custom Icon Button Component
///
/// A versatile circular icon button with multiple style variants and badge support.
/// Perfect for toolbars, headers, and interactive elements.
///
/// Features:
/// - Multiple variants: filled, outlined, ghost
/// - Badge support (for cart count, notifications)
/// - Circular design with proper touch targets
/// - Scale animation on tap
/// - Customizable size and colors
/// - Responsive sizing with flutter_screenutil
///
/// Usage Examples:
/// ```dart
/// // Filled variant (default)
/// IconButtonCustom(
///   icon: Icons.shopping_cart,
///   onPressed: () => _openCart(),
/// )
///
/// // Outlined variant
/// IconButtonCustom(
///   icon: Icons.favorite_border,
///   variant: IconButtonVariant.outlined,
///   onPressed: _toggleFavorite,
/// )
///
/// // Ghost variant (transparent)
/// IconButtonCustom(
///   icon: Icons.close,
///   variant: IconButtonVariant.ghost,
///   onPressed: () => Navigator.pop(context),
/// )
///
/// // With badge
/// IconButtonCustom(
///   icon: Icons.shopping_cart,
///   badgeCount: 3,
///   onPressed: _openCart,
/// )
///
/// // Custom size
/// IconButtonCustom(
///   icon: Icons.add,
///   size: IconButtonSize.large,
///   onPressed: _addItem,
/// )
/// ```
class IconButtonCustom extends StatefulWidget {

  const IconButtonCustom({
    required this.icon, required this.onPressed, super.key,
    this.variant = IconButtonVariant.filled,
    this.size = IconButtonSize.medium,
    this.badgeCount,
    this.iconColor,
    this.backgroundColor,
  });
  /// The icon to display
  final IconData icon;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Button style variant
  final IconButtonVariant variant;

  /// Button size
  final IconButtonSize size;

  /// Badge count to display (null = no badge)
  final int? badgeCount;

  /// Custom icon color (overrides variant default)
  final Color? iconColor;

  /// Custom background color (overrides variant default)
  final Color? backgroundColor;

  @override
  State<IconButtonCustom> createState() => _IconButtonCustomState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed));
    properties.add(EnumProperty<IconButtonVariant>('variant', variant));
    properties.add(EnumProperty<IconButtonSize>('size', size));
    properties.add(IntProperty('badgeCount', badgeCount));
    properties.add(ColorProperty('iconColor', iconColor));
    properties.add(ColorProperty('backgroundColor', backgroundColor));
  }
}

class _IconButtonCustomState extends State<IconButtonCustom>
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

    _scaleAnimation = Tween<double>(begin: 1, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.buttonCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
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

  double get _buttonSize {
    switch (widget.size) {
      case IconButtonSize.small:
        return 36.r;
      case IconButtonSize.medium:
        return 44.r;
      case IconButtonSize.large:
        return 52.r;
    }
  }

  double get _iconSize {
    switch (widget.size) {
      case IconButtonSize.small:
        return 18.sp;
      case IconButtonSize.medium:
        return 22.sp;
      case IconButtonSize.large:
        return 26.sp;
    }
  }

  Color get _defaultIconColor {
    if (widget.iconColor != null) return widget.iconColor!;

    switch (widget.variant) {
      case IconButtonVariant.filled:
        return AppColors.white;
      case IconButtonVariant.outlined:
      case IconButtonVariant.ghost:
        return AppColors.primaryDark;
    }
  }

  Color? get _defaultBackgroundColor {
    if (widget.backgroundColor != null) return widget.backgroundColor;

    switch (widget.variant) {
      case IconButtonVariant.filled:
        return AppColors.accentOrange;
      case IconButtonVariant.outlined:
        return Colors.transparent;
      case IconButtonVariant.ghost:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    isDisabled = widget.onPressed == null;

    Widget button = GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(scale: _scaleAnimation.value, child: child),
        child: Container(
          width: _buttonSize,
          height: _buttonSize,
          decoration: BoxDecoration(
            color: isDisabled ? AppColors.lightGray : _defaultBackgroundColor,
            shape: BoxShape.circle,
            border: widget.variant == IconButtonVariant.outlined
                ? Border.all(
                    color: isDisabled
                        ? AppColors.gray.withOpacity(0.5)
                        : AppColors.accentOrange,
                    width: 1.5,
                  )
                : null,
            boxShadow: widget.variant == IconButtonVariant.filled && !isDisabled
                ? AppShadows.sm
                : null,
          ),
          child: Icon(
            widget.icon,
            color: isDisabled ? AppColors.gray : _defaultIconColor,
            size: _iconSize,
          ),
        ),
      ),
    );

    // Add badge if count is provided
    if (widget.badgeCount != null && widget.badgeCount! > 0) {
      button = Stack(
        clipBehavior: Clip.none,
        children: [
          button,
          Positioned(
            right: -4.w,
            top: -4.h,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.badgeCount! > 9 ? 5.w : 6.w,
                vertical: 2.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
                boxShadow: AppShadows.sm,
              ),
              constraints: BoxConstraints(minWidth: 18.r, minHeight: 18.r),
              child: Center(
                child: Text(
                  widget.badgeCount! > 99 ? '99+' : '${widget.badgeCount}',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return button;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isDisabled', isDisabled));
  }
}

/// Icon button style variants
enum IconButtonVariant {
  /// Filled background with white icon
  filled,

  /// Outlined border with transparent background
  outlined,

  /// No background or border (ghost)
  ghost,
}

/// Icon button size options
enum IconButtonSize {
  /// Small - 36x36
  small,

  /// Medium - 44x44 (default, follows Material touch target guidelines)
  medium,

  /// Large - 52x52
  large,
}
