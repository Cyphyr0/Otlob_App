import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

/// Custom Text Field Component
///
/// A consistent, styled text field with:
/// - Label and hint text support
/// - Error state display
/// - Prefix/suffix icon support
/// - Validation display
/// - Obscure text for passwords
/// - Input formatters support
/// - Max length support
///
/// Usage Examples:
/// ```dart
/// // Basic text field
/// CustomTextField(
///   label: 'Email',
///   hint: 'Enter your email',
///   controller: _emailController,
/// )
///
/// // Password field
/// CustomTextField(
///   label: 'Password',
///   obscureText: true,
///   prefixIcon: Icons.lock_outline,
///   controller: _passwordController,
/// )
///
/// // With validation
/// CustomTextField(
///   label: 'Phone Number',
///   errorText: _phoneError,
///   keyboardType: TextInputType.phone,
///   controller: _phoneController,
/// )
///
/// // With suffix icon
/// CustomTextField(
///   label: 'Amount',
///   hint: '0.00',
///   suffixText: 'EGP',
///   keyboardType: TextInputType.number,
///   controller: _amountController,
/// )
/// ```
class CustomTextField extends StatefulWidget {
  /// Text editing controller
  final TextEditingController? controller;

  /// Label text above the field
  final String? label;

  /// Hint text inside the field
  final String? hint;

  /// Error text to display
  final String? errorText;

  /// Prefix icon
  final IconData? prefixIcon;

  /// Suffix icon
  final IconData? suffixIcon;

  /// Suffix text (e.g., "EGP", "kg")
  final String? suffixText;

  /// Callback when suffix icon is pressed
  final VoidCallback? onSuffixIconPressed;

  /// Obscure text (for passwords)
  final bool obscureText;

  /// Keyboard type
  final TextInputType? keyboardType;

  /// Text input action
  final TextInputAction? textInputAction;

  /// Callback when text changes
  final ValueChanged<String>? onChanged;

  /// Callback when field is submitted
  final ValueChanged<String>? onSubmitted;

  /// Maximum length
  final int? maxLength;

  /// Maximum lines
  final int? maxLines;

  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// Whether field is enabled
  final bool enabled;

  /// Auto focus
  final bool autofocus;

  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixText,
    this.onSuffixIconPressed,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.maxLength,
    this.maxLines = 1,
    this.inputFormatters,
    this.enabled = true,
    this.autofocus = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _hasFocus = false;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChanged);
    _obscureText = widget.obscureText;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.titleSmall.copyWith(
              color: hasError ? AppColors.error : AppColors.primaryDark,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
        ],

        // Text field
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          inputFormatters: widget.inputFormatters,
          style: AppTypography.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.gray),
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: hasError
                        ? AppColors.error
                        : _hasFocus
                        ? AppColors.accentOrange
                        : AppColors.gray,
                    size: 22.sp,
                  )
                : null,
            suffixIcon: _buildSuffixIcon(hasError),
            suffixText: widget.suffixText,
            suffixStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.gray,
            ),
            filled: true,
            fillColor: widget.enabled
                ? AppColors.white
                : AppColors.lightGray.withOpacity(0.5),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            border: OutlineInputBorder(
              borderRadius: AppRadius.inputRadius,
              borderSide: const BorderSide(color: AppColors.lightGray),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.inputRadius,
              borderSide: BorderSide(
                color: hasError ? AppColors.error : AppColors.lightGray,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.inputRadius,
              borderSide: BorderSide(
                color: hasError ? AppColors.error : AppColors.accentOrange,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.inputRadius,
              borderSide: const BorderSide(color: AppColors.lightGray),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.inputRadius,
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.inputRadius,
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            counterText: '',
          ),
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
        ),

        // Error text
        if (hasError) ...[
          SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(Icons.error_outline, size: 14.sp, color: AppColors.error),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  widget.errorText!,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget? _buildSuffixIcon(bool hasError) {
    // Password visibility toggle
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: hasError ? AppColors.error : AppColors.gray,
          size: 22.sp,
        ),
        onPressed: _toggleObscureText,
      );
    }

    // Custom suffix icon
    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(
          widget.suffixIcon,
          color: hasError ? AppColors.error : AppColors.gray,
          size: 22.sp,
        ),
        onPressed: widget.onSuffixIconPressed,
      );
    }

    return null;
  }
}
