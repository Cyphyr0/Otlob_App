import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/shadcn_theme.dart';
import '../../../../core/utils/shared_prefs_helper.dart';
import 'package:lottie/lottie.dart';

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
    // Simulate loading delay
    await Future.delayed(const Duration(seconds: 2));

    final bool onboardingCompleted =
        await SharedPrefsHelper.isOnboardingCompleted();
    final bool authenticated = await SharedPrefsHelper.isAuthenticated();

    if (mounted) {
      if (!onboardingCompleted) {
        context.go('/onboarding');
      } else if (!authenticated) {
        context.go('/auth');
      } else {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: theme.colorScheme.primary),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 180.h,
                width: 180.h,
                child: Lottie.asset(
                  'assets/animations/Otlob.json',
                  repeat: true,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Discover Authentic Food',
                style: AppTypography.bodyLarge.copyWith(
                  color: theme.colorScheme.onPrimary.withOpacity(0.9),
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 48.h),
              // Loading indicator using Shadcn UI
              const ShadProgress(
                value: null, // Indeterminate progress
              ),
            ],
          ),
        ),
      ),
    );
  }
}
