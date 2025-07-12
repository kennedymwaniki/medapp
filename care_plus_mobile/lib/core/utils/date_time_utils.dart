import 'package:intl/intl.dart';

/// Date and time utility functions
class DateTimeUtils {
  /// Format date to readable string
  static String formatDate(DateTime date, {String pattern = 'MMM dd, yyyy'}) {
    return DateFormat(pattern).format(date);
  }

  /// Format time to readable string
  static String formatTime(DateTime time, {bool use24Hour = false}) {
    final pattern = use24Hour ? 'HH:mm' : 'h:mm a';
    return DateFormat(pattern).format(time);
  }

  /// Format date and time
  static String formatDateTime(
    DateTime dateTime, {
    String pattern = 'MMM dd, yyyy h:mm a',
  }) {
    return DateFormat(pattern).format(dateTime);
  }

  /// Get relative time (e.g., "2 hours ago", "tomorrow")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return months == 1 ? '1 month ago' : '$months months ago';
      } else {
        final years = (difference.inDays / 365).floor();
        return years == 1 ? '1 year ago' : '$years years ago';
      }
    } else if (difference.inDays < 0) {
      final futureDifference = dateTime.difference(now);
      if (futureDifference.inDays == 1) {
        return 'Tomorrow';
      } else if (futureDifference.inDays < 7) {
        return 'In ${futureDifference.inDays} days';
      } else {
        return formatDate(dateTime);
      }
    } else if (difference.inHours > 0) {
      return difference.inHours == 1
          ? '1 hour ago'
          : '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1
          ? '1 minute ago'
          : '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Get start of week (Monday)
  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: daysFromMonday)));
  }

  /// Get end of week (Sunday)
  static DateTime endOfWeek(DateTime date) {
    final daysToSunday = 7 - date.weekday;
    return endOfDay(date.add(Duration(days: daysToSunday)));
  }

  /// Get start of month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get end of month
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  }

  /// Calculate age from birth date
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  /// Generate medication schedule times
  static List<DateTime> generateMedicationTimes({
    required DateTime startDate,
    required int timesPerDay,
    required int intervalHours,
    int days = 30,
  }) {
    final times = <DateTime>[];
    final interval = Duration(hours: intervalHours);

    DateTime currentDate = startOfDay(startDate);
    final endDate = currentDate.add(Duration(days: days));

    while (currentDate.isBefore(endDate)) {
      DateTime currentTime = currentDate.add(
        const Duration(hours: 8),
      ); // Start at 8 AM

      for (int i = 0; i < timesPerDay; i++) {
        times.add(currentTime);
        currentTime = currentTime.add(interval);
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return times;
  }

  /// Check if time is within business hours
  static bool isBusinessHours(
    DateTime time, {
    int startHour = 8,
    int endHour = 18,
  }) {
    return time.hour >= startHour && time.hour < endHour;
  }

  /// Get next business day
  static DateTime nextBusinessDay(DateTime date) {
    DateTime nextDay = date.add(const Duration(days: 1));
    while (nextDay.weekday == DateTime.saturday ||
        nextDay.weekday == DateTime.sunday) {
      nextDay = nextDay.add(const Duration(days: 1));
    }
    return nextDay;
  }

  /// Parse date string with multiple formats
  static DateTime? parseDate(String dateString) {
    final formats = [
      'yyyy-MM-dd',
      'yyyy-MM-dd HH:mm:ss',
      'yyyy-MM-ddTHH:mm:ss',
      'yyyy-MM-ddTHH:mm:ssZ',
      'dd/MM/yyyy',
      'MM/dd/yyyy',
      'dd-MM-yyyy',
      'MM-dd-yyyy',
    ];

    for (final format in formats) {
      try {
        return DateFormat(format).parse(dateString);
      } catch (e) {
        continue;
      }
    }

    return null;
  }

  /// Format duration to readable string
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} day${duration.inDays == 1 ? '' : 's'}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours == 1 ? '' : 's'}';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minute${duration.inMinutes == 1 ? '' : 's'}';
    } else {
      return '${duration.inSeconds} second${duration.inSeconds == 1 ? '' : 's'}';
    }
  }
}
