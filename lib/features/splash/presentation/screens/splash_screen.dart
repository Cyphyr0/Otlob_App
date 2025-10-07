import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/theme/app_typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkNavigation();
  }

  Future<void> _checkNavigation() async {
    print('SplashScreen: Starting navigation check');

    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 2));

    print('SplashScreen: Navigation delay completed, navigating to onboarding');

    if (mounted) {
      // For debugging, always go to onboarding first
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('SplashScreen: Building splash screen widget');
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: theme.colorScheme.primary),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Otlob logo
              Lottie.asset(
                'assets/animations/Otlob-white.json',
                width: 280.w,
                height: 280.h,
                fit: BoxFit.contain,
                repeat: true,
                animate: true,
              ),
              SizedBox(height: 24.h),
              Text(
                'Discover Authentic Food',
                style: AppTypography.bodyLarge.copyWith(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 48.h),
              // Loading indicator
              SizedBox(
                width: 40.w,
                height: 40.h,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.onPrimary,
                  ),
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
