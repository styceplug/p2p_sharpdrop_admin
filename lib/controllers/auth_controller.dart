import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/api/api_client.dart';
import '../data/repo/auth_repo.dart';
import '../routes/routes.dart';
import '../widgets/snackbars.dart';

class AuthController extends GetxController {
  final AuthRepo authRepo;
  ApiClient apiClient;


  AuthController({required this.authRepo, required this.apiClient});

  final RxString authToken = ''.obs;
  var isLoading = false.obs;


  String getErrorMessage(String serverMessage) {
    // Check for duplicate key error (phone number already exists)
    if (serverMessage.contains('dup key') && serverMessage.contains('number')) {
      return 'This phone number is already registered. Please use a different number.';
    }

    switch (serverMessage.toLowerCase()) {
      case 'user with email already exists':
        return 'An account with this email already exists. Please log in or use a different email.';
      case 'invalid password':
        return 'The password you entered is incorrect. Please try again.';
      case 'invalid credentials':
        return 'Username or password is incorrect.';
      case 'account not found':
        return 'No account found with these details.';
      case 'invalid or expired token':
        return 'Your session has expired. Please log in again.';
      case 'unauthorized':
        return 'You are not authorized to perform this action.';
      default:
        return 'Something went wrong. Please try again later.';
    }
  }


  //Sign Up
  Future<void> initiateSignUp({
    required String firstName,
    required String lastName,
    required String email,
    required String number,
    required String password,
  }) async {
    isLoading.value = true;

    Map<String, dynamic> data = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'number': number,
      'password': password
    };

    try {
      Response response = await authRepo.registerUser(data);

      print('📦 Raw response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body is String ? jsonDecode(response.body) : response.body;

        if (body != null && body['code'] == '00') {
          final userId = body['data']?['id'] ?? '';

          if (userId.isNotEmpty) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('userId', userId);
          }

          MySnackBars.success(
            title: 'Account Creation Successful',
            message: 'User Created Successfully, kindly sign in now',
          );
          await saveToken('authToken');
          Get.offAllNamed(AppRoutes.signinScreen);
        } else {
          final message = body?['message']?.toString() ?? 'Signup failed';
          print('❌ Server responded with error: $message');

          MySnackBars.failure(
            title: 'Signup Failed',
            message: getErrorMessage(message),
          );
        }
      } else {
        print('❌ Registration failed with status code: ${response.statusCode}');
        MySnackBars.failure(
          title: 'Signup Failed',
          message: 'Server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ OTP request exception: $e');
      MySnackBars.failure(
        title: 'Network Error',
        message: 'Please check your connection and try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }





  // LOGIN ADMIN
  Future<void> login({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;

    Map<String, dynamic> data = {
      "email": email,
      "password": password,
    };

    try {
      Response response = await authRepo.loginUser(data);
      print('Controller link: 🔗 ${response.request?.url}');

      // If the body is a String, decode it
      final res = response.body is String
          ? jsonDecode(response.body)
          : response.body;

      if (response.statusCode == 200 && res['code'] == '00') {
        String token = res['data'];

        await saveToken(token);

        MySnackBars.success(
          title: 'Welcome Back',
          message: 'Lets attend to customers',
        );

        Get.offAllNamed(AppRoutes.bottomNav);

      } else {
        MySnackBars.failure(
          title: 'Login Failed',
          message: res['message'] ?? 'Unable to sign in at the moment',
        );
        print('❌ Login failed: ${res['message']}');
      }
    } catch (e) {
      print('Login exception: $e');
      MySnackBars.failure(
        title: 'Error',
        message: 'Something went wrong. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }



  // Save token to SharedPreferences & observable
  Future<void> saveToken(String token) async {
    authToken.value = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
    print('✅ Token saved: $token');
  }

// Retrieve token from SharedPreferences into observable
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken.value = prefs.getString('authToken') ?? '';

    if (authToken.value.isNotEmpty) {
      apiClient.updateHeader(authToken.value);
      print("✅ Header updated with token: ${authToken.value}");
    }
    if(authToken.value.isEmpty){
      logOut();
    }

    print('🔑 Token loaded: ${authToken.value}');
  }


  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed(AppRoutes.signinScreen);
  }


}