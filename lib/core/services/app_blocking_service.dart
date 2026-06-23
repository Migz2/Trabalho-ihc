import 'dart:async';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'notification_service.dart';

class AppInfo {
  final String appName;
  final String packageName;
  final Uint8List? icon;
  AppInfo({required this.appName, required this.packageName, this.icon});
}

class AppBlockingService {
  static const MethodChannel _channel =
      MethodChannel('com.honey.app/app_blocking');

  AppBlockingService(this._notificationService);

  final NotificationService _notificationService;
  Timer? _monitorTimer;

  /// Checks whether the usage-access permission is actually granted,
  /// instead of assuming it from opening the settings screen.
  Future<bool> hasUsageStatsPermission() async {
    try {
      return await _channel.invokeMethod<bool>('hasUsageStatsPermission') ??
          false;
    } catch (e) {
      debugPrint('Failed to check usage access permission: $e');
      return false;
    }
  }

  /// Opens the system settings screen so the user can grant the
  /// permission. Does not report back whether it was granted — call
  /// [hasUsageStatsPermission] afterwards to confirm.
  Future<void> requestUsageStatsPermission() async {
    try {
      final intent = AndroidIntent(
        action: 'android.settings.USAGE_ACCESS_SETTINGS',
      );
      await intent.launch();
    } catch (e) {
      debugPrint('Failed to open usage access settings: $e');
    }
  }

  Future<bool> hasNotificationListenerPermission() async {
    try {
      return await _channel.invokeMethod<bool>(
            'hasNotificationListenerPermission',
          ) ??
          false;
    } catch (e) {
      debugPrint('Failed to check notification listener permission: $e');
      return false;
    }
  }

  /// Opens the system settings screen so the user can grant Honey access
  /// to read and cancel notifications from blocked apps.
  Future<void> requestNotificationListenerPermission() async {
    try {
      await _channel.invokeMethod('requestNotificationListenerPermission');
    } catch (e) {
      debugPrint('Failed to open notification listener settings: $e');
    }
  }

  Future<bool> hasOverlayPermission() async {
    try {
      return await _channel.invokeMethod<bool>('hasOverlayPermission') ??
          false;
    } catch (e) {
      debugPrint('Failed to check overlay permission: $e');
      return false;
    }
  }

  /// Opens the system settings screen so the user can grant Honey
  /// permission to draw over other apps. Without this, Android 10+ can
  /// silently block [bringHoneyToForeground] while Honey is backgrounded.
  Future<void> requestOverlayPermission() async {
    try {
      await _channel.invokeMethod('requestOverlayPermission');
    } catch (e) {
      debugPrint('Failed to open overlay settings: $e');
    }
  }

  Future<List<AppInfo>> getInstalledApps() async {
    try {
      final apps = await _channel.invokeMethod<List<Object?>>(
        'getInstalledApps',
      );
      return (apps ?? [])
          .cast<Map<Object?, Object?>>()
          .map((app) => AppInfo(
                appName: app['appName'] as String,
                packageName: app['packageName'] as String,
                icon: app['icon'] as Uint8List?,
              ))
          .toList();
    } catch (e) {
      debugPrint('Failed to get installed apps: $e');
      return [];
    }
  }

  Future<String?> getForegroundApp() async {
    try {
      return await _channel.invokeMethod<String>('getForegroundApp');
    } catch (e) {
      debugPrint('Failed to get foreground app: $e');
      return null;
    }
  }

  /// Tells the native side which packages to silence notifications for, and
  /// whether silencing is currently active. The notification listener
  /// service reads this on every incoming notification.
  Future<void> syncBlockingState({
    required bool active,
    required List<String> blockedPackages,
  }) async {
    try {
      await _channel.invokeMethod('setBlockingState', {
        'active': active,
        'blockedPackages': blockedPackages,
      });
    } catch (e) {
      debugPrint('Failed to sync blocking state: $e');
    }
  }

  /// Polls the foreground app while a focus session is active and reacts
  /// according to [intensity] ('soft', 'medium' or 'intense') whenever a
  /// blocked app is opened.
  void startMonitoring(List<String> blockedPackages, String intensity) {
    _monitorTimer?.cancel();
    _monitorTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      final foreground = await getForegroundApp();
      if (foreground == null || !blockedPackages.contains(foreground)) return;

      if (intensity == 'soft') {
        await _notificationService.showFocusReminder();
      } else {
        await bringHoneyToForeground();
      }
    });
  }

  void stopMonitoring() {
    _monitorTimer?.cancel();
    _monitorTimer = null;
  }

  Future<void> bringHoneyToForeground() async {
    try {
      await _channel.invokeMethod('bringToForeground');
    } catch (e) {
      debugPrint('Failed to bring app to foreground: $e');
    }
  }
}
