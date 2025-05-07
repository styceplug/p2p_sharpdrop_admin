import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:admin_p2p_sharpdrop/routes/routes.dart';
import 'package:admin_p2p_sharpdrop/widgets/snackbars.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/channel_model.dart';
import '../../utils/app_constants.dart';
import '../api/api_client.dart';

class UserRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  UserRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });


  Future<Response> createChannel({required String name, required String color}) async {
    try {
      final token = sharedPreferences.getString('authToken') ?? '';
      if (token.isEmpty) {
        Get.offAllNamed(AppRoutes.signinScreen);
        MySnackBars.failure(title: 'Sorry Could not identify Admin', message: 'Kindly sign in again and try creating the channel');
        throw Exception('No token found');
      }

      Map<String, dynamic> data = {
        "name": name,
        "color": color,
      };

      return await apiClient.postData(
        AppConstants.CREATE_CHANNEL,
        data,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      rethrow;
    }
  }


  Future<Response> getChannels() async {
    return await apiClient.getData(AppConstants.GET_CHANNELS);
  }

  Future<void> startChat(ChannelModel channel) async {
    try {
      final body = {
        'channel': channel.id, // only send id
      };

      Response response = await apiClient.postData('/chat/user/start', body);

      if (response.statusCode == 200 && response.body['code'] == '00') {
        // Chat started successfully
      } else {
        throw Exception('Failed to start chat');
      }
    } catch (e) {
      throw Exception('Failed to start chat: $e');
    }
  }


  Future<Response> getUserDetails() async {
    final token = sharedPreferences.getString('authToken');

    if (token == null || token.isEmpty) {
      print('❌ No token found in SharedPreferences!');
      Get.offAllNamed(AppRoutes.signinScreen);
    } else {
      print('✅ Token retrieved: $token');
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    print('🔁 getting ${AppConstants.GET_USER} $headers');
    return await apiClient.getData(AppConstants.GET_USER, headers: headers);
  }
  



}
