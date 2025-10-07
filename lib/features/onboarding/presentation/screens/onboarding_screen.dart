import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/shared_prefs_helper.dart';
import '../widgets/auth_options_screen.dart';
import '../widgets/cuisine_preference_screen.dart';
import '../widgets/location_permission_screen.dart';
import '../widgets/tawseya_intro_screen.dart';
import '../widgets/welcome_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

enum OnboardingStep {
  welcome,
  location,
  cuisine,
  auth,
  tawseya,
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
     with TickerProviderStateMixin {
   final PageController _pageController = PageController();
   OnboardingStep _currentStep = OnboardingStep.welcome;
   int _currentPage = 0;

  // User preferences collected during onboarding
  String? _selectedLocation;
  List<String> _selectedCuisines = [];
  String? _authMethod;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;

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
  Widget build(BuildContext context) => Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        children: [
          WelcomeScreen(onNext: _nextStep),
          LocationPermissionScreen(
            onNext: _nextStep,
            onLocationSelected: (location) {
              _selectedLocation = location;
            },
          ),
          CuisinePreferenceScreen(
            onNext: _nextStep,
            onCuisinesSelected: (cuisines) {
              _selectedCuisines = cuisines;
            },
          ),
          AuthOptionsScreen(
            onNext: _nextStep,
            onAuthMethodSelected: (method) {
              _authMethod = method;
            },
          ),
          TawseyaIntroScreen(
            onNext: _completeOnboarding,
            onTawseyaEnabled: (enabled) {
              // Handle tawseya preference
            },
          ),
        ],
      ),
    );

  void _nextStep() {
    if (_currentStep == OnboardingStep.tawseya) {
      _completeOnboarding();
    } else {
      setState(() {
        _currentStep = OnboardingStep.values[_currentStep.index + 1];
      });
    }
  }

  Future<void> _completeOnboarding() async {
    // Save onboarding completion status
    await SharedPrefsHelper.setOnboardingCompleted(true);

    // TODO: Save user preferences for personalization in a future update
    // For now, just navigate to home screen

    if (mounted) {
      context.go('/home');
    }
  }

  Future<void> _navigateToAuth() async {
    await SharedPrefsHelper.setOnboardingCompleted(true);
    if (mounted) {
      context.go('/auth');
    }
  }
}
