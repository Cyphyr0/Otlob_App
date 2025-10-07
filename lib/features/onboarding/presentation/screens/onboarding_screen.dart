import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:go_router/go_router.dart";
import "package:shadcn_ui/shadcn_ui.dart";

import "../../../../core/utils/shared_prefs_helper.dart";
import "../widgets/onboarding_page.dart";

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
      "title": "Discover Amazing Food",
      "subtitle": "Explore restaurants and cuisines from local heroes",
    },
    {
      "title": "Lightning Fast Delivery",
      "subtitle": "Get your order in 30 mins or less with real-time tracking",
    },
    {
      "title": "Safe & Secure",
      "subtitle": "Contactless delivery and secure payment options",
    },
    {
      "title": "Exclusive Offers",
      "subtitle": "Daily deals, discounts, and loyalty rewards await",
    },
  ];

  Widget _buildImageWidget(int index) {
    // Use contextual icons instead of Lottie animations
    return Container(
      padding: EdgeInsets.all(40.w),
      decoration: BoxDecoration(
        color: _getBackgroundColor(index),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Icon(_getIconForPage(index), size: 140.sp, color: Colors.white),
    );
  }

  IconData _getIconForPage(int index) {
    switch (index) {
      case 0: // Food Discovery
        return Icons.restaurant_menu;
      case 1: // Fast Delivery
        return Icons.electric_bolt;
      case 2: // Security
        return Icons.verified_user;
      case 3: // Offers
        return Icons.local_offer;
      default:
        return Icons.restaurant;
    }
  }

  Color _getBackgroundColor(int index) {
    switch (index) {
      case 0: // Food Discovery - Orange
        return Colors.orange.withValues(alpha: 0.3);
      case 1: // Fast Delivery - Blue
        return Colors.blue.withValues(alpha: 0.3);
      case 2: // Security - Green
        return Colors.green.withValues(alpha: 0.3);
      case 3: // Offers - Purple
        return Colors.purple.withValues(alpha: 0.3);
      default:
        return Colors.red.withValues(alpha: 0.3);
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
    var theme = Theme.of(context);

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
            itemBuilder: (context, index) => OnboardingPage(
                title: _pages[index]['title']!,
                subtitle: _pages[index]['subtitle']!,
                imageWidget: _buildImageWidget(index),
              ),
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
                            ? theme.colorScheme.secondary
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ShadButton.outline(
                          child: Text(
                            "Skip",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                          onPressed: _navigateToAuth,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ShadButton(
                          onPressed: _currentPage == _pages.length - 1
                              ? _navigateToAuth
                              : () => _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                ),
                          child: Text(
                            _currentPage == _pages.length - 1
                                ? "Start"
                                : "Next",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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

  Future<void> _navigateToAuth() async {
    await SharedPrefsHelper.setOnboardingCompleted(true);
    if (mounted) {
      context.go("/auth");
    }
  }
}
