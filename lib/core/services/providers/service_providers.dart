import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notification_service.dart';
import '../ambient_sound_service.dart';
import '../app_blocking_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final ambientSoundServiceProvider = Provider<AmbientSoundService>((ref) {
  return AmbientSoundService();
});

final appBlockingServiceProvider = Provider<AppBlockingService>((ref) {
  return AppBlockingService(ref.watch(notificationServiceProvider));
});
