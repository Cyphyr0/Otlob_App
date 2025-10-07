import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_shadows.dart';
import '../../../features/cart/presentation/providers/cart_provider.dart';

/// Floating Cart Button
///
/// A hovering button that appears above the bottom navigation bar
/// when items are in the cart. Shows cart count and total price.
///
/// Features:
/// - Only visible when cart has items
/// - Animated entrance/exit
/// - Shows item count and total price
/// - Positioned above bottom nav bar
/// - Tappable to navigate to cart

class FloatingCartButton extends ConsumerWidget {
  final String? currentRoute;
  const FloatingCartButton({super.key, this.currentRoute});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    // Hide on cart screen
    if (currentRoute == '/cart' ||
        cartState.isEmpty ||
        cartNotifier.isLoading) {
      return const SizedBox.shrink();
    }

    final totalItems = cartState.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );
    // total intentionally not shown in minimized mode

    // Minimized style: smaller, round, only icon and badge, shows on all screens except cart
    // Minimized bottom-right circular FAB
    return Positioned(
      right: 16.w,
      bottom: kBottomNavigationBarHeight + 16.h,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: cartState.isEmpty ? 0.0 : 1.0,
        child: GestureDetector(
          onTap: () => context.go('/cart'),
          child: Material(
            elevation: 8,
            shape: const CircleBorder(),
            shadowColor: AppColors.logoRed.withAlpha(77),
            child: Container(
              width: 56.w,
              height: 56.h,
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.logoRed,
                shape: BoxShape.circle,
                boxShadow: AppShadows.sm,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Icon(Icons.shopping_cart, color: Colors.white, size: 20.sp),
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16.w,
                        minHeight: 16.h,
                      ),
                      child: Text(
                        '$totalItems',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.logoRed,
                          fontWeight: FontWeight.w800,
                          fontSize: 9.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
