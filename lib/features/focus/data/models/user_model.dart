import 'package:hive/hive.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

/// Hive model for user profile
@HiveType(typeId: 4)
class UserModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int level;

  @HiveField(3)
  int coins;

  @HiveField(4)
  int streak;

  @HiveField(5)
  int totalFocusMinutes;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  DateTime lastActiveDate;

  UserModel({
    required this.id,
    required this.name,
    required this.level,
    required this.coins,
    required this.streak,
    required this.totalFocusMinutes,
    required this.createdAt,
    required this.lastActiveDate,
  });

  /// Convert to entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      level: level,
      coins: coins,
      streak: streak,
      totalFocusMinutes: totalFocusMinutes,
      createdAt: createdAt,
      lastActiveDate: lastActiveDate,
    );
  }

  /// Create from entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      level: entity.level,
      coins: entity.coins,
      streak: entity.streak,
      totalFocusMinutes: entity.totalFocusMinutes,
      createdAt: entity.createdAt,
      lastActiveDate: entity.lastActiveDate,
    );
  }

  /// Create default user
  factory UserModel.defaultUser() {
    final now = DateTime.now();
    return UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Marina',
      level: 1,
      coins: 500,
      streak: 0,
      totalFocusMinutes: 0,
      createdAt: now,
      lastActiveDate: now,
    );
  }

  /// Create copy with modifications
  UserModel copyWith({
    String? id,
    String? name,
    int? level,
    int? coins,
    int? streak,
    int? totalFocusMinutes,
    DateTime? createdAt,
    DateTime? lastActiveDate,
  }) {
    return UserModel(
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
