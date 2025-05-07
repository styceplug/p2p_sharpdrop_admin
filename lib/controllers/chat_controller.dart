import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:admin_p2p_sharpdrop/controllers/user_controller.dart';
import 'package:admin_p2p_sharpdrop/models/channel_model.dart';
import 'package:admin_p2p_sharpdrop/models/sender_model.dart';
import 'package:admin_p2p_sharpdrop/routes/routes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repo/chat_repo.dart';
import '../models/channel_chat_model.dart';
import '../models/media_model.dart';
import '../models/message_model.dart';
import '../utils/app_constants.dart';
import 'package:http/http.dart' as http;


class ChatController extends GetxController {
  final ChatRepo chatRepo;

  ChatController({required this.chatRepo});

  var isLoading = false.obs;
  var isSending = false.obs;
  var isUploading = false.obs;
  var channelChats = <ChannelChatModel>[].obs;
  var sender = <Sender>[].obs;
  var channel = <ChannelModel>[].obs;
  var chatMessages = <MessageModel>[].obs;
  Rx<Map<String,ChannelChatModel>> chatDetails = Rx<Map<String,ChannelChatModel>>({});
  var messageText = ''.obs;
  var isSendingImage = false.obs;
  Rxn<Media> uploadedMedia = Rxn<Media>();
  final ImagePicker _picker = ImagePicker();
  Rxn<File> selectedImage = Rxn<File>();
  RxBool isPreviewingImage = false.obs;


  UserController userController = Get.find<UserController>();


  Future<ChannelChatModel?> getSenderChats(String chatId) async {
    isLoading(true);
    print('Fetching chat details for chatId: $chatId');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.authToken) ?? '';
      print('Retrieved auth token: $token');
      String url = AppConstants.GET_SENDER_CHAT.replaceAll('{chatId}', chatId);
      print('Request URL: ${AppConstants.BASE_URL}$url');
      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL}$url'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print('Response Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('Response Body: ${response.body}');
        final chat = ChannelChatModel.fromJson(jsonResponse['data']);
        chatDetails.value[chatId] = chat;
        print('Came Messages: ${chatDetails.value[chatId]!.messages}');
        Get.toNamed(AppRoutes.messagingScreen, arguments: chat);
        update();
        return chat; // ✅ return the chat
      } else {
        // Get.snackbar('Error', 'Failed to load chat details.');
        print('Error: Failed to load chat details.');
        return null;
      }
    } catch (e,s) {
      // Get.snackbar('Error', 'Something went wrong. Please try again.');
      print('Error occurred: $e/$s');
      return null;
    } finally {
      isLoading(false);
      print('Loading state set to false');
    }
  }

  Future<void> refreshChats(String chatId) async {
    isLoading(true);
    print('Refreshing chat for chatId: $chatId');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.authToken) ?? '';
      print('Retrieved auth token: $token');
      String url = AppConstants.GET_SENDER_CHAT.replaceAll('{chatId}', chatId);
      print('Refresh URL: ${AppConstants.BASE_URL}$url');

      final response = await http.get(
        Uri.parse('${AppConstants.BASE_URL}$url'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Refresh Response Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('Refresh Response Body: ${response.body}');
        final updatedChat = ChannelChatModel.fromJson(jsonResponse['data']);
        chatDetails.value[chatId] = updatedChat;
        print('Updated Messages: ${updatedChat.messages}');
        update(); // Notify listeners
      } else {
        print('Refresh failed: status ${response.statusCode}');
      }
    } catch (e, s) {
      print('Refresh error: $e/$s');
    } finally {
      isLoading(false);
      print('Loading state set to false (refreshChats)');
    }
  }


  Future<void> sendMessage(String chatId) async {
    if (messageText.value.trim().isEmpty) return;
    isSending.value = true;
    try {
      final response = await chatRepo.sendTextMessage(
        chatId: chatId,
        content: messageText.value.trim(),
      );
      isSending.value = false;
      print(response.statusCode);
      if (response.statusCode == 201 || response.body['code'] == '00') {
        final messageData = response.body['data'];
        // final message = MessageModel.fromJson(messageData);
        /* final updatedChat = userController.chatDetails.value;
        if (updatedChat?.messages != null) {
          updatedChat?.messages.add(message);
        }
        userController.chatDetails.value = updatedChat;*/
        print('Sent Successfully');
        messageText.value = '';
      } else {
        final message = response.body['message'] ?? "Server error occurred.";
        print(message);
      }
    } catch (e,s) {
      isSending.value = false;
      Get.snackbar("Error", "Unexpected error: $e");
      print('Error inSending Message: ${e}, ${s}');
    }
  }

  void clearPreview() {
    selectedImage.value = null;
    isPreviewingImage.value = false;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
      isPreviewingImage.value = true;
    }
  }
  Future<void> sendPickedImage(String chatId) async {
    if (selectedImage.value == null) return;
    isUploading.value = true;
    final response = await chatRepo.sendImageMessage(
      chatId: chatId,
      imageFile: selectedImage.value!,
    );
    isUploading.value = false;
    if (response != null && response['code'] == '00') {
      await getSenderChats(chatId);
      clearPreview();
    } else {
      print(response);
    }
  }
  Future<void> sendImage({
    required String chatId,
    required File imageFile,
  }) async {
    try {
      isSendingImage.value = true;
      final media = await chatRepo.sendImageMessage(
        chatId: chatId,
        imageFile: imageFile,
      );
      if (media != null) {
        print('✅ Image uploaded successfully: ${media['data']['media']['url']}');
        // Handle the response or update UI
      } else {
        print('⚠️ Media upload failed');
      }
    } catch (e) {
      print('❌ Error while sending image: $e');
    } finally {
      isSendingImage.value = false;
    }
  }


  Future<void> getChannelChat(String channelId) async {
    try {
      isLoading.value = true;

      final chats = await chatRepo.getChannelChat(channelId);
      channelChats.value = chats;

      Get.toNamed(AppRoutes.chatRoom);
    } catch (e, s) {
      print("Error fetching channel chat: $e\n$s");
    } finally {
      isLoading.value = false;
    }
  }



  void addTempMessage(String chatId, MessageModel message) {
    chatDetails.value[chatId]?.messages.add(message);
    update();
  }


}
