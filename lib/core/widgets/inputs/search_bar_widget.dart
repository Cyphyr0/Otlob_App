import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_shadows.dart';
import '../../theme/app_animations.dart';

/// Search Bar Widget Component
///
/// A floating white search bar with:
/// - Shadow effect for depth
/// - Search icon on left
/// - Clear button on right (when text exists)
/// - Smooth focus animation
/// - Debounced input for performance
/// - Responsive design
///
/// Usage Examples:
/// ```dart
/// // Basic usage
/// SearchBarWidget(
///   onSearch: (query) => _performSearch(query),
/// )
///
/// // With hint text
/// SearchBarWidget(
///   hintText: 'Search for restaurants...',
///   onSearch: _search,
/// )
///
/// // With controller
/// SearchBarWidget(
///   controller: _searchController,
///   onSearch: _handleSearch,
///   onClear: _clearSearch,
/// )
///
/// // With debounce
/// SearchBarWidget(
///   onSearch: _search,
///   debounceDuration: Duration(milliseconds: 500),
/// )
/// ```
class SearchBarWidget extends StatefulWidget {
  /// Callback when search query changes (after debounce)
  final ValueChanged<String>? onSearch;

  /// Callback when search is submitted
  final ValueChanged<String>? onSubmitted;

  /// Callback when clear button is pressed
  final VoidCallback? onClear;

  /// Text editing controller (optional)
  final TextEditingController? controller;

  /// Hint text displayed when empty
  final String hintText;

  /// Debounce duration for search input
  final Duration debounceDuration;

  /// Auto focus on widget creation
  final bool autofocus;

  const SearchBarWidget({
    super.key,
    this.onSearch,
    this.onSubmitted,
    this.onClear,
    this.controller,
    this.hintText = 'Search...',
    this.debounceDuration = const Duration(milliseconds: 300),
    this.autofocus = false,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  Timer? _debounceTimer;
  bool _hasFocus = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();

    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);

    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _focusNode.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }

    // Cancel previous timer
    _debounceTimer?.cancel();

    // Start new debounce timer
    if (widget.onSearch != null) {
      _debounceTimer = Timer(widget.debounceDuration, () {
        widget.onSearch!(_controller.text);
      });
    }
  }

  void _onFocusChanged() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  void _onClearPressed() {
    _controller.clear();
    if (widget.onClear != null) {
      widget.onClear!();
    }
    if (widget.onSearch != null) {
      widget.onSearch!('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppAnimations.fast,
      curve: AppAnimations.easeOut,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.inputRadius,
        boxShadow: _hasFocus ? AppShadows.md : AppShadows.sm,
        border: Border.all(
          color: _hasFocus ? AppColors.accentOrange : Colors.transparent,
          width: _hasFocus ? 2 : 0,
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        style: AppTypography.bodyLarge,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.gray),
          prefixIcon: Icon(
            Icons.search,
            color: _hasFocus ? AppColors.accentOrange : AppColors.gray,
            size: 24.sp,
          ),
          suffixIcon: _hasText
              ? IconButton(
                  icon: Icon(Icons.clear, color: AppColors.gray, size: 20.sp),
                  onPressed: _onClearPressed,
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
        ),
        onSubmitted: widget.onSubmitted,
        textInputAction: TextInputAction.search,
      ),
    );
  }
}
