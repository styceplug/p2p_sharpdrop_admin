


import 'package:get/get.dart';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';

class NotificationRepo {
  final ApiClient apiClient;

  NotificationRepo({required this.apiClient});

  Future<Response> postDeviceToken(String endpoint, Map<String, dynamic> body) async {
    return await apiClient.putData(endpoint, body);
  }

  Future<Response> getNotifications() async {
    return await apiClient.getData(AppConstants.GET_NOTIFICATIONS);
  }

}
