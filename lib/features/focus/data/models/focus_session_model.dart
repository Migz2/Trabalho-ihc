import 'package:hive/hive.dart';
import '../../domain/entities/focus_session_entity.dart';

part 'focus_session_model.g.dart';

/// Hive model for completed focus sessions
@HiveType(typeId: 2)
class FocusSessionModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  int durationMinutes;

  @HiveField(2)
  DateTime completedAt;

  @HiveField(3)
  int cyclesCompleted;

  @HiveField(4)
  int coinsEarned;

  @HiveField(5)
  bool wasInterrupted;

  FocusSessionModel({
    required this.id,
    required this.durationMinutes,
    required this.completedAt,
    required this.cyclesCompleted,
    required this.coinsEarned,
    required this.wasInterrupted,
  });

  /// Convert to entity
  FocusSessionEntity toEntity() {
    return FocusSessionEntity(
      id: id,
      durationMinutes: durationMinutes,
      completedAt: completedAt,
      cyclesCompleted: cyclesCompleted,
      coinsEarned: coinsEarned,
      wasInterrupted: wasInterrupted,
    );
  }

  /// Create from entity
  factory FocusSessionModel.fromEntity(FocusSessionEntity entity) {
    return FocusSessionModel(
      id: entity.id,
      durationMinutes: entity.durationMinutes,
      completedAt: entity.completedAt,
      cyclesCompleted: entity.cyclesCompleted,
      coinsEarned: entity.coinsEarned,
      wasInterrupted: entity.wasInterrupted,
    );
  }

  /// Create copy with modifications
  FocusSessionModel copyWith({
    String? id,
    int? durationMinutes,
    DateTime? completedAt,
    int? cyclesCompleted,
    int? coinsEarned,
    bool? wasInterrupted,
  }) {
    return FocusSessionModel(
      id: id ?? this.id,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      completedAt: completedAt ?? this.completedAt,
      cyclesCompleted: cyclesCompleted ?? this.cyclesCompleted,
      coinsEarned: coinsEarned ?? this.coinsEarned,
      wasInterrupted: wasInterrupted ?? this.wasInterrupted,
    );
  }
}
