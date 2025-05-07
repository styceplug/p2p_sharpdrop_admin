import 'package:admin_p2p_sharpdrop/models/channel_chat_model.dart';
import 'package:admin_p2p_sharpdrop/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_p2p_sharpdrop/controllers/chat_controller.dart';
import 'package:admin_p2p_sharpdrop/routes/routes.dart';

import '../../models/message_model.dart';
import '../../models/sender_model.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

List<Sender> getUniqueSenders(List<MessageModel> messages) {
  final seen = <String>{};
  return messages
      .where((msg) =>
  msg.sender.role == 'user' && seen.add(msg.sender.id)) // Only users
      .map((msg) => msg.sender)
      .toList();
}

class _ChatRoomState extends State<ChatRoom> {
  final chatController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    final messages = chatController.channelChats.expand((c) => c.messages).toList();
    final senders = getUniqueSenders(messages);

    return Scaffold(
      appBar: AppBar(title: const Text('Chat Room Senders')),
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        child: senders.isEmpty
            ? const Center(
          child: Text(
            'No messages yet',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        )
            : ListView.builder(
          itemCount: senders.length,
          itemBuilder: (context, index) {
            final sender = senders[index];

            // Find the matching chat object for this sender
            final chat = chatController.channelChats.firstWhereOrNull(
                  (c) => c.user.id == sender.id,
            );

            final unreadCount = chat?.adminUnreadCount ?? 0;

            return ListTile(
              leading: CircleAvatar(
                child: Text(
                  sender.firstName?.isNotEmpty == true
                      ? sender.firstName![0].toUpperCase()
                      : '?',
                ),
              ),
              title: Text('${sender.firstName ?? ''} ${sender.lastName ?? ''}'),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(sender.email ?? ''),
                  if (unreadCount > 0)
                    Container(
                      padding: EdgeInsets.all(Dimensions.height5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.redAccent,
                      ),
                      child: Text(
                        unreadCount.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              onTap: () async {
                if (chat != null) {
                  await chatController.getSenderChats(chat.id);
                } else {
                  Get.snackbar('Chat Not Found', 'No chat available for this sender.');
                }
              },
            );
          },
        ),
      ),
    );
  }
}
