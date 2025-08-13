import 'package:admin_p2p_sharpdrop/models/sender_model.dart';
import 'package:admin_p2p_sharpdrop/models/user_model.dart';

import 'media_model.dart';

class MessageModel {
  final String id;
  final String content;
  final String type;
  final Sender sender;
  final Media? media;
  final DateTime? createdAt;
  bool tempChat;

  MessageModel({
    required this.id,
    required this.content,
    required this.type,
    required this.sender,
     this.media,
    this.createdAt,
    this.tempChat = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
      type: json['type'] ?? '',
      sender: json['sender'] != null
          ? Sender.fromJson(json['sender'])
          : Sender.empty(),
      media: json['media'] != null ? Media.fromJson(json['media']) : Media(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      tempChat: json['tempChat'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'content': content,
      'type': type,
      'sender': sender.toJson(),
      'media': media?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'tempChat' : tempChat,
    };
  }

  factory MessageModel.empty() => MessageModel(
    id: '',
    sender: Sender.empty(),
    content: '',
    type: '',
    createdAt: DateTime.now(),
    media: Media.empty(),
  );
}