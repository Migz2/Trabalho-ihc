/// Focus session completed by user
class FocusSessionEntity {
  final String id;
  final int durationMinutes;
  final DateTime completedAt;
  final int cyclesCompleted;
  final int coinsEarned;
  final bool wasInterrupted;

  FocusSessionEntity({
    required this.id,
    required this.durationMinutes,
    required this.completedAt,
    required this.cyclesCompleted,
    required this.coinsEarned,
    required this.wasInterrupted,
  });

  FocusSessionEntity copyWith({
    String? id,
    int? durationMinutes,
    DateTime? completedAt,
    int? cyclesCompleted,
    int? coinsEarned,
    bool? wasInterrupted,
  }) {
    return FocusSessionEntity(
      id: id ?? this.id,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      completedAt: completedAt ?? this.completedAt,
      cyclesCompleted: cyclesCompleted ?? this.cyclesCompleted,
      coinsEarned: coinsEarned ?? this.coinsEarned,
      wasInterrupted: wasInterrupted ?? this.wasInterrupted,
    );
  }
}
