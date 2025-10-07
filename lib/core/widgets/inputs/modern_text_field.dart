import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Modern Text Field with Egyptian Cultural Styling
///
/// A sophisticated input component featuring:
/// - Egyptian cultural design elements
/// - Smooth focus animations
/// - Built-in validation states
/// - Icon support with cultural context
/// - RTL support for Arabic text
/// - Accessibility features
///
/// Usage:
/// ```dart
/// ModernTextField(
///   label: 'Restaurant Name',
///   hint: 'Enter restaurant name in Arabic',
///   controller: _controller,
///   validator: (value) => value?.isEmpty == true ? 'Required' : null,
///   leadingIcon: Icons.restaurant,
///   inputType: TextInputType.text,
/// )
/// ```
class ModernTextField extends StatefulWidget {
  const ModernTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.leadingIcon,
    this.trailingIcon,
    this.inputType,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.style,
    this.filled = true,
    this.borderStyle = InputBorderStyle.outlined,
    this.size = FieldSize.medium,
    this.variant = FieldVariant.primary,
    this.culturalPattern = CulturalPattern.none,
  });

  /// Text editing controller
  final TextEditingController? controller;

  /// Field labels and hints
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;

  /// Icons
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  /// Input configuration
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int maxLines;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;

  /// Validation and callbacks
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final FocusNode? focusNode;

  /// Text styling
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextStyle? style;

  /// Visual styling
  final bool filled;
  final InputBorderStyle borderStyle;
  final FieldSize size;
  final FieldVariant variant;
  final CulturalPattern culturalPattern;

  @override
  State<ModernTextField> createState() => _ModernTextFieldState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController?>('controller', controller));
    properties.add(StringProperty('label', label));
    properties.add(StringProperty('hint', hint));
    properties.add(StringProperty('errorText', errorText));
    properties.add(StringProperty('helperText', helperText));
    properties.add(DiagnosticsProperty<IconData?>('leadingIcon', leadingIcon));
    properties.add(DiagnosticsProperty<IconData?>('trailingIcon', trailingIcon));
    properties.add(DiagnosticsProperty<TextInputType?>('inputType', inputType));
    properties.add(IterableProperty<TextInputFormatter>('inputFormatters', inputFormatters));
    properties.add(IntProperty('maxLength', maxLength));
    properties.add(IntProperty('maxLines', maxLines));
    properties.add(DiagnosticsProperty<bool>('obscureText', obscureText));
    properties.add(DiagnosticsProperty<bool>('readOnly', readOnly));
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
    properties.add(DiagnosticsProperty<bool>('autofocus', autofocus));
    properties.add(ObjectFlagProperty<String? Function(String? p1)?>.has('validator', validator));
    properties.add(ObjectFlagProperty<Function(String p1)?>.has('onChanged', onChanged));
    properties.add(ObjectFlagProperty<Function(String p1)?>.has('onSubmitted', onSubmitted));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode));
    properties.add(EnumProperty<TextDirection?>('textDirection', textDirection));
    properties.add(EnumProperty<TextAlign>('textAlign', textAlign));
    properties.add(DiagnosticsProperty<TextStyle?>('style', style));
    properties.add(DiagnosticsProperty<bool>('filled', filled));
    properties.add(EnumProperty<InputBorderStyle>('borderStyle', borderStyle));
    properties.add(EnumProperty<FieldSize>('size', size));
    properties.add(EnumProperty<FieldVariant>('variant', variant));
    properties.add(EnumProperty<CulturalPattern>('culturalPattern', culturalPattern));
  }
}

class _ModernTextFieldState extends State<ModernTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _borderColorAnimation;
  late Animation<Color?> _iconColorAnimation;

  late FocusNode _focusNode;
  late TextEditingController _controller;

  bool _isFocused = false;
  bool _hasError = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();

    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController();

    _focusNode.addListener(_handleFocusChange);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _setupAnimations();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    final defaultColor = _getDefaultBorderColor();
    final focusedColor = _getFocusedBorderColor();

    _borderColorAnimation = ColorTween(
      begin: defaultColor,
      end: focusedColor,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _iconColorAnimation = ColorTween(
      begin: AppColors.gray,
      end: AppColors.logoRed,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _handleFocusChange() {
    final focused = _focusNode.hasFocus;
    setState(() {
      _isFocused = focused;
      _validateField();
    });

    if (focused) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _validateField() {
    if (widget.validator != null) {
      final error = widget.validator!(_controller.text);
      setState(() {
        _hasError = error != null;
        _errorText = error;
      });
    }
  }

  Color _getDefaultBorderColor() {
    if (_hasError) return AppColors.error;
    return AppColors.lightGray;
  }

  Color _getFocusedBorderColor() {
    if (_hasError) return AppColors.error;
    return AppColors.logoRed;
  }

  @override
  Widget build(BuildContext context) {
    final config = _getFieldConfig();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Transform.scale(
        scale: _isFocused ? _scaleAnimation.value : 1.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.label != null) ...[
              Text(
                widget.label!,
                style: config.labelStyle,
              ),
              SizedBox(height: 8.h),
            ],
            DecoratedBox(
              decoration: _getContainerDecoration(config),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: _getInputDecoration(config),
                keyboardType: widget.inputType,
                inputFormatters: widget.inputFormatters,
                maxLength: widget.maxLength,
                maxLines: widget.obscureText ? 1 : widget.maxLines,
                obscureText: widget.obscureText,
                readOnly: widget.readOnly,
                enabled: widget.enabled,
                autofocus: widget.autofocus,
                textDirection: widget.textDirection,
                textAlign: widget.textAlign,
                style: widget.style ?? config.textStyle,
                onChanged: (value) {
                  _validateField();
                  widget.onChanged?.call(value);
                },
                onSubmitted: widget.onSubmitted,
                onTap: widget.onTap,
              ),
            ),
            if (_errorText != null || widget.helperText != null) ...[
              SizedBox(height: 4.h),
              Text(
                _errorText ?? widget.helperText ?? '',
                style: (_errorText != null ? config.errorStyle : config.helperStyle),
              ),
            ],
          ],
        ),
      ),
    );
  }

  BoxDecoration _getContainerDecoration(FieldConfig config) {
    if (widget.culturalPattern != CulturalPattern.none) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(config.borderRadius),
        border: Border.all(
          color: _borderColorAnimation.value ?? _getDefaultBorderColor(),
          width: _isFocused ? 2 : 1,
        ),
        color: config.backgroundColor,
        boxShadow: _isFocused ? [
          BoxShadow(
            color: AppColors.logoRed.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      );
    }

    return BoxDecoration(
      borderRadius: BorderRadius.circular(config.borderRadius),
      border: Border.all(
        color: _borderColorAnimation.value ?? _getDefaultBorderColor(),
        width: _isFocused ? 2 : 1,
      ),
      color: config.backgroundColor,
    );
  }

  InputDecoration _getInputDecoration(FieldConfig config) => InputDecoration(
      hintText: widget.hint,
      hintStyle: config.hintStyle,
      errorText: widget.errorText,
      errorStyle: config.errorStyle,
      helperText: widget.helperText,
      helperStyle: config.helperStyle,
      prefixIcon: widget.leadingIcon != null
          ? AnimatedBuilder(
              animation: _iconColorAnimation,
              builder: (context, child) => Icon(
                widget.leadingIcon,
                color: _iconColorAnimation.value,
                size: config.iconSize,
              ),
            )
          : null,
      suffixIcon: widget.trailingIcon != null
          ? Icon(
              widget.trailingIcon,
              color: _iconColorAnimation.value,
              size: config.iconSize,
            )
          : null,
      contentPadding: config.contentPadding,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      filled: false,
      fillColor: Colors.transparent,
    );

  FieldConfig _getFieldConfig() {
    switch (widget.size) {
      case FieldSize.small:
        return FieldConfig(
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 12.h,
          ),
          iconSize: 18.sp,
          borderRadius: 8.r,
          labelStyle: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.primaryBlack,
          ),
          textStyle: AppTypography.bodySmall,
          hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.gray),
          errorStyle: AppTypography.bodySmall.copyWith(color: AppColors.error),
          helperStyle: AppTypography.bodySmall.copyWith(color: AppColors.gray),
          backgroundColor: widget.filled ? AppColors.offWhite : Colors.transparent,
        );
      case FieldSize.medium:
        return FieldConfig(
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 16.h,
          ),
          iconSize: 20.sp,
          borderRadius: 12.r,
          labelStyle: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.primaryBlack,
          ),
          textStyle: AppTypography.bodyMedium,
          hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.gray),
          errorStyle: AppTypography.bodyMedium.copyWith(color: AppColors.error),
          helperStyle: AppTypography.bodyMedium.copyWith(color: AppColors.gray),
          backgroundColor: widget.filled ? AppColors.offWhite : Colors.transparent,
        );
      case FieldSize.large:
        return FieldConfig(
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: 20.h,
          ),
          iconSize: 24.sp,
          borderRadius: 16.r,
          labelStyle: AppTypography.bodyLarge.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.primaryBlack,
          ),
          textStyle: AppTypography.bodyLarge,
          hintStyle: AppTypography.bodyLarge.copyWith(color: AppColors.gray),
          errorStyle: AppTypography.bodyLarge.copyWith(color: AppColors.error),
          helperStyle: AppTypography.bodyLarge.copyWith(color: AppColors.gray),
          backgroundColor: widget.filled ? AppColors.offWhite : Colors.transparent,
        );
    }
  }
}

/// Field configuration for different sizes
class FieldConfig {
  const FieldConfig({
    required this.contentPadding,
    required this.iconSize,
    required this.borderRadius,
    required this.labelStyle,
    required this.textStyle,
    required this.hintStyle,
    required this.errorStyle,
    required this.helperStyle,
    required this.backgroundColor,
  });

  final EdgeInsets contentPadding;
  final double iconSize;
  final double borderRadius;
  final TextStyle labelStyle;
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final TextStyle errorStyle;
  final TextStyle helperStyle;
  final Color backgroundColor;
}

/// Field size variants
enum FieldSize {
  small,
  medium,
  large,
}

/// Field variant styles
enum FieldVariant {
  primary,
  secondary,
  outline,
}

/// Cultural pattern options for Egyptian styling
enum CulturalPattern {
  none,
  subtle,
  prominent,
}

/// Input border styles
enum InputBorderStyle {
  outlined,
  underlined,
  filled,
}