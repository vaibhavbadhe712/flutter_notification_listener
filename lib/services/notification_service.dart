import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_notification_listener_plus/flutter_notification_listener_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/notification_model.dart';

/// Service class to handle notification listening and permissions
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final ReceivePort _port = ReceivePort();
  final StreamController<NotificationModel> _notificationController =
      StreamController<NotificationModel>.broadcast();

  /// Stream of incoming notifications
  Stream<NotificationModel> get notificationStream =>
      _notificationController.stream;

  bool _isInitialized = false;

  /// Initialize the notification listener service
  Future<void> initialize() async {
    if (_isInitialized) return;

    NotificationsListener.initialize(callbackHandle: notificationCallback);

    // Register isolate port for communication
    IsolateNameServer.removePortNameMapping("_listener_");
    IsolateNameServer.registerPortWithName(_port.sendPort, "_listener_");

    // Listen for incoming notifications
    _port.listen((message) {
      if (message is NotificationEvent) {
        final notification = NotificationModel(
          event: message,
          receivedAt: DateTime.now(),
        );
        _notificationController.add(notification);
      }
    });

    _isInitialized = true;
  }

  /// Check if the service is currently running
  Future<bool> isServiceRunning() async {
    return (await NotificationsListener.isRunning) ?? false;
  }

  /// Check if notification listener permission is granted
  Future<bool> hasNotificationListenerPermission() async {
    return (await NotificationsListener.hasPermission) ?? false;
  }

  /// Request POST_NOTIFICATIONS permission (Android 13+)
  Future<bool> requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      status = await Permission.notification.request();
    }
    return status.isGranted;
  }

  /// Open notification listener settings
  void openNotificationListenerSettings() {
    NotificationsListener.openPermissionSettings();
  }

  /// Start the notification listener service
  Future<void> startService() async {
    await NotificationsListener.startService(
      foreground: true,
      title: "Notification Listener",
      description: "Monitoring notifications",
    );
  }

  /// Stop the notification listener service
  Future<void> stopService() async {
    await NotificationsListener.stopService();
  }

  /// Dispose resources
  void dispose() {
    _notificationController.close();
    _port.close();
  }
}

/// Top-level callback method for isolate communication
@pragma('vm:entry-point')
void notificationCallback(NotificationEvent evt) {
  print("Notification received: ${evt.packageName} - ${evt.title}");
  final SendPort? send = IsolateNameServer.lookupPortByName("_listener_");
  if (send == null) {
    print("Error: Can't find the sender port");
    return;
  }
  send.send(evt);
}
