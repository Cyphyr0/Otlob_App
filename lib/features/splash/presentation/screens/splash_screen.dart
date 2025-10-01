import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/shared_prefs_helper.dart';

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
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo placeholder
            Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: const Icon(
                Icons.restaurant,
                size: 80,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Otlob',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'TutanoCCV2',
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Discover Authentic Food',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            SizedBox(height: 40.h),
            // Loading indicator
            SizedBox(
              width: 24.w,
              height: 24.h,
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
