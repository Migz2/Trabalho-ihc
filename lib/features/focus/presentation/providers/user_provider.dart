import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../data/models/user_model.dart';
import '../../../../core/services/hive_service.dart';

/// Provider for user data
final userProvider = AsyncNotifierProvider<UserNotifier, UserEntity>(() {
  return UserNotifier();
});

/// Notifier for user state management
class UserNotifier extends AsyncNotifier<UserEntity> {
  @override
  Future<UserEntity> build() async {
    try {
      final user = await HiveService.getUserOrCreate();
      return user.toEntity();
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }

  /// Add coins to user
  Future<void> addCoins(int amount) async {
    final currentUser = state.maybeWhen(
      data: (user) => user,
      orElse: () => null,
    );

    if (currentUser == null) return;

    final updatedUser = currentUser.copyWith(
      coins: currentUser.coins + amount,
      lastActiveDate: DateTime.now(),
    );

    // Update local state
    state = AsyncValue.data(updatedUser);

    // Persist to Hive
    try {
      final model = UserModel.fromEntity(updatedUser);
      await HiveService.saveUser(model);
    } catch (e) {
      print('Error saving user: $e');
    }
  }

  /// Update user streak
  Future<void> updateStreak(int newStreak) async {
    final currentUser = state.maybeWhen(
      data: (user) => user,
      orElse: () => null,
    );

    if (currentUser == null) return;

    final updatedUser = currentUser.copyWith(
      streak: newStreak,
      lastActiveDate: DateTime.now(),
    );

    state = AsyncValue.data(updatedUser);

    try {
      final model = UserModel.fromEntity(updatedUser);
      await HiveService.saveUser(model);
    } catch (e) {
      print('Error saving user: $e');
    }
  }

  /// Add focus time
  Future<void> addFocusMinutes(int minutes) async {
    final currentUser = state.maybeWhen(
      data: (user) => user,
      orElse: () => null,
    );

    if (currentUser == null) return;

    final updatedUser = currentUser.copyWith(
      totalFocusMinutes: currentUser.totalFocusMinutes + minutes,
      lastActiveDate: DateTime.now(),
    );

    state = AsyncValue.data(updatedUser);

    try {
      final model = UserModel.fromEntity(updatedUser);
      await HiveService.saveUser(model);
    } catch (e) {
      print('Error saving user: $e');
    }
  }

  /// Update level
  Future<void> updateLevel(int newLevel) async {
    final currentUser = state.maybeWhen(
      data: (user) => user,
      orElse: () => null,
    );

    if (currentUser == null) return;

    final updatedUser = currentUser.copyWith(
      level: newLevel,
      lastActiveDate: DateTime.now(),
    );

    state = AsyncValue.data(updatedUser);

    try {
      final model = UserModel.fromEntity(updatedUser);
      await HiveService.saveUser(model);
    } catch (e) {
      print('Error saving user: $e');
    }
  }
}
