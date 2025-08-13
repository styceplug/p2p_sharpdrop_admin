import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/user_controller.dart';
import '../models/user_model.dart';
import '../utils/app_constants.dart';

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(NotificationResponse response) {
  print("🔔 Background notification clicked: ${response.payload}");
}

class FirebaseMessagingHelper {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> requestNotificationPermission() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? firstInstall = sharedPreferences.getBool(AppConstants.FIRST_INSTALL);

    if (firstInstall == null || firstInstall) {
      return;
    }

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      await getDeviceToken();
      initLocalNotification();
      firebaseInit();
    }
  }

  Future<void> getDeviceToken() async {
    String? token;

    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission();
      String? apnsToken;
      int retryCount = 3;

      await Future.delayed(Duration(seconds: 5));

      for (int i = 0; i < retryCount; i++) {
        try {
          apnsToken = await FirebaseMessaging.instance.getAPNSToken();
          print('🍏 APNs token: $apnsToken');
        } catch (e, s) {
          print('❌ Error getting APNs token: $e\n$s');
        }

        if (apnsToken != null) break;
        await Future.delayed(Duration(seconds: 1));
      }
    }

    try {
      token = await FirebaseMessaging.instance.getToken();
    } catch (e, stacktrace) {
      print('❌ Error getting FCM token: $e\n$stacktrace');
    }

    if (token != null) {
      final userController = Get.find<UserController>();
      final currentUser = userController.userDetail.value;

      if (currentUser != null) {
        final platform = Platform.isIOS ? 'ios' : 'android';
        final newToken = DeviceToken(token: token, platform: platform);

        // Update in-memory user model
        final updatedTokens = List<DeviceToken>.from(currentUser.deviceTokens ?? []);
        updatedTokens.removeWhere((t) => t.token == token); // avoid duplicates
        updatedTokens.add(newToken);

        userController.userDetail.value = UserModel(
          id: currentUser.id,
          firstName: currentUser.firstName,
          lastName: currentUser.lastName,
          email: currentUser.email,
          number: currentUser.number,
          role: currentUser.role,
          referralCode: currentUser.referralCode,
          referredBy: currentUser.referredBy,
          isOnline: currentUser.isOnline,
          lastSeen: currentUser.lastSeen,
          referralCount: currentUser.referralCount,
          deactivationReason: currentUser.deactivationReason,
          deactivationStatus: currentUser.deactivationStatus,
          deactivationRequestDate: currentUser.deactivationRequestDate,
          createdAt: currentUser.createdAt,
          updatedAt: currentUser.updatedAt,
          deviceTokens: updatedTokens,
        );

        print('✅ FCM token set in user model: $token');
      }
    }
  }

  void initLocalNotification() async {
    const androidChannel = AndroidNotificationChannel(
      "high_importance_channel",
      "High Importance Notifications",
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    const androidSettings = AndroidInitializationSettings("@drawable/ic_notification");
    const iosSettings = DarwinInitializationSettings();

    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
          print('🔔 Foreground notification tapped: ${response.payload}');
        },
        onDidReceiveBackgroundNotificationResponse:
        onDidReceiveBackgroundNotificationResponse,
      );
    } catch (e, stacktrace) {
      print('❌ Notification initialization error: $e\n$stacktrace');
    }
  }

  Future<void> firebaseInit() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📦 App opened from notification: ${message.notification?.title}');
      // You can add handler logic here
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('🟡 App launched from terminated state with notification');
        // You can add delayed handler logic here
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    String? imageUrl = message.notification?.android?.imageUrl ??
        message.notification?.apple?.imageUrl;

    BigPictureStyleInformation? bigPictureStyle;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      bigPictureStyle = BigPictureStyleInformation(
        FilePathAndroidBitmap(imageUrl),
        largeIcon: FilePathAndroidBitmap(imageUrl),
        contentTitle: notification?.title,
        summaryText: notification?.body,
      );
    }

    final androidDetails = AndroidNotificationDetails(
      "high_importance_channel",
      "High Importance Notifications",
      icon: '@drawable/ic_notification',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: bigPictureStyle,
    );

    final iosDetails = DarwinNotificationDetails(
      attachments: imageUrl != null
          ? [DarwinNotificationAttachment(imageUrl)]
          : [],
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification?.title,
      notification?.body,
      notificationDetails,
      payload: jsonEncode(message.data),
    );
  }

  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("📨 Background FCM received:");
    print("Title: ${message.notification?.title}");
    print("Body: ${message.notification?.body}");
    print("Data: ${message.data}");
  }
}