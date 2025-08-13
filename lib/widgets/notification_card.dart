import 'package:flutter/material.dart';

import '../models/notification_model.dart';
import '../utils/app_constants.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.height20),
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width20,
        vertical: Dimensions.height20,
      ),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight.withOpacity(0.6),
          borderRadius: BorderRadius.circular(Dimensions.radius15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: Dimensions.height40,
                width: Dimensions.width40,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.1)),
                  shape: BoxShape.circle,
                  color: Theme.of(context).secondaryHeaderColor,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(AppConstants.getPngAsset('logo')),
                  ),
                ),
              ),
              SizedBox(width: Dimensions.width10),
              Expanded(
                child: Text(
                  notification.title ?? 'No Title',
                  style: TextStyle(
                    fontSize: Dimensions.font17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height10),
          Text(
            notification.message ?? 'No message',
            overflow: TextOverflow.clip,
            style: TextStyle(fontSize: Dimensions.font13),
          ),
          SizedBox(height: Dimensions.height10),
          Text(
            _formatDate(notification.createdAt),
            style: TextStyle(fontSize: Dimensions.font12),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}
