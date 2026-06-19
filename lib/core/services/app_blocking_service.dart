import 'dart:async';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';

import '../notification_service.dart';

class AppInfo {
  final String appName;
  final String packageName;
  AppInfo({required this.appName, required this.packageName});
}

class AppBlockingService {
  final NotificationService _notificationService;
  Timer? _monitorTimer;

  AppBlockingService(this._notificationService);

  Future<bool> requestUsageStatsPermission() async {
    // Real implementation should open settings via Intent
    try {
      final intent = AndroidIntent(
        action: 'android.settings.USAGE_ACCESS_SETTINGS',
      );
      await intent.launch();
      return true;
    } catch (e) {
      debugPrint('Failed to open usage access settings: $e');
      return false;
    }
  }

  Future<List<AppInfo>> getInstalledApps() async {
    // Placeholder: real implementation should use device_apps package
    return [];
  }

  void startMonitoring(List<String> blockedPackages, dynamic intensity) {
    _monitorTimer?.cancel();
    _monitorTimer = Timer.periodic(const Duration(seconds: 5), (t) async {
      // Ideally check foreground app via app_usage package
      // If detected, call _handleBlockedAppDetected
    });
  }

  Future<void> _handleBlockedAppDetected(String package, dynamic intensity) async {
    // soft: notification only
    // medium: bring app to foreground via intent + notification
    // intense: force bring to foreground
    _notificationService.showFocusReminder();
    if (intensity == 'medium' || intensity == 'intense') {
      await bringHoneyToForeground();
    }
  }

  Future<void> bringHoneyToForeground() async {
    try {
      final intent = AndroidIntent(
        action: 'action_main',
        package: 'com.honey.app',
        flags: <int>[0x10000000],
      );
      await intent.launch();
    } catch (e) {
      debugPrint('Failed to bring app to foreground: $e');
    }
  }

  void stopMonitoring() {
    _monitorTimer?.cancel();
    _monitorTimer = null;
  }
}
