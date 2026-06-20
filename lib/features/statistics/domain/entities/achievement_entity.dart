enum AchievementId {
  firstSession,
  firstWeek,
  tenHours,
  hundredPomodoros,
  streakThree,
  streakSeven,
  streakThirty,
  nightOwl,
  earlyBird,
  centurion,
  petLevel5,
}

class AchievementEntity {
  final AchievementId id;
  final String title;
  final String description;
  final String emoji;
  final int coinReward;
  final bool unlocked;
  final DateTime? unlockedAt;

  const AchievementEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.coinReward,
    required this.unlocked,
    this.unlockedAt,
  });

  AchievementEntity copyWith({
    AchievementId? id,
    String? title,
    String? description,
    String? emoji,
    int? coinReward,
    bool? unlocked,
    DateTime? unlockedAt,
  }) {
    return AchievementEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      coinReward: coinReward ?? this.coinReward,
      unlocked: unlocked ?? this.unlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}
