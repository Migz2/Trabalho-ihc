import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/hive_service.dart';
import '../../core/constants/hive_keys.dart';
import 'app_routes.dart';

// Import placeholder screens (will be replaced with actual feature screens)
import '../../features/focus/presentation/pages/focus_page.dart';
import '../../features/pet/presentation/pages/pet_page.dart';
import '../../features/statistics/presentation/pages/statistics_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../widgets/home_shell.dart';

/// GoRouter configuration for the Honey App
/// Provides complete navigation structure with bottom navigation shell
final appRouter = GoRouter(
  initialLocation: AppRoutes.focus,
  redirect: (context, state) {
    // Check if onboarding is complete
    try {
      final prefs = HiveService.userPreferences;
      final onboardingComplete =
          prefs.get(HiveKeys.onboardingCompleteKey, defaultValue: false) as bool;

      // If onboarding not complete and not already on onboarding route
      if (!onboardingComplete && state.uri.path != AppRoutes.onboarding) {
        return AppRoutes.onboarding;
      }

      // If onboarding complete and on onboarding route, redirect to home
      if (onboardingComplete && state.uri.path == AppRoutes.onboarding) {
        return AppRoutes.focus;
      }
    } catch (e) {
      print('Error checking onboarding status: $e');
    }

    return null;
  },
  routes: [
    // Onboarding route
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),

    // Shell route for main navigation with bottom nav
    ShellRoute(
      builder: (context, state, child) => HomeShell(child: child),
      routes: [
        // Focus tab
        GoRoute(
          path: AppRoutes.focus,
          name: 'focus',
          builder: (context, state) => const FocusPage(),
        ),

        // Pet tab
        GoRoute(
          path: AppRoutes.pet,
          name: 'pet',
          builder: (context, state) => const PetPage(),
        ),

        // Statistics/History tab
        GoRoute(
          path: AppRoutes.history,
          name: 'history',
          builder: (context, state) => const StatisticsPage(),
        ),

        // Settings tab
        GoRoute(
          path: AppRoutes.settings,
          name: 'settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
  ],

  // Error page
  errorBuilder: (context, state) => ErrorPage(error: state.error),
);

/// Error page for invalid routes
class ErrorPage extends StatelessWidget {
  final Exception? error;

  const ErrorPage({Key? key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            const Text('Page not found'),
            if (error != null) ...[
              const SizedBox(height: 16),
              Text(error.toString()),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.focus),
              child: const Text('Go back to home'),
            ),
          ],
        ),
      ),
    );
  }
}
