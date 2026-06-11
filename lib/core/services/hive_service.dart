import 'package:hive_flutter/hive_flutter.dart';
import '../constants/hive_keys.dart';
import '../errors/app_exceptions.dart';

/// Service for managing Hive database operations
class HiveService {
  static const String _tag = 'HiveService';
  static bool _initialized = false;

  /// Initialize Hive and open required boxes
  static Future<void> init() async {
    try {
      if (_initialized) {
        return;
      }

      // Initialize Hive
      await Hive.initFlutter();

      // Open boxes
      await _openBox(HiveKeys.userBox);
      await _openBox(HiveKeys.petBox);
      await _openBox(HiveKeys.sessionBox);
      await _openBox(HiveKeys.shopBox);
      await _openBox(HiveKeys.settingsBox);
      await _openBox(HiveKeys.statisticsBox);
      await _openBox(HiveKeys.onboardingBox);

      _initialized = true;
      print('[$_tag] Hive initialized successfully');
    } catch (e) {
      throw HiveException('Failed to initialize Hive: $e');
    }
  }

  /// Open a Hive box safely
  static Future<void> _openBox(String boxName) async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox(boxName);
      }
    } catch (e) {
      throw HiveException('Failed to open box "$boxName": $e');
    }
  }

  /// Get a specific box
  static Box<dynamic> getBox(String boxName) {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        throw HiveException('Box "$boxName" is not open');
      }
      return Hive.box(boxName);
    } catch (e) {
      throw HiveException('Failed to get box "$boxName": $e');
    }
  }

  /// Write a value to a box
  static Future<void> put({
    required String boxName,
    required String key,
    required dynamic value,
  }) async {
    try {
      final box = getBox(boxName);
      await box.put(key, value);
    } catch (e) {
      throw HiveException('Failed to write to "$boxName": $e');
    }
  }

  /// Read a value from a box
  static dynamic get({
    required String boxName,
    required String key,
    dynamic defaultValue,
  }) {
    try {
      final box = getBox(boxName);
      return box.get(key, defaultValue: defaultValue);
    } catch (e) {
      throw HiveException('Failed to read from "$boxName": $e');
    }
  }

  /// Delete a value from a box
  static Future<void> delete({
    required String boxName,
    required String key,
  }) async {
    try {
      final box = getBox(boxName);
      await box.delete(key);
    } catch (e) {
      throw HiveException('Failed to delete from "$boxName": $e');
    }
  }

  /// Check if a key exists in a box
  static bool containsKey({
    required String boxName,
    required String key,
  }) {
    try {
      final box = getBox(boxName);
      return box.containsKey(key);
    } catch (e) {
      throw HiveException('Failed to check key in "$boxName": $e');
    }
  }

  /// Clear all data from a box
  static Future<void> clearBox(String boxName) async {
    try {
      final box = getBox(boxName);
      await box.clear();
    } catch (e) {
      throw HiveException('Failed to clear box "$boxName": $e');
    }
  }

  /// Clear all Hive data (reset app)
  static Future<void> clearAll() async {
    try {
      await Hive.deleteFromDisk();
      _initialized = false;
      print('[$_tag] All Hive data cleared');
    } catch (e) {
      throw HiveException('Failed to clear all Hive data: $e');
    }
  }

  /// Compact all boxes (maintenance)
  static Future<void> compactAll() async {
    try {
      final boxes = [
        HiveKeys.userBox,
        HiveKeys.petBox,
        HiveKeys.sessionBox,
        HiveKeys.shopBox,
        HiveKeys.settingsBox,
        HiveKeys.statisticsBox,
        HiveKeys.onboardingBox,
      ];

      for (final boxName in boxes) {
        if (Hive.isBoxOpen(boxName)) {
          await getBox(boxName).compact();
        }
      }
      print('[$_tag] All boxes compacted');
    } catch (e) {
      throw HiveException('Failed to compact boxes: $e');
    }
  }

  // Empty constructor to prevent instantiation
  HiveService._();
}
