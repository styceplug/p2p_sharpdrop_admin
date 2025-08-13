import 'package:admin_p2p_sharpdrop/models/user_model.dart';



import 'channel_model.dart';
import 'message_model.dart';

class ChannelChatModel {
  final String id;
  final ChannelModel channel;
  final UserModel user;
  final List<MessageModel> messages; // Changed to List<MessageModel>
  final int unreadCount;
  final int userUnreadCount;
  final int adminUnreadCount;
  final bool isActive;
  final DateTime startedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChannelChatModel({
    required this.id,
    required this.channel,
    required this.user,
    required this.messages,  // Updated to accept a list of MessageModel
    required this.unreadCount,
    required this.userUnreadCount,
    required this.adminUnreadCount,
    required this.isActive,
    required this.startedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChannelChatModel.fromJson(Map<String, dynamic> json) {
    return ChannelChatModel(
      id: json['_id'] ?? '',
      channel: (() {
        final ch = json['channel'];
        if (ch is String) {
          return ChannelModel(id: ch, name: '', color: '#000000');
        } else if (ch is Map<String, dynamic>) {
          return ChannelModel.fromJson(ch);
        } else {
          return ChannelModel(id: '', name: '', color: '#000000'); // fallback
        }
      })(),
      user: UserModel.fromJson(json['user']),
      messages: (json['messages'] as List)
          .map((messageJson) => MessageModel.fromJson(messageJson))
          .toList(),
      unreadCount: json['unreadCount'] ?? 0,
      userUnreadCount: json['userUnreadCount'] ?? 0,
      adminUnreadCount: json['adminUnreadCount'] ?? 0,
      isActive: json['isActive'] ?? true,
      startedAt: DateTime.tryParse(json['startedAt'] ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'channel': channel.toJson(),
      'user': user,
      'messages': messages.map((msg) => msg.toJson()).toList(),
      'unreadCount': unreadCount,
      'userUnreadCount': userUnreadCount,
      'adminUnreadCount': adminUnreadCount,
      'isActive': isActive,
      'startedAt': startedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
