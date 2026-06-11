import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/onboarding_entity.dart';
import '../../../../core/services/hive_service.dart';

/// Provider for onboarding state
final onboardingProvider = AsyncNotifierProvider<OnboardingNotifier, OnboardingEntity>(() {
  return OnboardingNotifier();
});

/// Notifier for onboarding state
class OnboardingNotifier extends AsyncNotifier<OnboardingEntity> {
  @override
  Future<OnboardingEntity> build() async {
    try {
      final onboarding = HiveService.getOnboarding();
      if (onboarding != null) {
        return onboarding.toEntity();
      } else {
        return OnboardingEntity(isCompleted: false, completedAt: null);
      }
    } catch (e) {
      throw Exception('Failed to load onboarding: $e');
    }
  }

  /// Mark onboarding as completed
  Future<void> markCompleted() async {
    try {
      await HiveService.completeOnboarding();
      state = AsyncValue.data(
        OnboardingEntity(
          isCompleted: true,
          completedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
