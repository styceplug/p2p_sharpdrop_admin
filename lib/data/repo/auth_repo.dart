import 'package:get/get_connect/http/src/response/response.dart';


import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });


  Future<Response> registerUser(Map<String, dynamic> data) async {
    return await apiClient.postData(AppConstants.REGISTER_USER, data);
  }

  Future<Response> loginUser(Map<String, dynamic> data) async {
    return await apiClient.postData(AppConstants.LOGIN_USER, data);
  }




}