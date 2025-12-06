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

  // Map package names to app logos/icons
  static const Map<String, IconData> appLogos = {
    'com.instagram.android': Icons.photo_camera,
    'com.whatsapp.w4b': Icons.chat,
    'com.facebook.katana': Icons.people,
    'com.google.android.gm': Icons.mail,
    'com.google.android.apps.messaging': Icons.sms,
    'com.twitter.android': Icons.share,
    'com.telegram.messenger': Icons.send,
    'com.google.android.youtube': Icons.play_circle,
    'com.spotify.music': Icons.music_note,
    'com.google.android.maps': Icons.location_on,
    'com.google.android.apps.maps': Icons.location_on,
    'com.linkedin.android': Icons.business,
    'com.snapchat.android': Icons.face,
    'com.discord': Icons.videogame_asset,
    'com.google.android.googlequicksearchbox': Icons.search,
    'com.microsoft.teams': Icons.video_call,
    'com.microsoft.skype.raider': Icons.call,
  };

  // Map package names to colors
  static const Map<String, Color> appColors = {
    'com.instagram.android': Color(0xFFE1306C),
    'com.whatsapp.w4b': Color(0xFF25D366),
    'com.facebook.katana': Color(0xFF1877F2),
    'com.google.android.gm': Color(0xFFEA4335),
    'com.google.android.apps.messaging': Color(0xFF0084FF),
    'com.twitter.android': Color(0xFF1DA1F2),
    'com.telegram.messenger': Color(0xFF0088cc),
    'com.google.android.youtube': Color(0xFFFF0000),
    'com.spotify.music': Color(0xFF1DB954),
    'com.google.android.maps': Color(0xFF4285F4),
    'com.google.android.apps.maps': Color(0xFF4285F4),
    'com.linkedin.android': Color(0xFF0A66C2),
    'com.snapchat.android': Color(0xFFFFFC00),
    'com.discord': Color(0xFF5865F2),
    'com.google.android.googlequicksearchbox': Color(0xFF4285F4),
    'com.microsoft.teams': Color(0xFF6264A7),
    'com.microsoft.skype.raider': Color(0xFF00AFF0),
  };

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
        _buildAppIcon(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.appName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                notification.packageName,
                style: TextStyle(
                  fontSize: 11,
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

  /// Build app icon with package-specific icon and color
  Widget _buildAppIcon() {
    final icon = appLogos[notification.packageName] ?? Icons.apps;
    final color = appColors[notification.packageName] ?? Colors.blue;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: 28,
        color: color,
      ),
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