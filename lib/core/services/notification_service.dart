import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _isFocusMode = false;

  Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _plugin.initialize(initSettings, onDidReceiveNotificationResponse: _onTap);
  }

  void _onTap(NotificationResponse response) {
    // handle navigation or deep link if needed
  }

  Future<bool> requestPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  void enterFocusMode() {
    _isFocusMode = true;
  }

  void exitFocusMode() {
    _isFocusMode = false;
  }

  Future<void> showFocusComplete() async {
    if (_isFocusMode) return;
    const android = AndroidNotificationDetails('focus_channel', 'Focus',
        channelDescription: 'Focus notifications', importance: Importance.high);
    const details = NotificationDetails(android: android);
    await _plugin.show(1, 'Foco completo! 🎉', 'Você ganhou moedas. Mel ficou feliz!', details);
  }

  Future<void> showBreakComplete() async {
    if (_isFocusMode) return;
    const android = AndroidNotificationDetails('break_channel', 'Break',
        channelDescription: 'Break notifications', importance: Importance.defaultImportance);
    const details = NotificationDetails(android: android);
    await _plugin.show(2, 'Pausa finalizada ⏰', 'Hora de voltar ao foco!', details);
  }

  Future<void> showFocusReminder() async {
    if (_isFocusMode) return;
    // example periodic scheduling is platform dependent; keep simple
    const android = AndroidNotificationDetails('reminder_channel', 'Reminder',
        channelDescription: 'Focus reminders', importance: Importance.defaultImportance);
    const details = NotificationDetails(android: android);
    await _plugin.show(3, 'Mel está esperando por você 🐾', 'Que tal uma sessão de foco agora?', details);
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  Future<void> silenceForFocus() async {
    _isFocusMode = true;
  }
}
