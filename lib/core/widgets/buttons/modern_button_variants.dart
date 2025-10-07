import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_animations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_shadows.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Modern Button Variants for Otlob App
///
/// A comprehensive button system with multiple variants, sizes, and states.
/// Features Egyptian cultural styling with modern tech-forward aesthetics.
///
/// Variants:
/// - Primary: Main CTA button with Imperial Red background
/// - Secondary: Subtle button with outline style
/// - Ghost: Minimal button with no background
/// - Icon: Icon-only button for toolbars and actions
///
/// Usage:
/// ```dart
/// // Primary CTA
/// ModernButton.primary(
///   text: 'Order Now',
///   onPressed: () => placeOrder(),
/// )
///
/// // Secondary action
/// ModernButton.secondary(
///   text: 'Add to Favorites',
///   onPressed: () => toggleFavorite(),
///   icon: Icons.favorite_border,
/// )
///
/// // Icon button
/// ModernButton.icon(
///   icon: Icons.search,
///   onPressed: () => openSearch(),
///   size: ButtonSize.small,
/// )
/// ```
class ModernButton extends StatefulWidget {
  const ModernButton._({
    required this.variant, required this.size, super.key,
    this.text,
    this.icon,
    this.leadingIcon,
    this.trailingIcon,
    this.onPressed,
    this.isLoading = false,
    this.fullWidth = false,
    this.elevation = true,
    this.customColor,
    this.borderColor,
  });

  /// Primary button - Main CTA with Imperial Red background
  factory ModernButton.primary({
    Key? key,
    String? text,
    IconData? icon,
    IconData? leadingIcon,
    IconData? trailingIcon,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool fullWidth = false,
    ButtonSize size = ButtonSize.medium,
    bool elevation = true,
  }) => ModernButton._(
      key: key,
      variant: ButtonVariant.primary,
      size: size,
      text: text,
      icon: icon,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      onPressed: onPressed,
      isLoading: isLoading,
      fullWidth: fullWidth,
      elevation: elevation,
    );

  /// Secondary button - Subtle with outline style
  factory ModernButton.secondary({
    Key? key,
    String? text,
    IconData? icon,
    IconData? leadingIcon,
    IconData? trailingIcon,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool fullWidth = false,
    ButtonSize size = ButtonSize.medium,
    Color? borderColor,
  }) => ModernButton._(
      key: key,
      variant: ButtonVariant.secondary,
      size: size,
      text: text,
      icon: icon,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      onPressed: onPressed,
      isLoading: isLoading,
      fullWidth: fullWidth,
      borderColor: borderColor,
    );

  /// Ghost button - Minimal with no background
  factory ModernButton.ghost({
    Key? key,
    String? text,
    IconData? icon,
    IconData? leadingIcon,
    IconData? trailingIcon,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool fullWidth = false,
    ButtonSize size = ButtonSize.medium,
    Color? customColor,
  }) => ModernButton._(
      key: key,
      variant: ButtonVariant.ghost,
      size: size,
      text: text,
      icon: icon,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      onPressed: onPressed,
      isLoading: isLoading,
      fullWidth: fullWidth,
      customColor: customColor,
    );

  /// Icon button - Icon only for toolbars and compact spaces
  factory ModernButton.icon({
    required IconData icon, Key? key,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.medium,
    bool isLoading = false,
    Color? customColor,
  }) => ModernButton._(
      key: key,
      variant: ButtonVariant.icon,
      size: size,
      icon: icon,
      onPressed: onPressed,
      isLoading: isLoading,
      customColor: customColor,
    );

  final ButtonVariant variant;
  final ButtonSize size;
  final String? text;
  final IconData? icon;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final bool fullWidth;
  final bool elevation;
  final Color? customColor;
  final Color? borderColor;

  @override
  State<ModernButton> createState() => _ModernButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<ButtonVariant>('variant', variant));
    properties.add(EnumProperty<ButtonSize>('size', size));
    properties.add(StringProperty('text', text));
    properties.add(DiagnosticsProperty<IconData?>('icon', icon));
    properties.add(DiagnosticsProperty<IconData?>('leadingIcon', leadingIcon));
    properties.add(DiagnosticsProperty<IconData?>('trailingIcon', trailingIcon));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onPressed', onPressed));
    properties.add(DiagnosticsProperty<bool>('isLoading', isLoading));
    properties.add(DiagnosticsProperty<bool>('isDisabled', isDisabled));
    properties.add(DiagnosticsProperty<bool>('fullWidth', fullWidth));
    properties.add(DiagnosticsProperty<bool>('elevation', elevation));
    properties.add(ColorProperty('customColor', customColor));
    properties.add(ColorProperty('borderColor', borderColor));
  }
}

class _ModernButtonState extends State<ModernButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.buttonPress,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 0.96).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 1, end: 0.7).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading && !widget.isDisabled) {
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.isDisabled ||
        widget.onPressed == null ||
        widget.isLoading;

    final config = _getButtonConfig();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: isDisabled ? null : widget.onPressed,
        child: Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: isDisabled ? 0.5 : _opacityAnimation.value,
            child: _ButtonContent(
              config: config,
              widget: widget,
              isDisabled: isDisabled,
            ),
          ),
        ),
      ),
    );
  }

  ButtonConfig _getButtonConfig() {
    switch (widget.variant) {
      case ButtonVariant.primary:
        return ButtonConfig(
          backgroundColor: widget.customColor ?? AppColors.logoRed,
          foregroundColor: AppColors.white,
          borderColor: widget.borderColor ?? AppColors.logoRed,
          shadowColor: AppColors.logoRed.withOpacity(0.3),
          elevation: widget.elevation ? 2 : 0,
        );
      case ButtonVariant.secondary:
        return ButtonConfig(
          backgroundColor: Colors.transparent,
          foregroundColor: widget.customColor ?? AppColors.logoRed,
          borderColor: widget.borderColor ?? widget.customColor ?? AppColors.logoRed,
          shadowColor: Colors.transparent,
          elevation: 0,
        );
      case ButtonVariant.ghost:
        return ButtonConfig(
          backgroundColor: Colors.transparent,
          foregroundColor: widget.customColor ?? AppColors.logoRed,
          borderColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
        );
      case ButtonVariant.icon:
        return ButtonConfig(
          backgroundColor: widget.customColor ?? AppColors.logoRed.withOpacity(0.1),
          foregroundColor: widget.customColor ?? AppColors.logoRed,
          borderColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
        );
    }
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.config,
    required this.widget,
    required this.isDisabled,
  });

  final ButtonConfig config;
  final ModernButton widget;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final sizeConfig = _getSizeConfig();

    Widget content = Container(
      height: sizeConfig.height,
      width: widget.fullWidth ? double.infinity : sizeConfig.width,
      padding: sizeConfig.padding,
      decoration: BoxDecoration(
        color: config.backgroundColor,
        border: widget.variant != ButtonVariant.ghost && widget.variant != ButtonVariant.icon
            ? Border.all(color: config.borderColor, width: 1.5)
            : null,
        borderRadius: BorderRadius.circular(sizeConfig.borderRadius),
        boxShadow: config.elevation > 0
            ? [
                BoxShadow(
                  color: config.shadowColor,
                  blurRadius: config.elevation * 2,
                  offset: Offset(0, config.elevation),
                ),
              ]
            : null,
      ),
      child: _buildButtonContent(sizeConfig),
    );

    return Material(
      color: Colors.transparent,
      child: content,
    );
  }

  Widget _buildButtonContent(ButtonSizeConfig sizeConfig) {
    if (widget.variant == ButtonVariant.icon) {
      return _buildIconContent(sizeConfig);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.leadingIcon != null) ...[
          Icon(
            widget.leadingIcon,
            size: sizeConfig.iconSize,
            color: config.foregroundColor,
          ),
          SizedBox(width: sizeConfig.iconSpacing),
        ],
        if (widget.isLoading)
          SizedBox(
            width: sizeConfig.iconSize,
            height: sizeConfig.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(config.foregroundColor),
            ),
          )
        else if (widget.text != null && widget.text!.isNotEmpty)
          Text(
            widget.text!,
            style: sizeConfig.textStyle.copyWith(
              color: config.foregroundColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        if (widget.trailingIcon != null) ...[
          SizedBox(width: sizeConfig.iconSpacing),
          Icon(
            widget.trailingIcon,
            size: sizeConfig.iconSize,
            color: config.foregroundColor,
          ),
        ],
      ],
    );
  }

  Widget _buildIconContent(ButtonSizeConfig sizeConfig) => Icon(
      widget.icon,
      size: sizeConfig.iconSize,
      color: config.foregroundColor,
    );

  ButtonSizeConfig _getSizeConfig() {
    switch (widget.size) {
      case ButtonSize.small:
        return ButtonSizeConfig(
          height: 32.h,
          width: null,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          iconSize: 16.sp,
          iconSpacing: 4.w,
          borderRadius: AppRadius.sm,
          textStyle: AppTypography.labelSmall,
        );
      case ButtonSize.medium:
        return ButtonSizeConfig(
          height: 48.h,
          width: null,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          iconSize: 20.sp,
          iconSpacing: 8.w,
          borderRadius: 12.r,
          textStyle: AppTypography.labelLarge,
        );
      case ButtonSize.large:
        return ButtonSizeConfig(
          height: 56.h,
          width: null,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          iconSize: 24.sp,
          iconSpacing: 12.w,
          borderRadius: AppRadius.lg,
          textStyle: AppTypography.headlineSmall,
        );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ButtonConfig>('config', config));
    properties.add(DiagnosticsProperty<bool>('isDisabled', isDisabled));
  }
}

/// Button configuration for different variants
class ButtonConfig {
  const ButtonConfig({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    required this.shadowColor,
    required this.elevation,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final Color shadowColor;
  final double elevation;
}

/// Button size configuration
class ButtonSizeConfig {
  const ButtonSizeConfig({
    required this.height,
    required this.width,
    required this.padding,
    required this.iconSize,
    required this.iconSpacing,
    required this.borderRadius,
    required this.textStyle,
  });

  final double? height;
  final double? width;
  final EdgeInsets padding;
  final double iconSize;
  final double iconSpacing;
  final double borderRadius;
  final TextStyle textStyle;
}

/// Button variants
enum ButtonVariant {
  primary,
  secondary,
  ghost,
  icon,
}

/// Button sizes
enum ButtonSize {
  small,
  medium,
  large,
}