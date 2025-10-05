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
import 'package:otlob_app/core/utils/shared_prefs_helper.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final isAuth = await SharedPrefsHelper.isAuthenticated();
    if (mounted) {
      setState(() => _isAuthenticated = isAuth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: _buildAppBar(),
      body: _isAuthenticated ? _buildAuthenticatedView() : _buildGuestView(),
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
            'Profile',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.primaryBlack,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.r,
              height: 120.r,
              decoration: BoxDecoration(
                color: AppColors.logoRed.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_outline,
                size: 60.sp,
                color: AppColors.logoRed,
              ),
            ),
            SizedBox(height: AppSpacing.xl),
            Text(
              'Sign in to access your profile',
              style: AppTypography.headlineMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Save your favorites, view order history, and manage your account',
              style: AppTypography.bodyLarge.copyWith(color: AppColors.gray),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              text: 'Sign In',
              fullWidth: true,
              onPressed: () => context.go('/auth'),
            ),
            SizedBox(height: AppSpacing.md),
            SecondaryButton(
              text: 'Continue as Guest',
              fullWidth: true,
              onPressed: () => context.go('/home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthenticatedView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        children: [
          // Profile Header
          Container(
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: AppRadius.cardRadius,
              boxShadow: AppShadows.card,
            ),
            child: Row(
              children: [
                Container(
                  width: 80.r,
                  height: 80.r,
                  decoration: BoxDecoration(
                    color: AppColors.logoRed.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 40.sp,
                    color: AppColors.logoRed,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Guest User',
                        style: AppTypography.titleLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        'guest@otlob.app',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: AppColors.logoRed),
                  onPressed: () {
                    // TODO: Edit profile
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: AppSpacing.lg),

          // Menu Items
          _buildMenuItem(
            icon: Icons.receipt_long_outlined,
            title: 'Order History',
            onTap: () {
              // TODO: Navigate to order history
            },
          ),
          SizedBox(height: AppSpacing.sm),
          _buildMenuItem(
            icon: Icons.location_on_outlined,
            title: 'Saved Addresses',
            onTap: () {
              // TODO: Navigate to addresses
            },
          ),
          SizedBox(height: AppSpacing.sm),
          _buildMenuItem(
            icon: Icons.payment_outlined,
            title: 'Payment Methods',
            onTap: () {
              // TODO: Navigate to payment methods
            },
          ),
          SizedBox(height: AppSpacing.sm),
          _buildMenuItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: () {
              // TODO: Navigate to notifications
            },
          ),
          SizedBox(height: AppSpacing.sm),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              // TODO: Navigate to help
            },
          ),
          SizedBox(height: AppSpacing.sm),
          _buildMenuItem(
            icon: Icons.info_outline,
            title: 'About',
            onTap: () {
              // TODO: Navigate to about
            },
          ),

          SizedBox(height: AppSpacing.xl),

          // Logout Button
          PrimaryButton(
            text: 'Logout',
            backgroundColor: AppColors.error,
            fullWidth: true,
            onPressed: () async {
              await SharedPrefsHelper.setAuthenticated(false);
              if (mounted) {
                setState(() => _isAuthenticated = false);
              }
            },
          ),

          SizedBox(height: 100.h), // Bottom padding for nav bar
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: AppRadius.cardRadius,
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.logoRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, color: AppColors.logoRed, size: 24.sp),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: AppColors.gray),
          ],
        ),
      ),
    );
  }
}
