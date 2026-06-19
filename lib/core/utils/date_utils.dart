import 'package:intl/intl.dart';

/// Utility functions for date and time operations
class DateUtils {
  DateUtils._();

  /// Get current date at midnight
  static DateTime getToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Format DateTime to "dd/MM/yyyy"
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Format DateTime to "HH:mm"
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Format DateTime to "dd/MM/yyyy HH:mm"
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  /// Format DateTime to "EEEE, dd MMMM" (e.g., "Monday, 15 January")
  static String formatDateLong(DateTime date) {
    return DateFormat('EEEE, dd MMMM', 'pt_BR').format(date);
  }

  /// Format duration to "HH:mm:ss"
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Format duration to "mm:ss"
  static String formatDurationShort(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Check if two dates are the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Check if a date is today
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  /// Check if a date is yesterday
  static bool isYesterday(DateTime date) {
    return isSameDay(date, DateTime.now().subtract(const Duration(days: 1)));
  }

  /// Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Get difference in days between two dates
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  /// Get the week number of a date
  static int getWeekNumber(DateTime date) {
    return ((date.day - date.weekday + 10) / 7).floor();
  }

  /// Get the week start date (Monday)
  static DateTime getWeekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  /// Get the week end date (Sunday)
  static DateTime getWeekEnd(DateTime date) {
    return date.add(Duration(days: DateTime.sunday - date.weekday));
  }

  /// Format seconds to human readable duration
  /// e.g., "2 hours, 30 minutes"
  static String formatSecondsToReadable(int seconds) {
    final duration = Duration(seconds: seconds);
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    final parts = <String>[];
    if (days > 0) parts.add('$days dia${days > 1 ? 's' : ''}');
    if (hours > 0) parts.add('$hours hora${hours > 1 ? 's' : ''}');
    if (minutes > 0) parts.add('$minutes minuto${minutes > 1 ? 's' : ''}');

    return parts.isEmpty ? '0 minutos' : parts.join(', ');
  }

  /// Check if a date is in the past
  static bool isPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  /// Check if a date is in the future
  static bool isFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }
}
