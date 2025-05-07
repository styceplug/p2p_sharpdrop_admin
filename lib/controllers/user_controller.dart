import 'dart:convert';

import 'package:admin_p2p_sharpdrop/screens/auth_screen/signin_screen.dart';
import 'package:get/get.dart';
import 'package:admin_p2p_sharpdrop/models/channel_chat_model.dart';
import '../models/channel_model.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/api/api_client.dart';
import '../data/repo/user_repo.dart';
import '../models/user_model.dart';
import '../routes/routes.dart';
import '../utils/app_constants.dart';
import '../widgets/snackbars.dart';

class UserController extends GetxController {
  final UserRepo userRepo;
  final ApiClient apiClient;

  UserController({
    required this.userRepo,
    required this.apiClient
  });

  var isLoading = false.obs;
  var userDetail = Rxn<UserModel>();
  var channels = <ChannelModel>[].obs;



  Future<void> createChannel({required String name, required String color}) async {
    try {
      isLoading.value = true;

      Response response = await userRepo.createChannel(name: name, color: color);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body is String ? jsonDecode(response.body) : response.body;

        if (body != null && body['code'] == '00') {
          Get.offAllNamed(AppRoutes.bottomNav);
          MySnackBars.success(
            title: 'Channel Created',
            message: 'Channel "${body['data']['name']}" created successfully!',
          );

        } else {
          final message = body?['message']?.toString() ?? 'Channel creation failed';
          MySnackBars.failure(title: 'Failed', message: message);
        }
      } else {
        MySnackBars.failure(title: 'Error', message: 'Pls try again: ${response.body}');
      }
    } catch (e) {
      print('❌ Exception while creating channel: $e');
      MySnackBars.failure(
        title: 'Network Error',
        message: 'Please check your connection and try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUserDetails({bool forceRefresh = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Make network request first
      try {
        final response = await userRepo.getUserDetails();
        print('📦 Raw response: ${response.body}');
        final body = response.body is String ? jsonDecode(response.body) : response.body;
        print('📬 Parsed response: $body');

        if (response.statusCode == 200 && body != null && body['code'] == '00') {
          final user = UserModel.fromJson(body['data']);
          userDetail.value = user;

          // Save to cache
          await prefs.setString('cachedUserProfile', jsonEncode(body['data']));
          print('💾 User data cached');
          return; // Exit the function after successful network request
        } else {
          print('⚠️ Network request failed: ${body?['message'] ?? 'Unknown error'}');
          // If network request fails, continue to check cache
        }
      } catch (networkError) {
        print('📶 Network error: $networkError');
        // If network request throws exception, continue to check cache
      }

      // If network request failed or threw an exception, try loading from cache
      if (userDetail.value == null) {
        final cachedData = prefs.getString('cachedUserProfile');
        if (cachedData != null) {
          final parsedData = jsonDecode(cachedData);
          userDetail.value = UserModel.fromJson(parsedData);
          print('📦 Loaded user from cache as fallback');
          return;
        }
      }

      // If we reach here, both network and cache failed
      print('❌ No data available - neither network nor cache');
      authController.logOut();

    } catch (e) {
      print('❌ Exception caught: $e');
      authController.logOut();
    }
  }

  Future<void> getChannels() async {
    try {
      final Response response = await userRepo.getChannels();
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody['code'] == '00' && responseBody['data'] != null) {
          channels.value = (responseBody['data'] as List)
              .map((channelData) => ChannelModel.fromJson(channelData))
              .toList();
        } else {
          print('Failed to fetch channels: ${responseBody['message']}');
          channels.value = [];
        }
      } else {
        print('Failed to fetch channels. Status code: ${response.statusCode}');
        channels.value = [];
      }
    } catch (e) {
      print('Error fetching channels: $e');
      channels.value = [];
    }
  }







}
