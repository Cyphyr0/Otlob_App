import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otlob_app/core/theme/app_colors.dart';
import 'package:otlob_app/core/theme/app_typography.dart';
import 'package:otlob_app/core/theme/app_spacing.dart';
import 'package:otlob_app/core/theme/app_radius.dart';
import 'package:otlob_app/core/theme/app_shadows.dart';
import 'package:otlob_app/core/widgets/branding/otlob_logo.dart';
import 'package:otlob_app/core/widgets/buttons/primary_button.dart';
import 'package:otlob_app/core/widgets/buttons/secondary_button.dart';
import 'package:otlob_app/core/widgets/states/empty_state.dart';
import 'package:otlob_app/core/utils/shared_prefs_helper.dart';
import 'package:otlob_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:otlob_app/features/cart/domain/entities/cart_item.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  String? selectedPayment = 'cash';
  final TextEditingController promoController = TextEditingController();

  @override
  void dispose() {
    promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    final body = cartNotifier.isLoading
        ? const Center(child: CircularProgressIndicator())
        : cartState.isEmpty
        ? EmptyState.emptyCart(onAction: () => context.go('/home'))
        : ListView.builder(
            padding: EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: cartState.length,
            itemBuilder: (context, index) {
              final item = cartState[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < cartState.length - 1 ? AppSpacing.md : 0,
                ),
                child: _buildCartItem(item, cartNotifier),
              );
            },
          );

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: _buildAppBar(),
      body: body,
      // Move bottom section into bottomNavigationBar so Scaffold reserves
      // layout space and it won't overlap the list content.
      bottomNavigationBar: _buildBottomSection(cartNotifier),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.offWhite,
      elevation: 0,
      title: Row(
        children: [
          const OtlobLogo(size: LogoSize.small),
          SizedBox(width: AppSpacing.md),
          Text(
            'Your Cart',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.primaryBlack,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item, dynamic cartNotifier) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.cardRadius,
        boxShadow: AppShadows.card,
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // Item Image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Container(
                width: 80.w,
                height: 80.h,
                color: AppColors.lightGray,
                child: item.imageUrl.isNotEmpty
                    ? Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.restaurant_menu,
                          size: 32.sp,
                          color: AppColors.gray,
                        ),
                      )
                    : Icon(
                        Icons.restaurant_menu,
                        size: 32.sp,
                        color: AppColors.gray,
                      ),
              ),
            ),
            SizedBox(width: AppSpacing.md),

            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.logoRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Quantity Controls
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => cartNotifier.updateQuantity(
                          item.id,
                          item.quantity - 1,
                        ),
                        icon: const Icon(Icons.remove),
                        iconSize: 18.sp,
                        padding: EdgeInsets.all(AppSpacing.xs),
                        constraints: const BoxConstraints(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                        ),
                        child: Text(
                          '${item.quantity}',
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => cartNotifier.updateQuantity(
                          item.id,
                          item.quantity + 1,
                        ),
                        icon: const Icon(Icons.add),
                        iconSize: 18.sp,
                        padding: EdgeInsets.all(AppSpacing.xs),
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                GestureDetector(
                  onTap: () => cartNotifier.removeItem(item.id),
                  child: Container(
                    padding: EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.error.withAlpha(26),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      size: 18.sp,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection(dynamic cartNotifier) {
    // Ensure the bottom section is above any persistent bottom navigation
    // and reacts to the keyboard by adding viewInsets and a scrollable
    // wrapper for its content.
    final bottomNavHeight = kBottomNavigationBarHeight;
    final systemBottomPadding = MediaQuery.of(context).padding.bottom;
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      // keep symmetric horizontal padding, but increase bottom padding to
      // account for the app bottom navigation + system inset.
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg + bottomNavHeight + systemBottomPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: AppShadows.lg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xl),
          topRight: Radius.circular(AppRadius.xl),
        ),
      ),
      child: SafeArea(
        // Add a scroll view so the content can shrink when the keyboard
        // opens (promo input) and avoid overflow on small viewports.
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.only(bottom: keyboardInset),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Order Summary
              _buildSummaryRow('Subtotal', cartNotifier.subtotal),
              SizedBox(height: AppSpacing.sm),
              _buildSummaryRow('Delivery Fee', cartNotifier.deliveryFee),

              if (cartNotifier.hasValidPromo) ...[
                SizedBox(height: AppSpacing.sm),
                _buildDiscountRow(cartNotifier.discount),
              ],

              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Divider(color: AppColors.lightGray, thickness: 1),
              ),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: AppTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '\$${cartNotifier.total.toStringAsFixed(2)}',
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.logoRed,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.lg),

              // Promo Code
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: promoController,
                      decoration: InputDecoration(
                        labelText: 'Promo Code',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide: BorderSide(color: AppColors.lightGray),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide: BorderSide(color: AppColors.lightGray),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide: BorderSide(color: AppColors.logoRed),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  SizedBox(
                    height: 56.h,
                    child: PrimaryButton(
                      text: 'Apply',
                      backgroundColor: AppColors.primaryGold,
                      onPressed: () {
                        final code = promoController.text.trim();
                        if (code.isNotEmpty) {
                          cartNotifier.applyPromo(code);
                          if (cartNotifier.promoError != null) {
                            _showSnackBar(
                              cartNotifier.promoError!,
                              isError: true,
                            );
                          } else {
                            _showSnackBar('Promo applied!', isSuccess: true);
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),

              if (cartNotifier.hasValidPromo) ...[
                SizedBox(height: AppSpacing.sm),
                Container(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGold.withAlpha(26),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.primaryGold,
                        size: 16.sp,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        '10% discount applied!',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.primaryBlack,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: AppSpacing.lg),

              // Payment Method
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.offWhite,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Method',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () => setState(() => selectedPayment = 'cash'),
                          child: Row(
                            children: [
                              Icon(
                                selectedPayment == 'cash'
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: selectedPayment == 'cash'
                                    ? AppColors.logoRed
                                    : AppColors.gray,
                                size: 20.sp,
                              ),
                              SizedBox(width: AppSpacing.sm),
                              Text(
                                'Cash on Delivery',
                                style: AppTypography.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => setState(() => selectedPayment = 'card'),
                          child: Row(
                            children: [
                              Icon(
                                selectedPayment == 'card'
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: selectedPayment == 'card'
                                    ? AppColors.logoRed
                                    : AppColors.gray,
                                size: 20.sp,
                              ),
                              SizedBox(width: AppSpacing.sm),
                              Text('Card', style: AppTypography.bodyMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpacing.lg),

              // Checkout Button
              PrimaryButton(
                text: 'Checkout',
                fullWidth: true,
                onPressed: () async {
                  final isAuthenticated =
                      await SharedPrefsHelper.isAuthenticated();
                  if (!mounted) return;
                  if (!isAuthenticated) {
                    _showSignInDialog();
                    return;
                  }
                  context.go('/order-confirmation');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyLarge.copyWith(color: AppColors.gray),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildDiscountRow(double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Discount',
          style: AppTypography.bodyLarge.copyWith(color: AppColors.primaryGold),
        ),
        Text(
          '- \$${amount.toStringAsFixed(2)}',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.primaryGold,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showSnackBar(
    String message, {
    bool isError = false,
    bool isSuccess = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? AppColors.error
            : isSuccess
            ? AppColors.primaryGold
            : AppColors.primaryBlack,
      ),
    );
  }

  void _showSignInDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          'Sign In Required',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Please sign in to place your order and complete checkout.',
          style: AppTypography.bodyLarge,
        ),
        actions: [
          SecondaryButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context),
          ),
          PrimaryButton(
            text: 'Sign In',
            onPressed: () {
              Navigator.pop(context);
              context.go('/auth');
            },
          ),
        ],
      ),
    );
  }
}
