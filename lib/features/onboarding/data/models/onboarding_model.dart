import 'package:hive/hive.dart';
import '../../domain/entities/onboarding_entity.dart';

part 'onboarding_model.g.dart';

/// Hive model for onboarding state
@HiveType(typeId: 1)
class OnboardingModel extends HiveObject {
  @HiveField(0)
  bool isCompleted;

  @HiveField(1)
  DateTime? completedAt;

  OnboardingModel({
    this.isCompleted = false,
    this.completedAt,
  });

  /// Convert to entity
  OnboardingEntity toEntity() {
    return OnboardingEntity(
      isCompleted: isCompleted,
      completedAt: completedAt,
    );
  }

  /// Create from entity
  factory OnboardingModel.fromEntity(OnboardingEntity entity) {
    return OnboardingModel(
      isCompleted: entity.isCompleted,
      completedAt: entity.completedAt,
    );
  }

  /// Create copy with modifications
  OnboardingModel copyWith({
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return OnboardingModel(
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
