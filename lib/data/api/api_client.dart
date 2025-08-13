import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_constants.dart';
import 'api_checker.dart';


class ApiClient extends GetConnect implements GetxService {
  late String token;
  final String appBaseUrl;
  late SharedPreferences sharedPreferences;

  late Map<String, String> _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    baseUrl = AppConstants.BASE_URL;
    timeout = const Duration(seconds: 30);
    token = sharedPreferences.getString(AppConstants.TOKEN) ?? "";
    _mainHeaders = {
      'Authorization': 'Bearer $token',
    };
  }

  void updateHeader(String token) {
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    sharedPreferences.setString(AppConstants.authToken, token);
    if (kDebugMode) {
      print('🔑 Header updated with token: $token');
    }
  }

  Future<Response> getData(String uri, {Map<String, String>? headers}) async {
    try {
      print('📡 GET: $baseUrl$uri');
      print('📤 Headers: ${headers ?? _mainHeaders}');
      final response = await get(uri, headers: headers ?? _mainHeaders);
      print("✅ Response: ${response.statusCode}, ${response.body}");
      return response;
    } catch (e) {
      print("❌ ERROR in getData($uri): $e");
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postData(String uri, dynamic body, {Map<String, String>? headers}) async {
    try {
      Response response = await post(uri, body, headers: headers ?? _mainHeaders);
      if (kDebugMode) {
        print('posting $appBaseUrl$uri $body ${headers ?? _mainHeaders}');
        print("response body ${response.body}");

        final responseSize = utf8.encode(response.body.toString()).length;
        print('Response Size for $uri: $responseSize bytes (${(responseSize / 1024).toStringAsFixed(2)} KB)');
      }

      return response;
    } catch (e,s) {
      if (kDebugMode) {
        print('from api post client');
        print(s);
        print(e.toString());
      }
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> putData(String uri, dynamic body, {Map<String, String>? headers}) async {
    try {

      Response response = await put(uri, body, headers: headers ?? _mainHeaders);
      if (kDebugMode) {
        print("putting ${response.body}");
        print("response body ${response.body}");

        final responseSize = utf8.encode(response.body.toString()).length;
        print('Response Size for $uri: $responseSize bytes (${(responseSize / 1024).toStringAsFixed(2)} KB)');
      }
      // ApiChecker.checkApi(response);
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('from api put client');
        print(e.toString());
      }
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postMultipartData(String uri, http.MultipartRequest request) async {
    try {
      // Add your main headers to the request
      request.headers.addAll(_mainHeaders);

      if (kDebugMode) {
        print('🧾 POST Multipart to $uri: ${request.fields}');
        print('🧾 Files: ${request.files.map((f) => f.field).join(', ')}');
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        print('📦 Response Status: ${response.statusCode}');
        print('📦 Response: ${response.body}');
      }

      return Response(
        statusCode: response.statusCode,
        body: response.body,
        statusText: response.reasonPhrase,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Multipart POST Error: $e');
      }
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> deleteData(String uri, {Map<String, String>? headers}) async {
    try {
      Response response = await delete(uri, headers: headers ?? _mainHeaders);
      if (kDebugMode) {
        print('deleting $appBaseUrl$uri');
        print("response body ${response.body}");

        final responseSize = utf8.encode(response.body.toString()).length;
        print('Response Size for $uri: $responseSize bytes (${(responseSize / 1024).toStringAsFixed(2)} KB)');
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('from api delete client');
        print(e.toString());
      }
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

}

