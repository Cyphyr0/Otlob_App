import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otlob_app/core/theme/app_theme.dart';
import 'package:otlob_app/features/auth/presentation/screens/login_screen.dart';
import 'package:otlob_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:otlob_app/features/auth/presentation/widgets/why_otlob_section.dart';

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2B3A67), Color(0xFF1E2A44)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    SizedBox(height: 50.h),
                    Text(
                      _currentIndex == 0 ? 'Welcome back!' : 'Join Otlob!',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'TutanoCCV2',
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      _currentIndex == 0
                          ? 'Please enter your phone number to login'
                          : 'Enter your details to get started',
                      style: TextStyle(fontSize: 16.sp, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40.h),
                    TabBar(
                      controller: _tabController,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      indicatorColor: AppTheme.secondaryColor,
                      labelStyle: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedLabelStyle: TextStyle(fontSize: 16.sp),
                      indicatorWeight: 3.h,
                      tabs: const [
                        Tab(text: 'Login'),
                        Tab(text: 'Sign Up'),
                      ],
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [LoginScreen(), SignupScreen()],
                ),
              ),
              const WhyOtlobSection(),
            ],
          ),
        ),
      ),
    );
  }
}
