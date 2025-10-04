import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otlob_app/core/providers.dart';
import 'package:otlob_app/core/theme/app_theme.dart';
import 'package:otlob_app/core/utils/shared_prefs_helper.dart';
import 'package:otlob_app/features/auth/presentation/screens/auth_wrapper.dart';
import 'package:otlob_app/features/auth/presentation/screens/phone_verification_screen.dart';
import 'package:otlob_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:otlob_app/features/cart/presentation/screens/order_confirmation_screen.dart';
import 'package:otlob_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:otlob_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:otlob_app/features/home/presentation/screens/home_screen.dart';
import 'package:otlob_app/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:otlob_app/features/home/presentation/screens/restaurant_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = GoRouter(
      initialLocation: '/splash',
      redirect: (context, state) async {
        final isAuthenticated = await SharedPrefsHelper.isAuthenticated();
        final isOnboardingCompleted =
            await SharedPrefsHelper.isOnboardingCompleted();

        final location = state.matchedLocation;

        if (location == '/splash') {
          // From splash, check onboarding
          if (isOnboardingCompleted) {
            return isAuthenticated ? '/home' : '/auth';
          } else {
            return '/onboarding';
          }
        }

        if (!isAuthenticated &&
            (location.startsWith('/home') ||
                location == '/cart' ||
                location == '/profile' ||
                location == '/favorites' ||
                location.startsWith('/restaurant'))) {
          return '/auth';
        }

        if (isAuthenticated && location == '/auth') {
          return '/home';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/auth',
          builder: (context, state) => const AuthWrapper(),
        ),
        GoRoute(
          path: '/phone-verification',
          builder: (context, state) {
            final phoneNumber = state.extra as String;
            return PhoneVerificationScreen(phoneNumber: phoneNumber);
          },
        ),
        GoRoute(
          path: '/address',
          builder: (context, state) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on, size: 100, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'Address Setup Screen',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'This screen will be implemented later.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/home');
                    },
                    child: const Text('Go to Home (Stub)'),
                  ),
                ],
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/restaurant/:id',
          builder: (context, state) =>
              RestaurantDetailScreen(id: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/order-confirmation',
          builder: (context, state) => const OrderConfirmationScreen(),
        ),
        GoRoute(
          path: '/category',
          builder: (context, state) => Scaffold(
            appBar: AppBar(title: const Text('Category')),
            body: const Center(child: Text('Category Screen Stub')),
          ),
        ),
        GoRoute(
          path: '/tracking',
          builder: (context, state) => Scaffold(
            appBar: AppBar(title: const Text('Order Tracking')),
            body: const Center(child: Text('Tracking Screen Stub')),
          ),
        ),
        ShellRoute(
          builder: (context, state, child) {
            return ScaffoldWithNavBar(child: child);
          },
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: '/favorites',
              builder: (context, state) => const FavoritesScreen(),
            ),
            GoRoute(
              path: '/cart',
              builder: (context, state) => const CartScreen(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    );

    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X size as base
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Otlob App',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          routerConfig: router,
        );
      },
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Profile Screen - Coming Soon')),
    );
  }
}

class ScaffoldWithNavBar extends ConsumerWidget {
  const ScaffoldWithNavBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationIndexProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        // If on home, exit app. Otherwise, go to home
        if (selectedIndex == 0) {
          // Let system handle exit
          return;
        } else {
          ref.read(navigationIndexProvider.notifier).state = 0;
          context.go('/home');
        }
      },
      child: Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) {
          ref.read(navigationIndexProvider.notifier).state = index;
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/favorites');
              break;
            case 2:
              context.go('/cart');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
      ),
      ),
    );
  }
}
