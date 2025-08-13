import 'package:admin_p2p_sharpdrop/controllers/notification_controller.dart';
import 'package:admin_p2p_sharpdrop/data/repo/notification_repo.dart';
import 'package:get/get.dart';
import 'package:admin_p2p_sharpdrop/controllers/chat_controller.dart';
import 'package:admin_p2p_sharpdrop/models/channel_chat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/auth_controller.dart';
import '../controllers/user_controller.dart';
import '../data/api/api_client.dart';
import '../data/repo/auth_repo.dart';
import '../data/repo/chat_repo.dart';
import '../data/repo/user_repo.dart';
import '../utils/app_constants.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharedPreferences);

  //api clients
  Get.lazyPut(() => ApiClient(
      appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()));

  //repos
  Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => UserRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => ChatRepo(apiClient: Get.find()));
  Get.lazyPut(() => NotificationRepo(apiClient: Get.find()));


  //controllers
  Get.lazyPut(() => AuthController(authRepo: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => UserController(userRepo: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => ChatController(chatRepo: Get.find()));
  Get.lazyPut(() => NotificationController(notificationRepo: Get.find()));




}
