import 'dart:async';

import 'package:flutter/material.dart';

import '../../controllers/notification_controller.dart';
import 'package:get/get.dart';

import '../../utils/dimensions.dart';
import '../../widgets/notification_card.dart';



class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationController controller = Get.find<NotificationController>();

  Timer? notificationTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchNotifications();

      notificationTimer = Timer.periodic(Duration(seconds: 60), (_) {
        controller.fetchNotifications();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(color: Theme.of(context).dividerColor),
        title: Text('Notifications'),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.chevron_left),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchNotifications();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
          child: Obx(() {
            final notifications = controller.notifications;

            if (notifications.isEmpty) {
              return  Center(
                child: Text('No Notifications yet',style: TextStyle(color: Theme.of(context).highlightColor),),
              );
            }

            return ListView.builder(
              // padding: EdgeInsets.all(Dimensions.width20),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return NotificationCard(notification: notifications[index]);
              },
            );
          }),
        ),
      ),
    );
  }
}

