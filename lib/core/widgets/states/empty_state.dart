import "package:flutter/material.dart";
import "package:flutter/foundation.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "../../theme/app_colors.dart";
import "../../theme/app_typography.dart";
import "../../theme/app_spacing.dart";
import "../buttons/primary_button.dart";

/// Empty State Component
///
/// A friendly empty state display with:
/// - Icon or illustration
/// - Title and message
/// - Optional action button
/// - Multiple predefined variants
///
/// Usage Examples:
/// ```dart
/// // Custom empty state
/// EmptyState(
///   icon: Icons.restaurant_menu,
///   title: 'No Restaurants Found',
///   message: 'Try adjusting your search filters',
///   actionText: 'Clear Filters',
///   onAction: _clearFilters,
/// )
///
/// // No favorites
/// EmptyState.noFavorites(
///   onAction: () => context.go('/home'),
/// )
///
/// // No search results
/// EmptyState.noSearchResults()
///
/// // No orders
/// EmptyState.noOrders(
///   onAction: _browseRestaurants,
/// )
/// ```
class EmptyState extends StatelessWidget {

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
    this.iconColor,
  });

  /// No favorites empty state
  factory EmptyState.noFavorites({VoidCallback? onAction}) {
    return EmptyState(
      icon: Icons.favorite_border,
      title: 'No Favorites Yet',
      message: 'Start exploring and save your favorite restaurants here',
      actionText: 'Explore Restaurants',
      onAction: onAction,
      iconColor: AppColors.error,
    );
  }

  /// No search results empty state
  factory EmptyState.noSearchResults({String? query}) {
    return EmptyState(
      icon: Icons.search_off,
      title: 'No Results Found',
      message: query != null
          ? 'We couldn\'t find anything matching "$query"'
          : 'Try different keywords or filters',
      iconColor: AppColors.gray,
    );
  }

  /// No orders empty state
  factory EmptyState.noOrders({VoidCallback? onAction}) {
    return EmptyState(
      icon: Icons.receipt_long_outlined,
      title: 'No Orders Yet',
      message:
          'Your order history will appear here once you place your first order',
      actionText: 'Browse Restaurants',
      onAction: onAction,
      iconColor: AppColors.logoRed,
    );
  }

  /// Empty cart state
  factory EmptyState.emptyCart({VoidCallback? onAction}) {
    return EmptyState(
      icon: Icons.shopping_cart_outlined,
      title: 'Your Cart is Empty',
      message: 'Add some delicious items to get started',
      actionText: 'Start Shopping',
      onAction: onAction,
      iconColor: AppColors.logoRed,
    );
  }

  /// No notifications state
  factory EmptyState.noNotifications() {
    return EmptyState(
      icon: Icons.notifications_none,
      title: 'No Notifications',
      message:
          'You\'re all caught up! We\'ll notify you when something new happens',
      iconColor: AppColors.gray,
    );
  }

  /// Network error state
  factory EmptyState.networkError({VoidCallback? onAction}) {
    return EmptyState(
      icon: Icons.wifi_off,
      title: 'No Internet Connection',
      message: 'Please check your connection and try again',
      actionText: 'Retry',
      onAction: onAction,
      iconColor: AppColors.error,
    );
  }

  /// Generic error state
  factory EmptyState.error({VoidCallback? onAction, String? message}) {
    return EmptyState(
      icon: Icons.error_outline,
      title: 'Something Went Wrong',
      message: message ?? 'We encountered an error. Please try again',
      actionText: 'Retry',
      onAction: onAction,
      iconColor: AppColors.error,
    );
  }
  /// Icon to display
  final IconData icon;

  /// Title text
  final String title;

  /// Description message
  final String message;

  /// Action button text (optional)
  final String? actionText;

  /// Callback when action button is pressed
  final VoidCallback? onAction;

  /// Icon color
  final Color? iconColor;

  @override
  Widget build(BuildContext context) => Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 120.r,
              height: 120.r,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.logoRed).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 60.sp,
                color: iconColor ?? AppColors.logoRed,
              ),
            ),
            SizedBox(height: AppSpacing.lg),

            // Title
            Text(
              title,
              style: AppTypography.headlineMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm),

            // Message
            Text(
              message,
              style: AppTypography.bodyLarge.copyWith(color: AppColors.gray),
              textAlign: TextAlign.center,
            ),

            // Action button
            if (actionText != null && onAction != null) ...[
              SizedBox(height: AppSpacing.xl),
              PrimaryButton(text: actionText!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<IconData>('icon', icon));
    properties.add(StringProperty('title', title));
    properties.add(StringProperty('message', message));
    properties.add(StringProperty('actionText', actionText));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onAction', onAction));
    properties.add(ColorProperty('iconColor', iconColor));
  }
}
