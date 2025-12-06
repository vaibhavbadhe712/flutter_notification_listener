import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/notification_controller.dart';
import '../widgets/notification_card.dart';
import '../widgets/empty_state_widget.dart';

/// Main view for displaying notifications
class NotificationListView extends StatefulWidget {
  const NotificationListView({Key? key}) : super(key: key);

  @override
  State<NotificationListView> createState() => _NotificationListViewState();
}

@pragma('vm:entry-point') // Allow native code to access this class
class _NotificationListViewState extends State<NotificationListView> {
  late NotificationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = context.read<NotificationController>();
    _initializeController();
  }

  Future<void> _initializeController() async {
    await _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// Build the app bar with title and actions
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Consumer<NotificationController>(
        builder: (context, controller, child) {
          final count = controller.notificationCount;
          return Text(
            'Notification Listener${count > 0 ? ' ($count)' : ''}',
          );
        },
      ),
      actions: [
        Consumer<NotificationController>(
          builder: (context, controller, child) {
            if (!controller.hasNotifications) return const SizedBox.shrink();
            
            return IconButton(
              onPressed: () => _showClearConfirmation(context),
              icon: const Icon(Icons.clear_all),
              tooltip: 'Clear all',
            );
          },
        ),
        IconButton(
          onPressed: () {
            // TODO: Navigate to settings
            print("TODO: Settings");
          },
          icon: const Icon(Icons.settings),
          tooltip: 'Settings',
        ),
      ],
    );
  }

  /// Build the main body content
  Widget _buildBody() {
    return Consumer<NotificationController>(
      builder: (context, controller, child) {
        if (!controller.hasNotifications) {
          return EmptyStateWidget(
            isServiceStarted: controller.isServiceStarted,
          );
        }

        return ListView.builder(
          itemCount: controller.notificationCount,
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            final notification = controller.getNotification(index);
            if (notification == null) return const SizedBox.shrink();

            return NotificationCard(
              notification: notification,
              onTap: () => notification.tap(),
            );
          },
        );
      },
    );
  }

  /// Build the floating action button
  Widget _buildFloatingActionButton() {
    return Consumer<NotificationController>(
      builder: (context, controller, child) {
        return FloatingActionButton(
          onPressed: () => _handleFabPress(context),
          tooltip: controller.isServiceStarted ? 'Stop listening' : 'Start listening',
          child: _buildFabIcon(controller),
        );
      },
    );
  }

  /// Build the FAB icon based on state
  Widget _buildFabIcon(NotificationController controller) {
    if (controller.isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      );
    }

    return Icon(
      controller.isServiceStarted ? Icons.stop : Icons.play_arrow,
    );
  }

  /// Handle floating action button press
  Future<void> _handleFabPress(BuildContext context) async {
    final controller = context.read<NotificationController>();

    if (controller.isServiceStarted) {
      await controller.stopListening();
    } else {
      await controller.startListening(context);
    }
  }

  /// Show confirmation dialog before clearing all notifications
  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text('Are you sure you want to clear all notifications?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<NotificationController>().clearAllNotifications();
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
