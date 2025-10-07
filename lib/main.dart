import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:otlob_app/core/providers.dart';
import 'package:otlob_app/core/services/service_locator.dart';
import 'package:otlob_app/core/services/firebase/firebase_data_seeder.dart';
import 'package:otlob_app/core/theme/shadcn_theme.dart';
import 'package:otlob_app/core/widgets/demo/component_showcase.dart';
import 'package:otlob_app/features/auth/presentation/screens/auth_wrapper.dart';
import 'package:otlob_app/features/auth/presentation/screens/phone_verification_screen.dart';
import 'package:otlob_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:otlob_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:otlob_app/features/cart/presentation/screens/order_confirmation_screen.dart';
import 'package:otlob_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:otlob_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:otlob_app/features/home/presentation/screens/home_screen.dart';
import 'package:otlob_app/core/widgets/buttons/floating_cart_button.dart';
import 'package:otlob_app/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:otlob_app/features/home/presentation/screens/restaurant_detail_screen.dart';
import 'package:otlob_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:otlob_app/firebase_options.dart';
/*  import removed for public commit */

void main() async {
  try {
    print('Main: Starting app initialization');

    WidgetsFlutterBinding.ensureInitialized();
    print('Main: WidgetsFlutterBinding initialized');

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Main: Firebase initialized');

    // Initialize service locator with Firebase services
    setupFirebaseServices();
    print('Main: Service locator initialized');

    // Seed data in debug mode
    if (const bool.fromEnvironment('dart.vm.product') == false) {
      try {
        print('Main: Starting data seeding...');
        final seeder = getIt<FirebaseDataSeeder>();
        await seeder.seedSampleData();
        print('Main: Data seeding completed successfully');
      } catch (e) {
        print('Main: Error seeding data: $e');
        // Continue app initialization even if seeding fails
      }
    }

    print('Main: About to call runApp');
    runApp(const ProviderScope(child: MyApp()));
    print('Main: runApp called');
  } catch (e, stackTrace) {
    print('Main: CRITICAL ERROR during initialization: $e');
    print('Main: Stack trace: $stackTrace');

    // Fallback to simple app if complex app fails
    runApp(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('ERROR')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('CRITICAL ERROR: $e', style: TextStyle(color: Colors.red)),
                SizedBox(height: 20),
                Text('Check console for details'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('MyApp: Building MyApp widget');

    final GoRouter router = GoRouter(
      initialLocation: '/splash',
      debugLogDiagnostics: true, // Enable router logging
      redirect: (context, state) {
        final location = state.matchedLocation;
        print('Router: Current location: $location');

        // Don't redirect from splash - let the splash screen handle navigation
        if (location == '/splash') {
          return null;
        }

        // For debugging, always allow navigation to onboarding
        if (location == '/onboarding') {
          return null;
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
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
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
        GoRoute(
          path: '/demo',
          builder: (context, state) => const ComponentShowcaseScreen(),
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
        return ShadTheme(
          data: ShadThemeData(
            brightness: Brightness.light,
            colorScheme: ShadColorScheme(
              background: Colors.white,
              foreground: Colors.black,
              card: Colors.white,
              cardForeground: Colors.black,
              popover: Colors.white,
              popoverForeground: Colors.black,
              primary: const Color(0xFFDC2626),
              primaryForeground: Colors.white,
              secondary: const Color(0xFFF59E0B),
              secondaryForeground: Colors.black,
              destructive: Colors.red,
              destructiveForeground: Colors.white,
              muted: const Color(0xFFF3F4F6),
              mutedForeground: const Color(0xFF6B7280),
              accent: const Color(0xFFF3F4F6),
              accentForeground: const Color(0xFF374151),
              border: const Color(0xFFE5E7EB),
              input: const Color(0xFFE5E7EB),
              ring: const Color(0xFFDC2626),
              selection: const Color(0xFFDC2626),
            ),
          ),
          child: MaterialApp.router(
            title: 'Otlob App',
            theme: ShadcnTheme.shadcnTheme,
            routerConfig: router,
          ),
        );
      },
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
        body: Stack(
          children: [
            // Main content
            child,
            // Floating cart button (only shows when cart has items)
            Builder(
              builder: (context) {
                final currentRoute = GoRouterState.of(context).uri.toString();
                return FloatingCartButton(currentRoute: currentRoute);
              },
            ),
          ],
        ),
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
