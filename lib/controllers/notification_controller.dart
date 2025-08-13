import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repo/notification_repo.dart';
import '../models/notification_model.dart';
import '../routes/routes.dart';
import '../utils/app_constants.dart';
import '../widgets/snackbars.dart';

class NotificationController extends GetxController {
  final NotificationRepo notificationRepo;

  NotificationController({required this.notificationRepo});

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  SharedPreferences sharedPreferences = Get.find<SharedPreferences>();

  @override
  void onInit() {
    super.onInit();
    _initializeLocalNotifications();
    _setupFCMListeners();
  }

  Future<void> fetchNotifications() async {
    try {
      final response = await notificationRepo.getNotifications();

      if (response.statusCode == 200 && response.body['code'] == '00') {
        final List data = response.body['data'];
        notifications.value = data.map((e) => NotificationModel.fromJson(e)).toList();
      } else {
        notifications.clear();
        MySnackBars.failure(
          title: "Error",
          message: response.body['message'] ?? 'Failed to load notifications',
        );
      }
    } catch (e, s) {
      notifications.clear();
      print('❌ Exception in fetchNotifications: $e\n$s');
      MySnackBars.failure(title: "Error", message: 'Something went wrong.');
    }
  }

  void _showLocalNotification({required String title, required String body}) async {
    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'sharpdrop',
        'Sharp Drop Notifications',
        channelDescription: 'Handles app alerts',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      );

      const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        notificationDetails,
      );
    } catch (e, s) {
      print('❌ Failed to show local notification: $e\n$s');
    }
  }

  void _initializeLocalNotifications() {
    try {
      const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidInit,
        iOS: iosInit,
      );

      flutterLocalNotificationsPlugin.initialize(initSettings);
    } catch (e, s) {
      print('❌ Error initializing local notifications: $e\n$s');
    }
  }

  void _setupFCMListeners() {
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('📥 Foreground FCM Message: ${message.notification?.title}');
        if (message.notification != null) {
          _showLocalNotification(
            title: message.notification!.title ?? 'Notification',
            body: message.notification!.body ?? '',
          );
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('📦 User opened app from notification');
        Get.toNamed(AppRoutes.notificationScreen);
      });
    } catch (e, s) {
      print('❌ Error setting up FCM listeners: $e\n$s');
    }
  }

  Future<void> saveDeviceToken() async {
    try {
      if (Platform.isIOS) {
        String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken == null) {
          print('⚠️ APNs token not yet available. Skipping iOS device token save.');
          return;
        }
      }

      final token = await FirebaseMessaging.instance.getToken();
      final platform = Platform.isAndroid ? 'android' : 'ios';

      if (token != null && token.isNotEmpty) {
        final body = {
          "deviceToken": token,
          "platform": platform,
        };

        final endpoint = AppConstants.UPDATE_DEVICE_TOKEN;
        final response = await notificationRepo.postDeviceToken(endpoint, body);

        if (response.statusCode == 200 && response.body['code'] == '00') {
          print('✅ Device token saved successfully');
        } else {
          print('❌ Token save failed: ${response.body}');
        }
      } else {
        print('❌ FirebaseMessaging.getToken() returned null or empty.');
      }
    } catch (e, s) {
      print('❌ Error saving device token: $e\n$s');
    }
  }

}