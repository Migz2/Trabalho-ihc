import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/hive_service.dart';
import '../../features/focus/presentation/pages/focus_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../widgets/home_shell.dart';
import 'app_routes.dart';

// Placeholder pages for remaining tabs
class PetPage extends StatelessWidget {
  const PetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pet')),
      body: const Center(
        child: Text('Página do Pet'),
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico')),
      body: const Center(
        child: Text('Página de Histórico'),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: const Center(
        child: Text('Página de Ajustes'),
      ),
    );
  }
}

/// Configure GoRouter for Honey app
final appRouter = GoRouter(
  initialLocation: AppRoutes.root,
  redirect: (context, state) {
    // Check if onboarding is completed using the helper method
    final onboardingCompleted = HiveService.isOnboardingCompleted();

    // Redirect to onboarding if not completed
    if (!onboardingCompleted && state.uri.path != AppRoutes.onboarding) {
      return AppRoutes.onboarding;
    }

    // Redirect root to focus page
    if (state.uri.path == AppRoutes.root) {
      return onboardingCompleted ? AppRoutes.focus : AppRoutes.onboarding;
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

    // Shell route with bottom navigation
    ShellRoute(
      builder: (context, state, child) => HomeShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.focus,
          name: 'focus',
          builder: (context, state) => const FocusPage(),
        ),
        GoRoute(
          path: AppRoutes.pet,
          name: 'pet',
          builder: (context, state) => const PetPage(),
        ),
        GoRoute(
          path: AppRoutes.history,
          name: 'history',
          builder: (context, state) => const HistoryPage(),
        ),
        GoRoute(
          path: AppRoutes.settings,
          name: 'settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
  ],
);
