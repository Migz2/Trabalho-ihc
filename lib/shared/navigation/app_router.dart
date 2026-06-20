import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/hive_service.dart';
import '../../core/utils/animation_constants.dart';
import '../../features/focus/presentation/pages/focus_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/pet/presentation/pages/pet_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/shop/presentation/pages/shop_page.dart';
import '../../features/statistics/presentation/pages/statistics_page.dart';
import '../widgets/home_shell.dart';
import 'app_routes.dart';

/// Wraps a page with the app's standard fade + slide transition.
CustomTransitionPage<void> _buildPageWithTransition({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: AnimationDurations.normal,
    reverseTransitionDuration: AnimationDurations.normal,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: AnimationCurves.enter,
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.02, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: AnimationCurves.enter,
          )),
          child: child,
        ),
      );
    },
  );
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
      pageBuilder: (context, state) => _buildPageWithTransition(
        child: const OnboardingPage(),
        state: state,
      ),
    ),

    // Shell route with bottom navigation
    ShellRoute(
      builder: (context, state, child) => HomeShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.focus,
          name: 'focus',
          pageBuilder: (context, state) => _buildPageWithTransition(
            child: const FocusPage(),
            state: state,
          ),
        ),
        GoRoute(
          path: AppRoutes.pet,
          name: 'pet',
          pageBuilder: (context, state) => _buildPageWithTransition(
            child: const PetPage(),
            state: state,
          ),
        ),
        GoRoute(
          path: AppRoutes.shop,
          name: 'shop',
          pageBuilder: (context, state) => _buildPageWithTransition(
            child: const ShopPage(),
            state: state,
          ),
        ),
        GoRoute(
          path: AppRoutes.history,
          name: 'history',
          pageBuilder: (context, state) => _buildPageWithTransition(
            child: const StatisticsPage(),
            state: state,
          ),
        ),
        GoRoute(
          path: AppRoutes.settings,
          name: 'settings',
          pageBuilder: (context, state) => _buildPageWithTransition(
            child: const SettingsPage(),
            state: state,
          ),
        ),
      ],
    ),
  ],
);
