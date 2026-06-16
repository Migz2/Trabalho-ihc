/// Onboarding completion status entity
class OnboardingEntity {
  final bool isCompleted;
  final DateTime? completedAt;

  OnboardingEntity({
    this.isCompleted = false,
    this.completedAt,
  });

  OnboardingEntity copyWith({
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return OnboardingEntity(
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
