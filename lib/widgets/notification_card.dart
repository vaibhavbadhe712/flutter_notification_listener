import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../utils/date_time_utils.dart';

/// Widget to display a single notification card
class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;

  const NotificationCard({
    Key? key,
    required this.notification,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap ?? () => notification.tap(),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the header with app info and timestamp
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildAppInfo()),
        _buildTimestamp(),
      ],
    );
  }

  /// Build app icon and name section
  Widget _buildAppInfo() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.apps,
            size: 20,
            color: Colors.blue.shade700,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.appName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.blue.shade700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                notification.packageName,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build timestamp section
  Widget _buildTimestamp() {
    return Text(
      DateTimeUtils.formatRelativeTime(notification.timestamp),
      style: TextStyle(
        fontSize: 11,
        color: Colors.grey.shade600,
      ),
    );
  }

  /// Build notification content (title and message)
  Widget _buildContent() {
    if (!notification.hasContent) {
      return Text(
        '<<no content>>',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (notification.title != null && notification.title!.isNotEmpty)
          Text(
            notification.title!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        if (notification.message != null && notification.message!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              notification.message!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
      ],
    );
  }
}
