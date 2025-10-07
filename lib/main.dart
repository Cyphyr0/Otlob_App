import "package:easy_localization/easy_localization.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:go_router/go_router.dart";
import "package:shadcn_ui/shadcn_ui.dart";

import "core/providers.dart";
import "core/services/firebase/firebase_data_seeder.dart";
import "core/services/service_locator.dart";
import "core/services/firebase/firebase_messaging_service.dart";
import "core/theme/app_typography.dart";
import "core/theme/shadcn_theme.dart";
import "core/utils/localization_helper.dart";
import "core/widgets/buttons/floating_cart_button.dart";
import "core/widgets/demo/component_showcase.dart";
import "features/auth/presentation/screens/auth_wrapper.dart";
import "features/auth/presentation/screens/forgot_password_screen.dart";
import "features/auth/presentation/screens/phone_verification_screen.dart";
import "features/cart/presentation/screens/cart_screen.dart";
import "features/cart/presentation/screens/order_confirmation_screen.dart";
import "features/favorites/presentation/screens/favorites_screen.dart";
import "features/home/presentation/screens/home_screen.dart";
import "features/home/presentation/screens/restaurant_detail_screen.dart";
import "features/onboarding/presentation/screens/onboarding_screen.dart";
import "features/profile/presentation/screens/profile_screen.dart";
import "features/splash/presentation/screens/splash_screen.dart";
import "features/tawseya/presentation/screens/tawseya_screen.dart";
import "features/wallet/presentation/screens/wallet_screen.dart";
import "firebase_options.dart";
/*  import removed for public commit */

void main() async {
  try {
    print("Main: Starting app initialization");

    WidgetsFlutterBinding.ensureInitialized();
    print("Main: WidgetsFlutterBinding initialized");

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Main: Firebase initialized");

    // Initialize Firebase Cloud Messaging
    await FirebaseMessagingService.initialize();
    print("Main: Firebase Messaging initialized");

    // Initialize service locator with Firebase services
    setupFirebaseServices();
    print("Main: Service locator initialized");

    // Seed data in debug mode
    if (const bool.fromEnvironment("dart.vm.product") == false) {
      try {
        print("Main: Starting data seeding...");
        var seeder = getIt<FirebaseDataSeeder>();
        await seeder.seedSampleData();
        print("Main: Data seeding completed successfully");
      } catch (e) {
        print("Main: Error seeding data: $e");
        // Continue app initialization even if seeding fails
      }
    }

    print("Main: About to call runApp");
    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('ar', 'EG')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        startLocale: const Locale(
          'ar',
          'EG',
        ), // Default to Arabic for Egyptian market
        useOnlyLangCode: true,
        child: const ProviderScope(child: MyApp()),
      ),
    );
    print("Main: runApp called with EasyLocalization");
  } catch (e, stackTrace) {
    print("Main: CRITICAL ERROR during initialization: $e");
    print("Main: Stack trace: $stackTrace");

    // Fallback to simple app if complex app fails
    runApp(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text("ERROR")),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "CRITICAL ERROR: $e",
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 20),
                const Text("Check console for details"),
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
    print("MyApp: Building MyApp widget");

    final router = GoRouter(
      initialLocation: "/splash",
      debugLogDiagnostics: true, // Enable router logging
      redirect: (context, state) {
        var location = state.matchedLocation;
        print("Router: Current location: $location");

        // Don't redirect from splash - let the splash screen handle navigation
        if (location == "/splash") {
          return null;
        }

        // For debugging, always allow navigation to onboarding
        if (location == "/onboarding") {
          return null;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: "/splash",
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: "/onboarding",
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: "/auth",
          builder: (context, state) => const AuthWrapper(),
        ),
        GoRoute(
          path: "/forgot-password",
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: "/phone-verification",
          builder: (context, state) {
            var phoneNumber = state.extra as String;
            return PhoneVerificationScreen(phoneNumber: phoneNumber);
          },
        ),
        GoRoute(
          path: "/address",
          builder: (context, state) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, size: 100, color: Colors.grey),
                  const SizedBox(height: 20),
                  const Text(
                    "Address Setup Screen",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "This screen will be implemented later.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.go("/home");
                    },
                    child: const Text("Go to Home (Stub)"),
                  ),
                ],
              ),
            ),
          ),
        ),
        GoRoute(
          path: "/restaurant/:id",
          builder: (context, state) =>
              RestaurantDetailScreen(id: state.pathParameters["id"]!),
        ),
        GoRoute(
          path: "/order-confirmation",
          builder: (context, state) => const OrderConfirmationScreen(),
        ),
        GoRoute(
          path: "/category",
          builder: (context, state) => Scaffold(
            appBar: AppBar(title: const Text("Category")),
            body: const Center(child: Text("Category Screen Stub")),
          ),
        ),
        GoRoute(
          path: "/tracking",
          builder: (context, state) => Scaffold(
            appBar: AppBar(title: const Text("Order Tracking")),
            body: const Center(child: Text("Tracking Screen Stub")),
          ),
        ),
        GoRoute(
          path: "/demo",
          builder: (context, state) => const ComponentShowcaseScreen(),
        ),
        GoRoute(
          path: "/tawseya",
          builder: (context, state) => const TawseyaScreen(),
        ),
        GoRoute(
          path: "/wallet",
          builder: (context, state) => const WalletScreen(),
        ),
        GoRoute(
          path: "/wallet",
          builder: (context, state) => const WalletScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) => ScaffoldWithNavBar(child: child),
          routes: [
            GoRoute(
              path: "/home",
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: "/favorites",
              builder: (context, state) => const FavoritesScreen(),
            ),
            GoRoute(
              path: "/tawseya",
              builder: (context, state) => const TawseyaScreen(),
            ),
            GoRoute(
              path: "/cart",
              builder: (context, state) => const CartScreen(),
            ),
            GoRoute(
              path: "/profile",
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
      builder: (context, child) => ShadTheme(
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
          title: LocalizationHelper.of(context).app_name,
          theme: ShadcnTheme.shadcnTheme.copyWith(
            textTheme: AppTypography.getResponsiveTextTheme(context),
          ),
          routerConfig: router,
          // RTL & Localization Support
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          // RTL Configuration
          builder: (context, child) {
            return Directionality(
              textDirection: Directionality.of(context),
              child: child!,
            );
          },
        ),
      ),
    );
  }
}

class ScaffoldWithNavBar extends ConsumerWidget {
  const ScaffoldWithNavBar({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedIndex = ref.watch(navigationIndexProvider);

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
          context.go("/home");
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
                var currentRoute = GoRouterState.of(context).uri.toString();
                return FloatingCartButton(currentRoute: currentRoute);
              },
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: LocalizationHelper.of(context).nav_home,
            ),
            NavigationDestination(
              icon: const Icon(Icons.favorite_border),
              selectedIcon: const Icon(Icons.favorite),
              label: LocalizationHelper.of(context).nav_favorites,
            ),
            NavigationDestination(
              icon: const Icon(Icons.account_balance_wallet_outlined),
              selectedIcon: const Icon(Icons.account_balance_wallet),
              label: 'Wallet',
            ),
            NavigationDestination(
              icon: const Icon(Icons.how_to_vote_outlined),
              selectedIcon: const Icon(Icons.how_to_vote),
              label: LocalizationHelper.of(context).nav_tawseya,
            ),
            NavigationDestination(
              icon: const Icon(Icons.shopping_cart_outlined),
              selectedIcon: const Icon(Icons.shopping_cart),
              label: LocalizationHelper.of(context).nav_cart,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outlined),
              selectedIcon: const Icon(Icons.person),
              label: LocalizationHelper.of(context).nav_profile,
            ),
          ],
          selectedIndex: selectedIndex,
          onDestinationSelected: (int index) {
            ref.read(navigationIndexProvider.notifier).state = index;
            switch (index) {
              case 0:
                context.go("/home");
                break;
              case 1:
                context.go("/favorites");
                break;
              case 2:
                context.go("/wallet");
                break;
              case 3:
                context.go("/tawseya");
                break;
              case 4:
                context.go("/cart");
                break;
              case 5:
                context.go("/profile");
                break;
            }
          },
        ),
      ),
    );
  }
}
