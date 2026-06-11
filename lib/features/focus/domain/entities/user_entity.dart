/// User profile and stats
class UserEntity {
  final String id;
  final String name;
  final int level;
  final int coins;
  final int streak;
  final int totalFocusMinutes;
  final DateTime createdAt;
  final DateTime lastActiveDate;

  UserEntity({
    required this.id,
    required this.name,
    required this.level,
    required this.coins,
    required this.streak,
    required this.totalFocusMinutes,
    required this.createdAt,
    required this.lastActiveDate,
  });

  /// Check if user is active today
  bool get isActiveTodayOrYesterday {
    final now = DateTime.now();
    final lastActive = lastActiveDate;
    final daysDiff = now.difference(lastActive).inDays;
    return daysDiff <= 1;
  }

  UserEntity copyWith({
    String? id,
    String? name,
    int? level,
    int? coins,
    int? streak,
    int? totalFocusMinutes,
    DateTime? createdAt,
    DateTime? lastActiveDate,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      coins: coins ?? this.coins,
      streak: streak ?? this.streak,
      totalFocusMinutes: totalFocusMinutes ?? this.totalFocusMinutes,
      createdAt: createdAt ?? this.createdAt,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }
}
