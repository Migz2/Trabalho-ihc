import 'package:hive_flutter/hive_flutter.dart';
import '../constants/hive_keys.dart';
import '../errors/app_exceptions.dart';

/// Service for managing Hive local storage initialization and access
class HiveService {
  HiveService._();

  static const String _logTag = 'HiveService';

  /// Initialize Hive and create necessary boxes
  /// Call this in main.dart before running the app
  static Future<void> init() async {
    try {
      // Initialize Hive
      await Hive.initFlutter();

      // Open/create boxes with default values
      await _openBox<dynamic>(
        HiveKeys.userPreferencesBox,
        defaultData: {
          HiveKeys.onboardingCompleteKey: false,
          HiveKeys.darkModeKey: false,
          HiveKeys.focusDurationKey: 25,
          HiveKeys.shortBreakDurationKey: 5,
          HiveKeys.longBreakDurationKey: 15,
          HiveKeys.appBlockingIntensityKey: 1, // 0=off, 1=low, 2=medium, 3=high
          HiveKeys.notificationsMutedKey: false,
          HiveKeys.ambientSoundKey: 'chuvaSuave',
        },
      );

      await _openBox<dynamic>(
        HiveKeys.petDataBox,
        defaultData: {
          HiveKeys.petNameKey: 'Mel',
          HiveKeys.petTypeKey: 'dog',
          HiveKeys.petLevelKey: 1,
          HiveKeys.petExperienceKey: 0,
          HiveKeys.petHungerKey: 50,
          HiveKeys.petHygieneKey: 75,
          HiveKeys.petHappinessKey: 80,
        },
      );

      await _openBox<List>(
        HiveKeys.focusSessionsBox,
        defaultData: [],
      );

      await _openBox<dynamic>(
        HiveKeys.shopItemsBox,
        defaultData: {},
      );

      await _openBox<dynamic>(
        HiveKeys.statisticsBox,
        defaultData: {
          HiveKeys.totalSessionsKey: 0,
          HiveKeys.totalFocusTimeKey: 0,
          HiveKeys.currentStreakKey: 0,
          HiveKeys.longestStreakKey: 0,
          HiveKeys.coinsBalanceKey: 248,
        },
      );

      print('[$_logTag] ✓ Hive initialized successfully');
    } catch (e, stackTrace) {
      throw StorageException(
        message: 'Failed to initialize Hive: $e',
        code: 'HIVE_INIT_FAILED',
        stackTrace: stackTrace,
      );
    }
  }

  /// Open a box with optional default data
  static Future<Box<T>> _openBox<T>(
    String boxName, {
    required dynamic defaultData,
  }) async {
    try {
      final box = await Hive.openBox<T>(boxName);

      // Initialize with default data if box is empty
      if (box.isEmpty && defaultData != null) {
        if (defaultData is Map) {
          for (final entry in (defaultData as Map).entries) {
            await box.put(entry.key, entry.value as T);
          }
        } else if (defaultData is List) {
          // For list boxes, we don't add default items
        }
      }

      return box;
    } catch (e, stackTrace) {
      throw StorageException(
        message: 'Failed to open Hive box "$boxName": $e',
        code: 'BOX_OPEN_FAILED',
        stackTrace: stackTrace,
      );
    }
  }

  /// Get user preferences box
  static Box<dynamic> get userPreferences {
    try {
      return Hive.box(HiveKeys.userPreferencesBox);
    } catch (e) {
      throw StorageException(
        message: 'User preferences box not found. Did you call init()?',
        code: 'BOX_NOT_FOUND',
      );
    }
  }

  /// Get pet data box
  static Box<dynamic> get petData {
    try {
      return Hive.box(HiveKeys.petDataBox);
    } catch (e) {
      throw StorageException(
        message: 'Pet data box not found. Did you call init()?',
        code: 'BOX_NOT_FOUND',
      );
    }
  }

  /// Get focus sessions box
  static Box<dynamic> get focusSessions {
    try {
      return Hive.box(HiveKeys.focusSessionsBox);
    } catch (e) {
      throw StorageException(
        message: 'Focus sessions box not found. Did you call init()?',
        code: 'BOX_NOT_FOUND',
      );
    }
  }

  /// Get shop items box
  static Box<dynamic> get shopItems {
    try {
      return Hive.box(HiveKeys.shopItemsBox);
    } catch (e) {
      throw StorageException(
        message: 'Shop items box not found. Did you call init()?',
        code: 'BOX_NOT_FOUND',
      );
    }
  }

  /// Get statistics box
  static Box<dynamic> get statistics {
    try {
      return Hive.box(HiveKeys.statisticsBox);
    } catch (e) {
      throw StorageException(
        message: 'Statistics box not found. Did you call init()?',
        code: 'BOX_NOT_FOUND',
      );
    }
  }

  /// Clear all data (useful for testing/reset)
  static Future<void> clearAll() async {
    try {
      await Hive.deleteFromDisk();
      print('[$_logTag] ✓ All Hive data cleared');
    } catch (e, stackTrace) {
      throw StorageException(
        message: 'Failed to clear Hive data: $e',
        code: 'CLEAR_FAILED',
        stackTrace: stackTrace,
      );
    }
  }

  /// Close all boxes (call before app exit if needed)
  static Future<void> closeAll() async {
    try {
      await Hive.close();
      print('[$_logTag] ✓ All Hive boxes closed');
    } catch (e, stackTrace) {
      throw StorageException(
        message: 'Failed to close Hive: $e',
        code: 'CLOSE_FAILED',
        stackTrace: stackTrace,
      );
    }
  }
}
