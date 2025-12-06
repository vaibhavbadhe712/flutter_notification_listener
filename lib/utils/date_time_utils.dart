/// Utility class for formatting dates and times
class DateTimeUtils {
  /// Format DateTime to relative time string (e.g., "2m ago", "Just now")
  static String formatRelativeTime(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return _formatAbsoluteTime(dateTime);
    }
  }

  /// Format DateTime to absolute time string (e.g., "6/12 15:22")
  static String _formatAbsoluteTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month} '
        '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Format DateTime to full string (e.g., "2025-12-06 15:22:50")
  static String formatFullTime(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown';
    return dateTime.toString().substring(0, 19);
  }
}
