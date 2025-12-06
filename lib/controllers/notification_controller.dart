import 'dart:async';
import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

/// Controller class to manage notification listener state and business logic
class NotificationController extends ChangeNotifier {
  final NotificationService _service = NotificationService();

  final List<NotificationModel> _notifications = [];
  bool _isServiceStarted = false;
  bool _isLoading = false;
  StreamSubscription<NotificationModel>? _notificationSubscription;

  /// Getters
  List<NotificationModel> get notifications => List.unmodifiable(_notifications);
  bool get isServiceStarted => _isServiceStarted;
  bool get isLoading => _isLoading;
  bool get hasNotifications => _notifications.isNotEmpty;
  int get notificationCount => _notifications.length;

  /// Initialize the controller
  Future<void> initialize() async {
    await _service.initialize();
    _isServiceStarted = await _service.isServiceRunning();
    
    // Subscribe to notification stream
    _notificationSubscription = _service.notificationStream.listen(
      _onNotificationReceived,
      onError: (error) {
        print("Error receiving notification: $error");
      },
    );
    
    notifyListeners();
  }

  /// Handle incoming notification
  void _onNotificationReceived(NotificationModel notification) {
    _notifications.insert(0, notification); // Add to beginning of list
    print("Notification added: ${notification.appName} - ${notification.title}");
    notifyListeners();
  }

  /// Start the notification listener service
  Future<bool> startListening(BuildContext context) async {
    _setLoading(true);

    try {
      // Step 1: Request POST_NOTIFICATIONS permission (Android 13+)
      final hasNotificationPermission = await _service.requestNotificationPermission();
      if (!hasNotificationPermission) {
        _showSnackBar(context, 'Notification permission is required');
        _setLoading(false);
        return false;
      }

      // Step 2: Check notification listener permission
      final hasListenerPermission = await _service.hasNotificationListenerPermission();
      if (!hasListenerPermission) {
        print("Opening notification listener settings");
        _service.openNotificationListenerSettings();
        _setLoading(false);
        return false;
      }

      // Step 3: Start the service if not already running
      final isRunning = await _service.isServiceRunning();
      if (!isRunning) {
        await _service.startService();
      }

      _isServiceStarted = true;
      _setLoading(false);
      return true;
    } catch (e) {
      print("Error starting service: $e");
      _showSnackBar(context, 'Error starting service: $e');
      _setLoading(false);
      return false;
    }
  }

  /// Stop the notification listener service
  Future<void> stopListening() async {
    _setLoading(true);

    try {
      await _service.stopService();
      _isServiceStarted = false;
    } catch (e) {
      print("Error stopping service: $e");
    } finally {
      _setLoading(false);
    }
  }

  /// Clear all notifications
  void clearAllNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  /// Remove a specific notification
  void removeNotification(int index) {
    if (index >= 0 && index < _notifications.length) {
      _notifications.removeAt(index);
      notifyListeners();
    }
  }

  /// Get notification at index
  NotificationModel? getNotification(int index) {
    if (index >= 0 && index < _notifications.length) {
      return _notifications[index];
    }
    return null;
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Show snackbar message
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Dispose resources
  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }
}
