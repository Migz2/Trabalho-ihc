import 'package:intl/intl.dart';

/// Utility functions for date and time operations
class DateUtils {
  /// Format a duration to a readable string (HH:MM:SS)
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Format a duration to MM:SS
  static String formatDurationShort(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Format a DateTime to a date string
  static String formatDate(DateTime date, {String format = 'dd/MM/yyyy'}) {
    return DateFormat(format).format(date);
  }

  /// Format a DateTime to a time string
  static String formatTime(DateTime time, {String format = 'HH:mm'}) {
    return DateFormat(format).format(time);
  }

  /// Format a DateTime to a full date-time string
  static String formatDateTime(DateTime dateTime,
      {String format = 'dd/MM/yyyy HH:mm'}) {
    return DateFormat(format).format(dateTime);
  }

  /// Check if two dates are on the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Get the start of a day
  static DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get the end of a day
  static DateTime getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Get days between two dates
  static int daysBetween(DateTime from, DateTime to) {
    from = getStartOfDay(from);
    to = getStartOfDay(to);
    return to.difference(from).inDays;
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  /// Get relative date string (Today, Yesterday, etc)
  static String getRelativeDateString(DateTime date) {
    final now = DateTime.now();
    if (isToday(date)) {
      return 'Today';
    } else if (isYesterday(date)) {
      return 'Yesterday';
    } else if (daysBetween(date, now) < 7) {
      return 'This week';
    } else if (daysBetween(date, now) < 30) {
      return 'This month';
    } else {
      return formatDate(date);
    }
  }

  // Empty constructor to prevent instantiation
  DateUtils._();
}
