import 'dart:convert';
import 'dart:io';

import 'dart:typed_data' show Uint8List;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/channel_chat_model.dart';
import '../../models/media_model.dart';
import '../../models/message_model.dart';
import '../../utils/app_constants.dart';
import '../api/api_client.dart';

import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';


class ChatRepo {
  final ApiClient apiClient;

  ChatRepo({required this.apiClient});



  Future<List<ChannelChatModel>> getChannelChat(String channelId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    final response = await apiClient.getData(
      '/chat/v2/admin/channel/$channelId',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 && response.body['code'] == '00') {
      final List data = response.body['data'];
      return data.map((e) => ChannelChatModel.fromJson(e)).toList();
    } else {
      print('Error: ${response.body}');
      return [];
    }
  }


  Future<ChannelChatModel?> getSenderChat(String chatId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    final response = await apiClient.getData(
      '/chat/v2/admin/chat/$chatId',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 && response.body['code'] == '00') {
      return ChannelChatModel.fromJson(response.body['data']);
    } else {
      print('Error: ${response.body}');
      return null;
    }
  }

  Future<Response> sendTextMessage({
    required String chatId,
    required String content,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    return await apiClient.postData(
      AppConstants.POST_TEXT,
      {
        "chatId": chatId,
        "content": content,
      },
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<Map<String, dynamic>?> sendImageMessage({
    required String chatId,
    required File imageFile,
  }) async {
    try {
      // Get token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      if (token == null) {
        print('❌ No auth token found');
        return null;
      }

      var uri = Uri.parse('https://api.sharpdropapp.com/api/message/image');
      var request = http.MultipartRequest('POST', uri);

      // Add authorization header with actual token
      request.headers['Authorization'] = 'Bearer $token';

      // Add form field
      request.fields['chatId'] = chatId;

      // Attach the image file
      String mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
      String fileName = basename(imageFile.path);

      request.files.add(await http.MultipartFile.fromPath(
        'imageFile',
        imageFile.path,
        contentType: MediaType.parse(mimeType),
        filename: fileName,
      ));

      // Send the request
      var response = await request.send();

      if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final decodedBody = json.decode(responseBody) as Map<String, dynamic>;
        return decodedBody;
      } else {
        print('❌ Failed to upload image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Error while uploading image: $e');
      return null;
    }
  }


  Future<Map<String, dynamic>?> sendImageMessageBytes({
    required String chatId,
    required Uint8List imageBytes,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      if (token == null) {
        print('❌ No auth token found');
        return null;
      }

      var uri = Uri.parse('https://api.sharpdropapp.com/api/message/image');
      var request = http.MultipartRequest('POST', uri);

      // Add auth header
      request.headers['Authorization'] = 'Bearer $token';

      // Add chatId field
      request.fields['chatId'] = chatId;

      // Add image bytes
      request.files.add(
        http.MultipartFile.fromBytes(
          'imageFile',
          imageBytes,
          filename: 'image.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 201 && responseData.isNotEmpty) {
        return json.decode(responseData) as Map<String, dynamic>;
      } else {
        print('❌ Failed to upload image (code: ${response.statusCode})');
        print('Response: $responseData');
        return null;
      }
    } catch (e) {
      print('❌ Error sending image: $e');
      return null;
    }
  }


}