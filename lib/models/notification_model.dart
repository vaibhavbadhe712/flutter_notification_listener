import 'package:flutter_notification_listener_plus/flutter_notification_listener_plus.dart';

/// Model class representing a notification with formatted data
class NotificationModel {
  final NotificationEvent event;
  final DateTime receivedAt;

  NotificationModel({
    required this.event,
    required this.receivedAt,
  });

  /// Get the app name from package name
  String get appName {
    final packageName = event.packageName?.toString() ?? 'Unknown';
    return packageName.split('.').last;
  }

  /// Get the full package name
  String get packageName => event.packageName?.toString() ?? 'Unknown';

  /// Get the notification title
  String? get title => event.title;

  /// Get the notification text/message
  String? get message => event.text;

  /// Get the timestamp when notification was created
  DateTime? get timestamp => event.createAt;

  /// Get the notification actions
  List<dynamic>? get actions => event.actions;

  /// Check if notification has content
  bool get hasContent =>
      (title != null && title!.isNotEmpty) ||
      (message != null && message!.isNotEmpty);

  /// Tap the notification
  void tap() => event.tap();

  /// Get full notification data
  Future<dynamic> getFull() => event.getFull();

  /// Convert to JSON for debugging
  Map<String, dynamic> toJson() => {
        'appName': appName,
        'packageName': packageName,
        'title': title,
        'message': message,
        'timestamp': timestamp?.toIso8601String(),
        'receivedAt': receivedAt.toIso8601String(),
      };

  @override
  String toString() => toJson().toString();
}
