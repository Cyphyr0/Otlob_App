import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/app_animations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_shadows.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Dish Card Component
///
/// A compact card displaying dish information with:
/// - Dish image
/// - Name and price
/// - Add to cart button
/// - Optional special tag (e.g., "Popular", "New")
/// - Tap animation
/// - Loading state
///
/// Usage Examples:
/// ```dart
/// // Basic usage
/// DishCard(
///   imageUrl: 'https://example.com/dish.jpg',
///   name: 'Koshari',
///   price: 45.0,
///   onTap: () => _viewDish(dish),
///   onAddToCart: () => _addToCart(dish),
/// )
///
/// // With special tag
/// DishCard(
///   imageUrl: imageUrl,
///   name: name,
///   price: price,
///   specialTag: 'Popular',
///   onTap: onTap,
///   onAddToCart: onAddToCart,
/// )
///
/// // Loading state
/// DishCard.loading()
/// ```
class DishCard extends StatefulWidget {

  const DishCard({
    required this.name, required this.price, super.key,
    this.imageUrl,
    this.specialTag,
    this.onTap,
    this.onAddToCart,
    this.isLoading = false,
  });

  /// Loading state constructor
  const DishCard.loading({super.key})
    : imageUrl = null,
      name = '',
      price = 0.0,
      specialTag = null,
      onTap = null,
      onAddToCart = null,
      isLoading = true;
  /// Dish image URL
  final String? imageUrl;

  /// Dish name
  final String name;

  /// Dish price in EGP
  final double price;

  /// Optional special tag (e.g., "Popular", "New", "Chef's Special")
  final String? specialTag;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  /// Callback when add to cart button is pressed
  final VoidCallback? onAddToCart;

  /// Show loading shimmer state
  final bool isLoading;

  @override
  State<DishCard> createState() => _DishCardState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('imageUrl', imageUrl));
    properties.add(StringProperty('name', name));
    properties.add(DoubleProperty('price', price));
    properties.add(StringProperty('specialTag', specialTag));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onAddToCart', onAddToCart));
    properties.add(DiagnosticsProperty<bool>('isLoading', isLoading));
  }
}

class _DishCardState extends State<DishCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.cardAnimation,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.cardCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null && !widget.isLoading) {
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
    if (widget.isLoading) {
      return _buildLoadingState();
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(scale: _scaleAnimation.value, child: child),
        child: Container(
          width: 160.w,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: AppRadius.cardRadius,
            boxShadow: AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [_buildImage(), _buildDetails()],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() => Stack(
      children: [
        // Dish image
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadius.lg),
            topRight: Radius.circular(AppRadius.lg),
          ),
          child: Container(
            height: 120.h,
            width: double.infinity,
            color: AppColors.lightGray,
            child: widget.imageUrl != null
                ? Image.network(
                    widget.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.fastfood,
                        size: 40,
                        color: AppColors.gray,
                      ),
                  )
                : const Icon(Icons.fastfood, size: 40, color: AppColors.gray),
          ),
        ),

        // Special tag (top-left)
        if (widget.specialTag != null)
          Positioned(
            top: AppSpacing.xs,
            left: AppSpacing.xs,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.logoRed,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                boxShadow: AppShadows.sm,
              ),
              child: Text(
                widget.specialTag!,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ),
      ],
    );

  Widget _buildDetails() => Padding(
      padding: EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dish name
          Text(
            widget.name,
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSpacing.xs),
          // Price and add button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Price
              Text(
                '${widget.price.toStringAsFixed(0)} EGP',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.logoRed,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // Add to cart button
              if (widget.onAddToCart != null)
                GestureDetector(
                  onTap: widget.onAddToCart,
                  child: Container(
                    padding: EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.logoRed,
                      shape: BoxShape.circle,
                      boxShadow: AppShadows.sm,
                    ),
                    child: Icon(Icons.add, color: AppColors.white, size: 18.sp),
                  ),
                ),
            ],
          ),
        ],
      ),
    );

  Widget _buildLoadingState() => Shimmer.fromColors(
      baseColor: AppColors.lightGray,
      highlightColor: AppColors.white,
      child: Container(
        width: 160.w,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: AppRadius.cardRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 120.h,
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.lg),
                  topRight: Radius.circular(AppRadius.lg),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14.h,
                    width: 100.w,
                    color: AppColors.lightGray,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Container(
                    height: 16.h,
                    width: 60.w,
                    color: AppColors.lightGray,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
}
