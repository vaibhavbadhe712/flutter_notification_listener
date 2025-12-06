import 'package:flutter/material.dart';

/// Widget to display when there are no notifications
class EmptyStateWidget extends StatelessWidget {
  final bool isServiceStarted;

  const EmptyStateWidget({
    Key? key,
    required this.isServiceStarted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            isServiceStarted
                ? 'Waiting for notifications...'
                : 'Start the service to listen for notifications',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          if (!isServiceStarted) ...[
            const SizedBox(height: 8),
            Text(
              'Tap the play button below to start',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
