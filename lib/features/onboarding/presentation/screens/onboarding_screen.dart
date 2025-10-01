import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/shared_prefs_helper.dart';
import '../widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Discover Amazing Food',
      'subtitle': 'Explore restaurants and cuisines from local heroes',
    },
    {
      'title': 'Lightning Fast Delivery',
      'subtitle': 'Get your order in 30 mins or less with real-time tracking',
    },
    {
      'title': 'Safe & Secure',
      'subtitle': 'Contactless delivery and secure payment options',
    },
    {
      'title': 'Exclusive Offers',
      'subtitle': 'Daily deals, discounts, and loyalty rewards await',
    },
  ];

  Widget _buildImageWidget(int index) {
    // Placeholder image as Container with colored box and text
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getIconForPage(index), size: 80.sp, color: Colors.white),
          SizedBox(height: 16.h),
          Text(
            _getImageText(index),
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForPage(int index) {
    switch (index) {
      case 0:
        return Icons.restaurant_menu;
      case 1:
        return Icons.flash_on;
      case 2:
        return Icons.security;
      case 3:
        return Icons.local_offer;
      default:
        return Icons.restaurant;
    }
  }

  String _getImageText(int index) {
    switch (index) {
      case 0:
        return 'Food Discovery';
      case 1:
        return 'Fast Delivery';
      case 2:
        return 'Secure';
      case 3:
        return 'Offers';
      default:
        return '';
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page!.round() != _currentPage) {
        setState(() {
          _currentPage = _pageController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return OnboardingPage(
                title: _pages[index]['title']!,
                subtitle: _pages[index]['subtitle']!,
                imageWidget: _buildImageWidget(index),
              );
            },
          ),
          // Bottom indicators and buttons
          Positioned(
            bottom: 60.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Dots indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      height: 8.h,
                      width: _currentPage == index ? 24.w : 8.w,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppTheme.secondaryColor
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => _navigateToAuth(),
                      child: Text(
                        'Skip',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _currentPage == _pages.length - 1
                          ? _navigateToAuth
                          : () => _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.w,
                          vertical: 12.h,
                        ),
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1 ? 'Start' : 'Next',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAuth() async {
    await SharedPrefsHelper.setOnboardingCompleted(true);
    if (mounted) {
      context.go('/auth');
    }
  }
}
